# Contributing

## Branches
Use `type/scope` naming, e.g. `feat/api` or `fix/docs`.

## Commits
Follow [Conventional Commits](https://www.conventionalcommits.org/).

## Pull Requests
Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md) and ensure:

- CI is green
- Submodules updated: `git submodule update --init --recursive` and `bash scripts/update_submodules.sh`
- Documentation updated

## Templates
Issue templates live in [`.github/ISSUE_TEMPLATE`](.github/ISSUE_TEMPLATE).

## External Modules
External modules such as `claude-flow` are tracked as git submodules. To update them:

1. `git submodule update --init --recursive`
2. `bash scripts/update_submodules.sh`
3. Commit the result in a pull request for review.
