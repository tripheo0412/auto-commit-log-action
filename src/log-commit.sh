#!/bin/bash

set -eu

_main() {
    _check_for_json_log

    _auto_log

    _switch_to_repository

    _switch_to_branch

    _add_files

    _local_commit

    _tag_commit

    _push_to_github
    
}
_check_for_json_log() {
    FILE=./auto-log.json
    if [ -f "$FILE" ]; then
        echo "$FILE exist"
    else 
        echo "$FILE does not exist, creating new auto-log.json"
        echo $(jq -n '{log: { history: [] } }'  > auto-log.json)
    fi
}

_auto_log() {
    now=$(date)
    message=$(jq ".log.history += [\"[${now}] ${INPUT_COMMIT_MESSAGE}\"]" auto-log.json|sponge auto-log.json)
    echo "${message}"
}

_switch_to_repository() {
    echo "INPUT_REPOSITORY value: $INPUT_REPOSITORY";
    cd $INPUT_REPOSITORY
}

_switch_to_branch() {
    echo "INPUT_BRANCH value: $INPUT_BRANCH";

    # Switch to branch from current Workflow run
    git checkout  origin/$INPUT_BRANCH
}

_add_files() {
    echo "INPUT_FILE_PATTERN: ${INPUT_FILE_PATTERN}"
    git add "${INPUT_FILE_PATTERN}"
}

_local_commit() {
    echo "INPUT_COMMIT_OPTIONS: ${INPUT_COMMIT_OPTIONS}"
    git -c user.name="$INPUT_BOT_USER_NAME" -c user.email="$INPUT_BOT_USER_EMAIL" commit -m "$INPUT_COMMIT_MESSAGE" --author="$INPUT_BOT_AUTHOR" ${INPUT_COMMIT_OPTIONS:+"$INPUT_COMMIT_OPTIONS"}
}

_tag_commit() {
    echo "INPUT_TAGGING_MESSAGE: ${INPUT_TAGGING_MESSAGE}"

    if [ -n "$INPUT_TAGGING_MESSAGE" ]
    then
        echo "::debug::Create tag $INPUT_TAGGING_MESSAGE"
        git tag -a "$INPUT_TAGGING_MESSAGE" -m "$INPUT_TAGGING_MESSAGE"
    else
        echo " No tagging message supplied. No tag will be added."
    fi
}

_push_to_github() {
    if [ -z "$INPUT_BRANCH" ]
    then
        # Only add `--tags` option, if `$INPUT_TAGGING_MESSAGE` is set
        if [ -n "$INPUT_TAGGING_MESSAGE" ]
        then
            echo "::debug::git push origin --tags"
            git push origin --tags
        else
            echo "::debug::git push origin"
            git push origin
        fi

    else
        echo "::debug::Push commit to remote branch $INPUT_BRANCH"
        git push --set-upstream origin "HEAD:$INPUT_BRANCH" --tags
    fi
}

_main