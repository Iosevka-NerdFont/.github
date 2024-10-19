#!/bin/bash

README_PATH="./profile/README.md"

EXCLUDED_REPOSITORIES='["workflows", "test-workflow", ".github"]'

HEADER="$(cat <<HEADER
# Iosevka NerdFont
This organization contains a repository for each released [Iosevka](https://github.com/be5invis/Iosevka) font style set.

A repository contains the style set font files (in TTF format) patched with Nerd Font glyphs.
HEADER
)"

PATCHED_FONT_LIST="$(cat <(echo ""; echo "## Repository list") <(
    echo "| Variant | Patch status |"
    echo "| --- | --- |"
    eval "jq -s -r 'sort_by(.name) | map(\"| [\" + .name + \"](\" + .url + \") | [![Patch font](https://github.com/Iosevka-NerdFont/\" + .name + \"/actions/workflows/patch.yaml/badge.svg?branch=main)](https://github.com/Iosevka-NerdFont/\" + .name +\"/workflows/patch.yaml) |\") | .[]'" <(
    curl -fsSL \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/orgs/Iosevka-NerdFont/repos?per_page=100&page=1" | \
        eval "jq -r 'map(select(.name as \$value | ${EXCLUDED_REPOSITORIES} | index(\$value) == null)) | map({\"name\": .name, \"url\": .html_url}) | .[]'"
    curl -fsSL \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/orgs/Iosevka-NerdFont/repos?per_page=100&page=2" | \
        eval "jq -r 'map(select(.name as \$value | ${EXCLUDED_REPOSITORIES} | index(\$value) == null)) | map({\"name\": .name, \"url\": .html_url}) | .[]'"
    )
    )
)"


echo "${HEADER}" > "${README_PATH}"
echo "${PATCHED_FONT_LIST}" >> "${README_PATH}"

