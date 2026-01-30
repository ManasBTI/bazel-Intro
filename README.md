# Bazel Primer — Hands-on guide for this repo

This README teaches Bazel from first principles and walks through how this repository (`bazel_calculator_fresh`) is organized, how to build and test the C++ calculator example, and how to extend the project.

**Who this is for:** developers new to Bazel and C++ builds who want a practical, runnable example.

---

**Quick start**

- **Build the project:**

```bash
# from repository root
bazel build //:all
```

- **Run tests:**

```bash
bazel test //:calculator_test
```

If you prefer a single target: `bazel test //:calculator_test`.

---

**Repository layout (important files)**

- `WORKSPACE` — Bazel workspace marker (root of Bazel workspace).
- `BUILD` — top-level BUILD file that declares targets for this tiny example.
- `calculator.cpp`, `calculator.h` — source for the example library.
- `calculator_test.cpp` — unit tests.
- `test_main.cpp` — test runner helper used by the test target.

Open these files to follow along; this README contains examples matching their usage.

---

**Bazel concepts (brief)**

- Workspace: a directory with a `WORKSPACE` file. It contains all sources and BUILD files.
- BUILD files: declare targets like `cc_library`, `cc_binary`, `cc_test`.
- Targets: buildable/testable units. Labels look like `//path/to:target`.
- `bazel build` vs `bazel test`: `build` compiles artifacts; `test` builds and runs tests.

---

**How this repo's BUILD may look (example)**

This repository uses simple C++ rules. A minimal `BUILD` for the files in this repo could be:

```python
cc_library(
    name = "calculator",
    srcs = ["calculator.cpp"],
    hdrs = ["calculator.h"],
    visibility = ["//visibility:public"],
)

cc_test(
    name = "calculator_test",
    srcs = ["calculator_test.cpp", "test_main.cpp"],
    deps = [":calculator"],
)
```

If your repository already has a `BUILD` file, open it to confirm targets and dependencies.

---

**Detailed workflow and examples**

1) Build a single target (fast):

```bash
bazel build //:calculator
```

2) Run the binary (if you have a `cc_binary` target):

```bash
bazel run //:my_binary
```

3) Run tests with verbose output:

```bash
bazel test //:calculator_test --test_output=all
```

4) Clean Bazel cache (when things look stale):

```bash
bazel clean --expunge
```

5) Inspect build graph for a target:

```bash
bazel query --noimplicit_deps --notool_deps 'deps(//:calculator_test)'
```

---

**Adding a new source or test**

Suppose you add `math_utils.cpp` and `math_utils.h`. Update `BUILD`:

```python
cc_library(
    name = "math_utils",
    srcs = ["math_utils.cpp"],
    hdrs = ["math_utils.h"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "calculator",
    srcs = ["calculator.cpp"],
    hdrs = ["calculator.h"],
    deps = [":math_utils"],
)
```

Then run `bazel build //:calculator` to compile with the new dependency.

---

**Common problems & troubleshooting**

- Build fails due to missing header: ensure the header is listed in `hdrs` or included in `srcs` if private.
- Linker errors: check that all `cc_library` dependencies are listed in `deps`.
- Test failing locally but passing CI: run `bazel test` with `--test_output=errors` or `--test_output=all` to see logs.
- Change not picked up: try `bazel clean --expunge` (expensive), or `bazel build --expunge` if disk cache corrupted.

---

**Bazel flags you will often use**

- `--test_output=all` — show full test logs.
- `--sandbox_debug` — helpful for debugging sandbox-related issues.
- `--compilation_mode=dbg|opt|fastbuild` — choose debug/optimized builds.
- `--config=...` — use named configs from your `.bazelrc` if present.

---

**Editor / IDE tips**

- VS Code: install the `Bazel` extension (search marketplace) or use Bazelisk in the terminal.
- Configure `launch.json` to run `bazel build` before launching if you debug within the editor.

---

**A short C++ example (complete)**

`calculator.h` (already in this repo):

```cpp
// calculator.h
#pragma once

int add(int a, int b);
int sub(int a, int b);
```

`calculator.cpp`:

```cpp
#include "calculator.h"

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
```

`calculator_test.cpp` (uses your test framework; adjust if using gtest):

```cpp
#include "calculator.h"
#include <cassert>

int main() {
    assert(add(2,3) == 5);
    assert(sub(5,2) == 3);
    return 0;
}
```

Then add a `cc_test` entry in `BUILD` and run `bazel test //:calculator_test`.

---

## Code coverage ✅

This repository supports generating LCOV coverage reports for C++ tests using Bazel and `lcov`/`genhtml`.

- Install tools:
  - Debian/Ubuntu: `sudo apt install lcov`
  - macOS (Homebrew): `brew install lcov`

- Generate an LCOV report:

```bash
# run coverage for the calculator test and produce an lcov report
bazel coverage //:calculator_test --combined_report=lcov
```

- Generate HTML from the LCOV report using `genhtml`:

```bash
# find the generated LCOV report and create HTML output
# (or use the helper script below)
genhtml -o coverage_html path/to/_coverage_report.dat
# open coverage_html/index.html
```

- Helper script:
  - `scripts/coverage.sh` will run coverage and create `coverage_html/` automatically. Make it executable: `chmod +x scripts/coverage.sh`
  - Usage: `./scripts/coverage.sh //:calculator_test` (target defaults to `//:calculator_test`).

---

**Next steps I recommend**

- Open `BUILD`, `WORKSPACE`, `calculator.cpp`, and `calculator_test.cpp` to follow along.
- Run `bazel test //:calculator_test` to see tests run locally.
- Ask me to add a `cc_binary` target, add CI instructions, or configure a VS Code debug profile next.

---

If you'd like, I can: add a `README.md` (this file), run the tests to confirm, or extend this README with CI (GitHub Actions) and VS Code launch/debug configurations. Which would you like next?
