#!/usr/bin/env bash

setup_file() {
    # make bemoji executable from anywhere relative to current testfile
    TEST_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$TEST_DIR/..:$PATH"
}

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load 'test_helper/mocks/stub'

    # mock out interactive picker for static emoji return
    export BEMOJI_PICKER_CMD="echo heart"

    # set up small default set of test emoji for each test
    export BEMOJI_DB_LOCATION="$BATS_TEST_TMPDIR/database"
    export BEMOJI_HISTORY_LOCATION="$BATS_TEST_TMPDIR/history"
    mkdir -p "$BEMOJI_DB_LOCATION" "$BEMOJI_HISTORY_LOCATION"
}

@test "Runs emoji download on -D emoji option" {
    stub curl \
        "echo -e '1F605  ; fully-qualified # emoji E0.6 grinning face with sweat\nnot picked up\n1F605  ; fully-qualified # emoji2 E0.6 picked up'"
    run bemoji -D emojis 3>&-
    outcome=$(cat "$BEMOJI_DB_LOCATION/emojis.txt")
    assert_equal "$outcome" "emoji grinning face with sweat
emoji2 picked up"
    unstub curl
}

@test "Runs maths download on -D maths option" {
    stub curl \
        "echo '03A3;A;Σ;Sigma;ISOGRK3;;GREEK CAPITAL LETTER SIGMA'"
    run bemoji -D math 3>&-
    outcome=$(cat "$BEMOJI_DB_LOCATION/math.txt")
    assert_equal "$outcome" "Σ GREEK CAPITAL LETTER SIGMA"
    unstub curl
}
