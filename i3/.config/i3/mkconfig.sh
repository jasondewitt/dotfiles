#!/usr/bin/env bash

cd ~/.config/i3/ || exit;
sed '/^[[:space:]]*# *default_keys/r config.default_keys' config.base > config
i3-msg reload