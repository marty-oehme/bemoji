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

@test "Empty db directory produces error" {
    # Create empty db directory with no .txt files
    empty_db="$BATS_TEST_TMPDIR/empty_db"
    mkdir -p "$empty_db"
    # Set invalid custom list to skip prepare_db download
    BEMOJI_DB_LOCATION="$empty_db" BEMOJI_CUSTOM_LIST="invalid" run --separate-stderr bemoji 3>&-
    [ "$status" -ne 0 ]
    output="$stderr"
    assert_output "No emoji database files found in $empty_db"
}
