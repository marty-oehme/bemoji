#!/usr/bin/env bash

setup_file() {
    # make bemoji executable from anywhere relative to current testfile
    TEST_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$TEST_DIR/..:$PATH"
}

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    # mock out interactive picker for static emoji return
    export BEMOJI_PICKER_CMD="echo ❤️"

    # set up small default set of test emoji for each test
    export BEMOJI_DB_LOCATION="$BATS_TEST_TMPDIR/database"
    export BEMOJI_CACHE_LOCATION="$BATS_TEST_TMPDIR/cache"
    mkdir -p "$BEMOJI_DB_LOCATION" "$BEMOJI_CACHE_LOCATION"
    cat "$BATS_TEST_DIRNAME/resources/test_emoji.txt" > "$BEMOJI_DB_LOCATION/emoji.txt"
}

@test "-v prints correct version number" {
    the_version=$(grep 'bm_version=' "$(which bemoji)")

    run bemoji -v
    assert_output --partial "v${the_version#bm_version=}"
}

@test "Runs clipping command by default" {
    BEMOJI_CLIP_CMD="echo clipping default" run bemoji 3>&-
    assert_output "clipping default"
}

@test "Runs echo command on -e option" {
    run bemoji -e 3>&-
    assert_output "❤️"
}

@test "Runs clipping command on -c option" {
    BEMOJI_CLIP_CMD="echo clipping result" run bemoji -c 3>&-
    assert_output "clipping result"
}

@test "Runs typing command on -t option" {
    BEMOJI_TYPE_CMD="echo typing result" run bemoji -t 3>&-
    assert_output "typing result"
}

@test "Runs typing and clipping on -ct options" {
    BEMOJI_CLIP_CMD="echo clipping result" BEMOJI_TYPE_CMD="echo typing result" run bemoji -ct 3>&-
    assert_output \
"clipping result
typing result"
}

@test "Runs custom default command" {
    BEMOJI_DEFAULT_CMD="echo my custom command" run bemoji 3>&-
    assert_output "my custom command"
}

@test "Using command option overrides custom default command" {
    BEMOJI_DEFAULT_CMD="echo my custom command" BEMOJI_CLIP_CMD="echo my clipping" run bemoji -c 3>&-
    assert_output "my clipping"
}
