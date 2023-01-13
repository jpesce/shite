---
publishDate: 2022-08-11
---
# Git hooks

Disclaimer: when I say _git hooks_ I’m talking
about [commiting-workflow
hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks#_committing_workflow_hooks).

## What are git hooks?

Git hooks are scripts that automatically run commands such as convenient sanity
checks before (or after) you make changes to a repository. For example, you can
automatically run stuff like tests, lint checks, automatic formatting and other
goodies that help you not push crappy code to the project.

There are third party libraries you could use to deal with them, but managing
them natively is not hard, which means one less dependency in your life. And
_everyone_ loves less dependencies.

## How hooks work

By default, git hooks live in `.git/hooks` inside the repo. For example, to
automatically run a command before committing, simply create a
`.git/hooks/pre-commit` script:
```bash
#!/bin/sh

echo "You're about to commit a change 👀"

# Change input to keyboard so user can interact
exec < /dev/tty
read -p "Are you really really sure? (y/n) "
[[ $REPLY == "y" ]] && exit 0 || exit 1
```

This will prompt the user to confirm if they **really really** want to commit
the changes. Menancing, but I’m not sure how effective.

## Tracking git hooks

The problem is that `.git/hooks` is a private directory, which means hooks will
only be available locally and not for everyone using the repo. Let's change that
and tell git to look for hooks in the `.githooks` directory:
```bash
git config --local core.hooksPath .githooks
```

Then, simply add `.githooks` to the repo.

## Making all contributors use the hooks

Now everyone has the directory in the repo, but git is looking for the hooks in
the wrong place: the default directory. To use them, each contributor must
manually configure their repo to use `.githooks` as their hooks path. Bummer. 

_However_, to make life easier for everyone, you can add the config command to
your project’s setup pipeline. 

For example, if you’re in a project with a package manager that uses
`package.json` and has a `prepare` script:
```bash
"scripts": {
  ...
  "prepare": "git config --local core.hooksPath .githooks"
}
```

This will make the git look for hooks in the correct place as soon as they
install the project’s dependencies.

## Useful git hooks

Now that we’ve put everyone in the same page and we’re all using the same hooks,
we can create useful things.

### Example 1: Force everyone to use commitizen when commiting
Not cool, but... When commiting, commitzen will help the user form a
conventional commit message. Add to `.git/hooks/prepare-commit-msg`:
```bash
#!/bin/sh

# Change input to keyboard so user can interact
exec < /dev/tty
# Run commitizen
yarn cz --hook || true
```

### Example 2: Lint commit messages with commitlint
Much more sane. If the user tries to commit changes with a non-conventional
message, abort (if they want to, they can use commitzen to help them). Add to
`.githooks/commit-msg`:
```bash
#!/bin/sh

# Run commitlint against current commit
yarn commitlint --edit "${1}"
```

### Example 3: Lint code
When commiting, check files for lint errors with eslint. Add to
`.githooks/pre-commit`:
```bash
#!/bin/sh

# Lint all jsx and js files
eslint --ext jsx,.js ./
```

### Example 4: Lint code only on staged files
When commiting, check only staged files for lint errors, without any special
dependencies for that (\*cough\* lint-staged \*cought\*) of course. Add to
`.githooks/pre-commit`:
```bash
#!/bin/sh

yarn eslint --ext jsx,.js $(git diff --staged --name-only --diff-filter=ACMRTUXB)
```

## List of all commit hooks

To get a list of all hooks you can use and when they are executed just <abbr
title="Read the friendly manual">RTFM</abbr> @ `man githooks` or
[online](https://git-scm.com/docs/githooks#_hooks)
