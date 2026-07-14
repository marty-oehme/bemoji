#!/usr/bin/env bash

setup() {
    bats_require_minimum_version 1.5.0
    load 'common_setup'
    _common_setup

    mkdir -p "$BEMOJI_DB_LOCATION/filters"
}

@test "filter not found produces error" {
    BEMOJI_PICKER_CMD="cat -" run --separate-stderr bemoji -ne -F nonexistent 3>&-
    assert_failure
    [[ "$stderr" == *"not found"* ]]
}

@test "filter not executable produces error" {
    printf '#!/bin/sh\ncat\n' > "$BEMOJI_DB_LOCATION/filters/myfilter"
    BEMOJI_PICKER_CMD="cat -" run --separate-stderr bemoji -ne -F myfilter 3>&-
    assert_failure
    [[ "$stderr" == *"not executable"* ]]
}

@test "filter execution failure produces error" {
    printf '#!/bin/sh\nexit 1\n' > "$BEMOJI_DB_LOCATION/filters/failfilter"
    chmod +x "$BEMOJI_DB_LOCATION/filters/failfilter"
    BEMOJI_PICKER_CMD="cat -" run --separate-stderr bemoji -ne -F failfilter 3>&-
    assert_failure
    [[ "$stderr" == *"failed"* ]]
}

@test "filter with valid args produces filtered output" {
    printf '#!/bin/sh\ngrep "$1"\n' > "$BEMOJI_DB_LOCATION/filters/grepfilter"
    chmod +x "$BEMOJI_DB_LOCATION/filters/grepfilter"
    BEMOJI_PICKER_CMD="cat -" run bemoji -e -F "grepfilter=heart" 3>&-
    assert_output --partial "❤️"
    refute_output --partial "😀"
}

@test "filter with no args receives empty arg" {
    local args_file="$BATS_TEST_TMPDIR/filter_args.txt"
    printf '#!/bin/sh\necho "$1" > "%s"\ncat\n' "$args_file" > "$BEMOJI_DB_LOCATION/filters/argtest"
    chmod +x "$BEMOJI_DB_LOCATION/filters/argtest"
    BEMOJI_PICKER_CMD="cat -" run bemoji -e -F argtest 3>&-
    assert_output --partial "❤️"
    args_content=$(cat "$args_file")
    [ -z "$args_content" ]
}

@test "no filter specified works normally" {
    BEMOJI_PICKER_CMD="cat -" BEMOJI_CLIP_CMD="cat -" run bemoji 3>&-
    assert_success
    assert_output --partial "❤️"
    assert_output --partial "😀"
}

@test "long-form --filter option works" {
    printf '#!/bin/sh\ngrep "$1"\n' > "$BEMOJI_DB_LOCATION/filters/grepfilter"
    chmod +x "$BEMOJI_DB_LOCATION/filters/grepfilter"
    BEMOJI_PICKER_CMD="cat -" run bemoji -e --filter "grepfilter=grinning" 3>&-
    assert_output --partial "😀"
    refute_output --partial "❤️"
}

@test "long-form --filter= option works" {
    printf '#!/bin/sh\ngrep "$1"\n' > "$BEMOJI_DB_LOCATION/filters/grepfilter"
    chmod +x "$BEMOJI_DB_LOCATION/filters/grepfilter"
    BEMOJI_PICKER_CMD="cat -" run bemoji -e --filter="grepfilter=grinning" 3>&-
    assert_output --partial "😀"
    refute_output --partial "❤️"
}
