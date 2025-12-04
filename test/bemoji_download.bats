#!/usr/bin/env bash

setup_file() {
    # make bemoji executable from anywhere relative to current testfile
    TEST_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$TEST_DIR/..:$PATH"
}

setup() {
    export BATS_LIB_PATH="${BATS_LIB_PATH}:${PWD}/vendor/:/usr/lib"
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-mock/stub.bash

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
@test "Runs nerdfont download on -D nerd option" {
    stub curl \
        "printf 'meangingless\nafiller lines\n.nf-md-pipe_wrench:before { \n content: \"\\\f1354\";\n }'"
    run bemoji -D nerd 3>&-
    outcome=$(cat "$BEMOJI_DB_LOCATION/nerdfont.txt")
    assert_equal "$outcome" "󱍔 md-pipe_wrench"
    unstub curl
}
