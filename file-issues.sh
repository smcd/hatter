#!/usr/bin/env bash
# Create the epic and its sub-issues on GitHub once a repo exists.
#   gh auth login
#   gh repo create <owner>/<name> --private        # flip to public later
#   ./file-issues.sh <owner>/<name>
set -euo pipefail

REPO="${1:?usage: ./file-issues.sh <owner>/<repo>}"

declare -a NUMS=()
for f in issues/*.md; do
    title=$(head -1 "$f" | sed 's/^# [0-9]*\. *//')
    url=$(gh issue create --repo "$REPO" --title "$title" \
            --body-file "$f" --label enhancement)
    echo "created: $title -> $url"
    NUMS+=("${url##*/}")
done

# Rewrite the epic's #N references to the real issue numbers, then file it.
body=$(cat EPIC.md)
i=1
for n in "${NUMS[@]}"; do
    body=${body//"#$i "/"#$n "}
    body=${body//"#$i,"/"#$n,"}
    i=$((i+1))
done
printf '%s' "$body" | gh issue create --repo "$REPO" \
    --title "Epic: client-agnostic, multi-host workspace orchestrator" \
    --body-file - --label epic
