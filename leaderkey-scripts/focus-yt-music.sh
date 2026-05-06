#!/usr/bin/env bash

found="$(
osascript <<'OSA'
tell application "Google Chrome"
  repeat with w in windows
    set tabIndex to 0

    repeat with currentTab in tabs of w
      set tabIndex to tabIndex + 1

      try
        set tabUrl to URL of currentTab

        if tabUrl contains "music.youtube.com" then
          set active tab index of w to tabIndex
          set index of w to 1
          activate
          return "found"
        end if
      end try
    end repeat
  end repeat
end tell

return "missing"
OSA
)"

if [[ "$found" != "found" ]]; then
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --profile-directory="Profile 4" \
    "https://music.youtube.com/" \
    >/dev/null 2>&1 &
fi
