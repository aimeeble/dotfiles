#!/bin/bash

set_os_prefs() {
  SCREENSHOT_PATH="${HOME}/Google Drive/Pictures/Screenshots/$(hostname -s)/"

  # Screenshots
  mkdir -p "${SCREENSHOT_PATH}"
  set_default "Specify screenshot location"         "com.apple.screencapture"     "location"                          "${SCREENSHOT_PATH}"

  # Common/Core UI
  set_default "Enable keyboard navigation"          "NSGlobalDomain"              "AppleKeyboardUIMode"               2 -int
  set_default "Don't autohide menubar (normal)"     "Apple Global Domain"         "_HIHideMenuBar"                    0 -int
  set_default "Don't autohide menubar (fullscreen)" "Apple Global Domain"         "AppleMenuBarVisibleInFullscreen"   0 -int
  set_default "Dark mode UI"                        "Apple Global Domain"         "AppleInterfaceStyle"               "Dark"
  set_default "Purple highlight colour"             "Apple Global Domain"         "AppleHighlightColor"               "0.968627 0.831373 1.000000 Purple"
  set_default "Always show scrollbars"              "Apple Global Domain"         "AppleShowScrollBars"               "Always"
  set_default "Analog menubar clock (native)"       "com.apple.menuextra.clock"   "IsAnalog"                          1 -int

  # Dock
  set_default "Dock on bottom"                      "com.apple.dock"              "orientation"                       "bottom"
  set_default "Dock icon size"                      "com.apple.dock"              "tilesize"                          36 -int
  set_default "Dock autohide"                       "com.apple.dock"              "autohide"                          true -bool
  set_default "Task switcher on all screens"        "com.apple.dock"              "appswitcher-all-displays"          true -bool

  # Finder
  set_default "Finder show pathbar"                 "com.apple.finder"            "ShowPathbar"                       true -bool
  set_default "Finder defaults to list view"        "com.apple.finder"            "FXPreferredViewStyle"              "Nlsv"
}
