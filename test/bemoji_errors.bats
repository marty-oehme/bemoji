#!/usr/bin/env bash

setup() {
    # these tests require stdout to be separated from stderr
    # such run flags were only introduced in recent bats version
    bats_require_minimum_version 1.5.0

    load 'common_setup'
    _common_setup
}

@test "Prints clipper error to stderr" {
    BEMOJI_PICKER_CMD="echo hi" run --separate-stderr bemoji 3>&-
    assert_output ""
    output="$stderr"
    assert_output "No suitable clipboard tool found."
}

@test "Prints picker error to stderr" {
    run --separate-stderr bemoji 3>&-
    assert_output ""
    output="$stderr"
    assert_output "No suitable picker tool found."
}

@test "Prints typer error to stderr" {
    BEMOJI_PICKER_CMD="echo hi" run --separate-stderr bemoji -t 3>&-
    assert_output ""
    output="$stderr"
    assert_output "No suitable typing tool found."
}
