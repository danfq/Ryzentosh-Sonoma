# Discord Fix

## The Issue

[Discord](https://discord.com) implements a feature called `MKL - Math Kernel Library`, which is built for `Intel`.

This works just fine on Intel, but tends to cause issues on Ryzen-based Hackintoshes.

## The Fix

To fix this, we need to _spoof_ the `MKL_DEBUG_CPU_TYPE` variable, in order to make Discord _think_ that the system is running on an `Intel i5`.

## The Script

I've written the script included in this folder, to automate this process.

All you need to do is run it.

## How to Use It

To make things easier, we'll set an `alias` in your System.

- Download the Script.
- Place it somewhere easy to access (e.g. Home Folder).
- Do the following, in a Terminal:
- - `sudo nano ~/.zshrc`
- - Enter: `alias fixdiscord="/Users/$(whoami)/fix_discord.sh"`
- - Hit `CTRL+O`, followed by `ENTER` & `CTRL+X`.
- - `source ~/.zshrc`

After this, the script is available on any Terminal you open.

- Run: `fixdiscord`.

<br>
The Script should run, and Discord should be fixed!<br>
Have fun!