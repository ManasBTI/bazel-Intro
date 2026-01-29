load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "calculator",
    srcs = ["calculator.cpp"],
    hdrs = ["calculator.h"],
)

cc_test(
    name = "calculator_test",
    srcs = [
        "calculator_test.cpp",
        "test_main.cpp",
    ],
    deps = [
        ":calculator",
        "@googletest//:gtest",
    ],
)

