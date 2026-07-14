#!/usr/bin/env bash

setup() {
    bats_require_minimum_version 1.5.0
    load 'common_setup'
    _common_setup

    FILTER_SCRIPT="$PROJECT_ROOT/filters/word"
}

@test "word filter removes emoji containing specified word" {
    run "$FILTER_SCRIPT" heart < "$BATS_TEST_DIRNAME/resources/test_emoji.txt"
    assert_success
    refute_output --partial "red heart"
    assert_output --partial "grinning face"
}

@test "word filter removes emoji containing multiple words" {
    run "$FILTER_SCRIPT" heart grinning < "$BATS_TEST_DIRNAME/resources/test_emoji.txt"
    assert_success
    refute_output --partial "red heart"
    refute_output --partial "grinning face"
}

@test "word filter with no args produces error" {
    run "$FILTER_SCRIPT"
    assert_failure
    assert_output --partial "Usage: word"
}
