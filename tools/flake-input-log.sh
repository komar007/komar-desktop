#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
cd "$SCRIPT_DIR" || exit

INPUT=$1
FROM=$2
TO=$3

get(){
	FIELD=$1
	jq -r ".nodes[\"$INPUT\"].locked.$FIELD"
}

get_github_url(){
	FLAKE_REV=$1
	FLAKE=$(git show "$FLAKE_REV":../flake.lock)
	echo "https://github.com/$(get owner <<< "$FLAKE")/$(get repo <<< "$FLAKE")"
}


if [ -z "$FROM" ] && [ -n "$TO" ]; then
	# TODO: print error
	exit 1
fi

if [ -n "$FROM" ]; then
	INPUT_FROM=$(git show "$FROM":../flake.lock | get rev)
else
	INPUT_FROM=$(git show HEAD:../flake.lock | get rev)
fi

if [ -n "$TO" ]; then
	INPUT_TO=$(git show "$TO":../flake.lock | get rev)
else
	INPUT_TO=$(get rev < ../flake.lock)
fi

if [ "$INPUT_FROM" = null ] || [ "$INPUT_TO" = null ]; then
	echo "$INPUT: wrong type of input, missing revision" > /dev/stderr
	exit 1
fi

PRETTY=${PRETTY:-oneline}

URL=$(get_github_url "$FROM")
T=$(mktemp -d)
git clone -q --bare "$URL" "$T"
# shellcheck disable=SC2086
git -C "$T" log --pretty="$PRETTY" "$INPUT_FROM..$INPUT_TO"
rm -fr "$T"
