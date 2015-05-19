#!/bin/sh
set -eux

test -n "$EMACS"

alias make_random_str='head -c 8 /dev/urandom | shasum | cut -d " " -f 1'

str=`make_random_str`

$EMACS -batch -Q --load "./global-clipboard-mode.el" \
       --eval '(global-clipboard-mode 1)' \
       --eval "(kill-new \"$str\")"

$EMACS -batch -Q --load "./global-clipboard-mode.el" \
       --eval '(global-clipboard-mode 1)' \
       --eval "(or (string= \"$str\"
                            (current-kill 0))
                   (error \"$0: Fail multi-instance test!\"))"

