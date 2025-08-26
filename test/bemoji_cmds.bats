#!/usr/bin/env bash

setup() {
    load 'common_setup'
    _common_setup

    # mock out interactive picker for static emoji return
    export BEMOJI_PICKER_CMD="echo ❤️"
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
    BEMOJI_PICKER_CMD="echo totype" BEMOJI_TYPE_CMD="echo typing result" run bemoji -t 3>&-
    assert_output "typing result totype"
}

@test "Runs typing and clipping on -ct options" {
    BEMOJI_PICKER_CMD="echo totype" BEMOJI_CLIP_CMD="echo clipping result" BEMOJI_TYPE_CMD="echo typing result" run bemoji -ct 3>&-
    assert_output \
"clipping result
typing result totype"
}

@test "Passes selection to custom typer tool through stdin" {
    BEMOJI_TYPE_CMD="printf " run bemoji -t 3>&-
    assert_output "❤️"
}

@test "Runs custom default command" {
    BEMOJI_DEFAULT_CMD="echo my custom command" run bemoji 3>&-
    assert_output "my custom command"
}

@test "Using command option overrides custom default command" {
    BEMOJI_DEFAULT_CMD="echo my custom command" BEMOJI_CLIP_CMD="echo my clipping" run bemoji -c 3>&-
    assert_output "my clipping"
}

@test "Returns status code 1 on picker status code 1" {
    BEMOJI_PICKER_CMD="return 1" run bemoji -e 3>&-
    assert_failure 1
}

@test "Prints output with newline by default" {
    bats_require_minimum_version 1.5.0
    BEMOJI_PICKER_CMD="echo heart" run --keep-empty-lines -- bemoji -e
    assert_output --regexp '^heart
$'
}

@test "Prints output without newline on -n option" {
    bats_require_minimum_version 1.5.0
    BEMOJI_PICKER_CMD="echo heart" run --keep-empty-lines -- bemoji -ne
    assert_output --regexp '^heart$'
}

@test "Understands long-form options" {
    run bemoji --help
    assert_success
    assert_output --partial "A simple emoji picker."
}

@test "Understands long-form equals values" {
    BEMOJI_CLIP_CMD="echo heart" run bemoji --hist-limit=0
    assert_success
}

@test "Understands long-form spaced values" {
    BEMOJI_CLIP_CMD="echo heart" run bemoji --hist-limit 0
    assert_success
}

@test "Understands short-form spaced values" {
    BEMOJI_CLIP_CMD="echo heart" run bemoji -P 0
    assert_success
}

@test "Can concatenate short-form options and values" {
    BEMOJI_CLIP_CMD="echo heart" run bemoji -neP0
    assert_success
}
