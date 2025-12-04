#!/usr/bin/env bash

setup() {
    load 'common_setup'
    _common_setup
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

