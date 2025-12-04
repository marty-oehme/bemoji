#!/usr/bin/env bash

setup() {
    load 'common_setup'
    _common_setup

    # additionally need mock library to stub downloading
    bats_load_library bats-mock/stub.bash
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
