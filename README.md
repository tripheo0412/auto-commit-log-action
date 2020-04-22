# auto-commit-log-action

This GitHub Action automatically commits auto-log.json files which have been changed during a Workflow run and pushes the commit back to GitHub.
The default committer is "GitHub Actions <actions@github.com>" and the default author of the commit is "Your GitHub Username <github_username@users.noreply.github.com>".

*This Action currently can't be used in conjunction with pull requests of forks. See [here](https://github.com/tripheo0412/auto-commit-log-action/issues/25) or [here](https://github.community/t5/GitHub-Actions/Actions-not-working-correctly-for-forks/td-p/35545) for more information.*

## Usage

**Note:** This Action requires that you use `action/checkout@v2` or above to checkout your repository.
**Note:** This Action requires that you install `moreutils` in your workflow by ```sudo apt-get install moreutils```

Add the following step at the end of your job.

```yaml
- name: Checkout
  uses: actions/checkout@v2
- name: Install moreutils
  run: sudo apt-get install moreutils
- name: Run auto log commiter action  
  uses: tripheo0412/auto-commit-log-action@v2.0.0
  with:
    # Optional name of the branch the commit should be pushed to
    # Required if Action is used in Workflow listening to the `pull_request` event
    branch: ${{ github.head_ref }}

    # Required bot credential settings
    bot_user_name: Tripheo0412
    bot_user_email: tripheo0412@gmail.com
```

The Action will only commit auto-log.json and changed files back, if changes are available. The resulting commit **will not trigger** another GitHub Actions Workflow run!

We recommend to use this Action in Workflows, which listen to the `pull_request` event. You can then use the option `branch: ${{ github.head_ref }}` to set up the branch name correctly.
If you don't pass a branch name, the Action will try to push the commit to a branch with the same name, as with which the repo has been checked out.

## Known Issues

- GitHub currently prohibits Actions like this to push changes from a fork to the upstream repository. See [here](https://github.com/tripheo0412/auto-commit-log-action/issues/25) or [here](https://github.community/t5/GitHub-Actions/Actions-not-working-correctly-for-forks/td-p/35545) for more information.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/tripheo0412/auto-commit-log-action/tags).

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/tripheo0412/auto-commit-log-action/blob/master/LICENSE) file for details.
