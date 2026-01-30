#!/usr/bin/env bash
set -euo pipefail

# Very small coverage helper
# Usage: ./scripts/coverage_min.sh [BAZEL_TARGET]
# Example: ./scripts/coverage_min.sh //:calculator_test
TARGET="${1:-//:calculator_test}"

if ! command -v genhtml >/dev/null 2>&1; then
  echo "Please install lcov (provides genhtml). Example: sudo apt install lcov"
  exit 1
fi

# Run coverage (produces an lcov report file)
bazel coverage "$TARGET" --combined_report=lcov

# Find common report names
REPORT=$(find . -type f -name "_coverage_report.dat" -o -name "coverage.dat" -o -name "coverage.info" -print -quit || true)
if [[ -z "$REPORT" ]]; then
  echo "Coverage report not found. Check Bazel output for the generated report path."
  exit 1
fi

mkdir -p coverage_html
genhtml -o coverage_html "$REPORT"

echo "Done. Open coverage_html/index.html to view the report."
