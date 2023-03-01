# UnPiped

A simple script to generate your own custom YouTube homepage from an Unlibrary account.

## Usage

This script assumes you have an account containing only YouTube RSS feeds; it defaults to the "yt" account, but this is configurable.

```shell
mix escript.build
unpiped [USERNAME] [BROWSER]
```

- `USERNAME`: The username for the Unlibrary account containing the RSS feeds. Defaults to "yt".
- `BROWSER`: A (path to) binary of your favorite browser (eg. `/usr/bin/firefox`). Defaults to `firefox`.
