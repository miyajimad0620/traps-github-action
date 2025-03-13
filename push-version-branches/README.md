# traps-github-action/push-version-branches

## Usage

``` push-version-branches.yaml
name: Push version branches

run-name: Push version branches:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
    tags: 'v*.*.*'

jobs:
  push-tag:
    runs-on: ubuntu-22.04

    permissions:
      contents: write
      workflows: write

    steps:
      - name: Push version branches
        uses: TRAPS-RoboCup/traps-github-action/push-version-branches@main
        # with:
        #  tag: $${{ github.ref }}
        #  checkout: true

```
