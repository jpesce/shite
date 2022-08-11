# Git hooks

Disclaimer: when I say _git hooks_ I’m talking
about [_commiting-workflow
hooks_](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks#_committing_workflow_hooks).

## What are git hooks?

Git hooks automatically run sanity checks and other useful commands before (or
after) you make changes to the repository. They are useful, for example, for
automatically running stuff like tests, lint checks, automatic formatting and
other goodies that help you not push crappy code to the project.

There are third party libraries you can use to deal with them, but managing
them natively is not hard, which means one less dependency in your life. Hooray.

## How hooks work

Git hooks live by default in `.git/hooks`. To run a command before committing,
for example, simply create a `.git/hooks/pre-commit` script:
```bash
#!/bin/sh

echo "You're about to commit a change. You're doing great! Keep calm and review your changes."

# Change input to keyboard so user can interact
exec < /dev/tty
read -p "Are you sure you're ready to commit? (y/n) "
[[ $REPLY == "y" ]] && exit 0 || exit 1
```

This will prompt the user to confirm if they really want to commit the changes.
Great (but not very effective)!

## Tracking git hooks

The problem is that `.git/hooks` is a private directory, which means hooks will
only be available locally and not for everyone using the repo. Let's change that
and tell git to look for hooks in the `.githooks` directory:
```bash
git config --local core.hooksPath .githooks
```

Then, simply track `.githooks` in the repo.

## Making everyone use the same hooks

Now everyone has access to the hooks, but they are all looking for them in the
wrong place: the default directory. Now they must configure their local repo to
use `.githooks` as their hooks path. Bummer. 

To make life easier, add the config command to your project's setup pipeline. 

For example, if you’re in a project with `packages.json` that has a `prepare`
script:
```bash
"scripts": {
  ...
  "prepare": "git config --local core.hooksPath .githooks"
}
```

This will make everyone’s gits look for hooks in the same place as soon as they
install the project’s dependencies.

## Useful git hooks

Now that we’ve put everyone in the same page and we’re all using the same hooks
we can create something useful.

### Force everyone to use commitizen when commiting
Not cool, but... When commiting, `commitzen` will help the user form a
conventional commit message. Add to `.git/hooks/prepare-commit-msg`:
```bash
#!/bin/sh

# Change input to keyboard so user can interact
exec < /dev/tty
# Run commitizen
yarn cz --hook || true
```

### Lint commit messages with commitlint
Much more sane. If the user tries to commit changes with a non-conventional
message, abort (if they want to, they can use commitzen to help them). Add to
`.githooks/commit-msg`:
```bash
#!/bin/sh

# Run commitlint against current commit
yarn commitlint --edit "${1}"
```

### Lint code
When commiting, check files for lint errors with eslint. Add to
`.githooks/pre-commit`
```bash
#!/bin/sh

# Lint all jsx and js files
eslint --ext jsx,.js ./
```

### Lint code only on staged files
When commiting, check only staged files for lint errors. Without any special
dependencies for that, of course. Add to `.githooks/pre-commit`:
```bash
#!/bin/sh

yarn eslint --ext jsx,.js $(git diff --staged --name-only --diff-filter=ACMRTUXB)
```

## List of all commit hooks
<abbr title="Read the friendly manual">RTFM</abbr> @ `man githooks` or
[online](https://git-scm.com/docs/githooks#_hooks)
