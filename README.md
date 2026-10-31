# YourGeeky

A friendly Terminal helper for people who are not technical. Tell it what you need in
plain words, like "install Python", and it does the work with Claude Code, explaining
each step and asking before it changes anything.

Version 1 is for Mac.

## Install

Open the Terminal app, paste this line, and press Return:

```
curl -fsSL https://raw.githubusercontent.com/sbattelle-coder/YourGeeky/main/install.sh | bash
```

This sets up Claude Code (if you don't have it yet) and YourGeeky. Then type `yourgeeky`
and sign in to your Claude account when asked. Claude Code is free to install, but using it
needs a paid Claude plan.

## Use

```
yourgeeky                      # start a conversation
yourgeeky "install Python"     # start with a request
yourgeeky --show-commands      # also show the real commands, so you can learn them
```

## What it helps with

Installing tools, running instructions from a guide, explaining errors, fixing
"command not found" and "permission denied", setting up Homebrew, finding folders,
getting unstuck, running a project someone shared, and updating or removing software.

## How it works

`bin/yourgeeky` starts Claude Code with the guidance in `prompts/guide.md` added to its
instructions. That file sets the plain-English tone, the safety rules, and how to
handle the ten most common requests. Claude Code's own permission prompts still apply,
so nothing runs without the person's say-so.

## Development

```
bash tests/run.sh
```
