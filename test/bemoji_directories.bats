#!/usr/bin/env bash

setup() {
    load 'common_setup'
    _common_setup
}

@test "can run script" {
    export BEMOJI_PICKER_CMD="echo blub"
    export BEMOJI_CLIP_CMD="echo clip test only"
    # closing FD3 manually to prevent hangs, see
    # https://bats-core.readthedocs.io/en/stable/writing-tests.html#file-descriptor-3-read-this-if-bats-hangs
    run bemoji 3>&-
    assert_success
}

@test "sets XDG directory for db by default" {
    unset BEMOJI_DB_LOCATION
    export XDG_DATA_HOME="$BATS_TEST_TMPDIR/xdb-db"
    run bemoji -v
    assert_output --regexp "
database=$BATS_TEST_TMPDIR/xdb-db/bemoji
"
}

@test "sets XDG directory for history by default" {
    unset BEMOJI_HISTORY_LOCATION
    export XDG_STATE_HOME="$BATS_TEST_TMPDIR/xdb-cache"
    run bemoji -v
    assert_output --regexp "
history=$BATS_TEST_TMPDIR/xdb-cache/bemoji-history.txt$"
}

@test "falls back to default db directory if no XDG found" {
    unset BEMOJI_DB_LOCATION
    run bemoji -v
    assert_output --regexp "
database=$HOME/.local/share/bemoji
"
}

@test "falls back to default history location if no XDG found" {
    unset BEMOJI_HISTORY_LOCATION
    run bemoji -v
    assert_output --regexp "
history=$HOME/.local/state/bemoji-history.txt$"
}

@test "BEMOJI_DB_LOCATION sets correct db directory" {
    run bemoji -v
    assert_output --regexp "
database=$BATS_TEST_TMPDIR/database
"
}

@test "BEMOJI_HISTORY_LOCATION sets correct history directory" {
    run bemoji -v
    assert_output --regexp "
history=$BATS_TEST_TMPDIR/history/bemoji-history.txt$"
}
