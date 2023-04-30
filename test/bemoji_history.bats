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
    export BEMOJI_HISTORY_LOCATION="$BATS_TEST_TMPDIR/history"
    mkdir -p "$BEMOJI_DB_LOCATION" "$BEMOJI_HISTORY_LOCATION"
    cat "$BATS_TEST_DIRNAME/resources/test_emoji.txt" > "$BEMOJI_DB_LOCATION/emoji.txt"
}

@test "sorts by frecency" {
    echo -e "there\nhello\nhello" > "$BEMOJI_HISTORY_LOCATION/bemoji-history.txt"
    echo -e "database" > "$BEMOJI_DB_LOCATION/emoji.txt"
    BEMOJI_CLIP_CMD="cat -" BEMOJI_PICKER_CMD="cat -" run bemoji 3>&-
    assert_output "hellotheredatabase"
}

@test "history limiting uses sorted results" {
    echo -e "zany\nmy\nisee\nonomatopeia" > "$BEMOJI_HISTORY_LOCATION/bemoji-history.txt"
    echo -e "database" > "$BEMOJI_DB_LOCATION/emoji.txt"
    BEMOJI_CLIP_CMD="cat -" BEMOJI_PICKER_CMD="cat -" run bemoji -P 1 3>&-
    assert_output "iseedatabase"
}

@test "history limiting takes frecency into account" {
    echo -e "there\nfriend\nhello\nhello" > "$BEMOJI_HISTORY_LOCATION/bemoji-history.txt"
    echo -e "database" > "$BEMOJI_DB_LOCATION/emoji.txt"
    BEMOJI_CLIP_CMD="cat -" BEMOJI_PICKER_CMD="cat -" run bemoji -P 1 3>&-
    assert_output "hellodatabase"
}

@test "-P 0 disables history" {
    echo -e "there\nfriend\nhello\nhello" > "$BEMOJI_HISTORY_LOCATION/bemoji-history.txt"
    echo -e "database" > "$BEMOJI_DB_LOCATION/emoji.txt"
    BEMOJI_CLIP_CMD="cat -" BEMOJI_PICKER_CMD="cat -" run bemoji -P 0 3>&-
    assert_output "database"
}

@test "BEMOJI_LIMIT_RECENT=0 disables history" {
    echo -e "there\nfriend\nhello\nhello" > "$BEMOJI_HISTORY_LOCATION/bemoji-history.txt"
    echo -e "database" > "$BEMOJI_DB_LOCATION/emoji.txt"
    BEMOJI_LIMIT_RECENT=0 BEMOJI_CLIP_CMD="cat -" BEMOJI_PICKER_CMD="cat -" run bemoji 3>&-
    assert_output "database"
}

