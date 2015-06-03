[![Build Status](https://travis-ci.org/10sr/global-clipboard-mode-el.svg?branch=master)](https://travis-ci.org/10sr/global-clipboard-mode-el)



global-clipboard-mode
=====================

A global minor-mode to share the content of Emacs clipboard among multiple Emacs
instances.
Typically this mode is usefull when you are running two or more Emacs-es and you
are not using X (X clipboard is not available).

To use, simply enable global-clipboard-mode:

```lisp
(global-clipboard-mode 1)
```

Optionally, you can change the file which clipboard contents will be stored:

```lisp
(setq global-clipboard-mode-clipboard-file
      "/tmp/clipboard.dat")
```



License
-------

This software is licensed under GPLv3.
