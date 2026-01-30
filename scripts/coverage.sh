#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/coverage.sh [BAZEL_TARGET]
# Example: ./scripts/coverage.sh //:calculator_test
TARGET="${1:-//:calculator_test}"
TMP_LOG=$(mktemp)

# Run Bazel coverage and capture output
bazel coverage "$TARGET" --combined_report=lcov |& tee "$TMP_LOG"

# Try to extract the coverage report path from Bazel output
REPORT=$(grep -oP 'Coverage report: \K.*' "$TMP_LOG" || true)
if [[ -z "$REPORT" ]]; then
  # fallback: search for common coverage report filenames
  REPORT=$(find "$(pwd)" -type f \( -name "*coverage*.dat" -o -name "*coverage*.info" -o -name "_coverage_report.dat" \) 2>/dev/null | head -n1 || true)
fi

if [[ -z "$REPORT" ]]; then
  echo "Could not find coverage report. Bazel output saved to: $TMP_LOG"
  exit 1
fi

mkdir -p coverage_html
if ! command -v genhtml >/dev/null 2>&1; then
  echo "genhtml not found — please install lcov (e.g. 'sudo apt install lcov' or 'brew install lcov')"
  echo "Coverage report is at: $REPORT"
  exit 1
fi

genhtml -o coverage_html "$REPORT"

echo "Coverage HTML generated at: $(pwd)/coverage_html/index.html"
