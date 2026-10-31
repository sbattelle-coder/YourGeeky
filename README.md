# YourGeeky

A friendly Terminal helper for people who are not technical. Tell it what you need in
plain words, like "install Python", and it does the work with an AI assistant, explaining
each step and asking before it changes anything. It uses Google's free Antigravity CLI by
default, or Claude Code for people with a paid Claude plan.

Version 1 is for Mac.

## Install

Open the Terminal app, paste this line, and press Return:

```
curl -fsSL https://raw.githubusercontent.com/sbattelle-coder/YourGeeky/main/install.sh | bash
```

The installer asks whether you have a paid Claude plan. If not, it sets up Google's free
AI (sign in with any Google account); if so, it sets up Claude Code. Then type `yourgeeky`.

## Use

```
yourgeeky                      # start a conversation
yourgeeky "install Python"     # start with a request
yourgeeky --show-commands      # also show the real commands, so you can learn them
yourgeeky --use claude         # switch to Claude Code (or --use google to switch back)
```

## What it helps with

Installing tools, running instructions from a guide, explaining errors, fixing
"command not found" and "permission denied", setting up Homebrew, finding folders,
getting unstuck, running a project someone shared, and updating or removing software.

## How it works

`bin/yourgeeky` starts the chosen AI with the guidance in `prompts/guide.md`: added to
Claude Code's system prompt, or sent as the opening message to Antigravity CLI, which has no
system prompt option. That file sets the plain-English tone, the safety rules, and how to
handle the ten most common requests. Each tool's own permission prompts still apply,
so nothing runs without the person's say-so.

## Development

```
bash tests/run.sh
```
