load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "calculator",
    srcs = ["calculator.cpp"],
    hdrs = ["calculator.h"],
    visibility = ["//visibility:public"],
)

cc_test(
    name = "calculator_test",
    srcs = [
        "calculator_test.cpp",
        "test_main.cpp",  # If this defines main(), use :gtest below.
    ],
    deps = [
        ":calculator",
        "@googletest//:gtest_main",  # or :gtest if you provide main()
    ],
)
