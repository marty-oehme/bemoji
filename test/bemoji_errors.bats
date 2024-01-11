#!/usr/bin/env bash

setup_file() {
    # make bemoji executable from anywhere relative to current testfile
    TEST_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$TEST_DIR/..:$PATH"
}

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    # set up small default set of test emoji for each test
    export BEMOJI_DB_LOCATION="$BATS_TEST_TMPDIR/database"
    export BEMOJI_HISTORY_LOCATION="$BATS_TEST_TMPDIR/history"
    mkdir -p "$BEMOJI_DB_LOCATION" "$BEMOJI_HISTORY_LOCATION"
    cat "$BATS_TEST_DIRNAME/resources/test_emoji.txt" > "$BEMOJI_DB_LOCATION/emoji.txt"

    # these tests require stdout to be separated from stderr
    # such run flags were only introduced in recent bats version
    bats_require_minimum_version 1.5.0
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
