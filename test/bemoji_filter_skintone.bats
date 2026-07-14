#!/usr/bin/env bash

setup() {
    bats_require_minimum_version 1.5.0
    load 'common_setup'
    _common_setup

    FILTER_SCRIPT="$PROJECT_ROOT/filters/skintone"
}

@test "skintone medium keeps only medium skin tone variants" {
    run "$FILTER_SCRIPT" medium < "$BATS_TEST_DIRNAME/resources/skintone_emoji.txt"
    assert_success
    assert_output --partial "👋🏽 waving hand: medium skin tone"
    assert_output --partial "👍🏽 thumbs up: medium skin tone"
    refute_output --partial "light skin tone"
    refute_output --partial "medium-light skin tone"
    refute_output --partial "medium-dark skin tone"
    refute_output --partial "dark skin tone"
}

@test "skintone medium-light keeps only medium-light, not medium" {
    run "$FILTER_SCRIPT" medium-light < "$BATS_TEST_DIRNAME/resources/skintone_emoji.txt"
    assert_success
    assert_output --partial "👋🏼 waving hand: medium-light skin tone"
    assert_output --partial "👍🏼 thumbs up: medium-light skin tone"
    refute_output --partial "medium skin tone"
    refute_output --partial "medium-dark skin tone"
}

@test "skintone preserves non-skin-tone emoji" {
    run "$FILTER_SCRIPT" medium < "$BATS_TEST_DIRNAME/resources/skintone_emoji.txt"
    assert_success
    assert_output --partial "🤝 handshake"
    assert_output --partial "❤️ red heart"
    assert_output --partial "😀 grinning face"
}

@test "skintone invalid arg produces error" {
    run "$FILTER_SCRIPT" invalid
    assert_failure
    assert_output --partial "Usage: skintone"
}
