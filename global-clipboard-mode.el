;;; global-clipboard-mode.el --- Share Clipboard among Multiple Emacs Instances

;; Copyright (C) 2015 10sr

;; Author: 10sr <8slashes+el [at] gmail [dot] com>
;; Keywords: convenience, tools
;; Contributor: Leo Shidai Liu <shidai.liu@gmail.com>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; `global-clipboard-mode' is a global minor-mode to share the content of Emacs
;; clipboard among multiple Emacs instances.


;;; Code:
(defvar global-clipboard-mode-program (executable-find "xclip")
  "Name of XClip program tool.")

(defvar global-clipboard-mode-select-enable-clipboard t
  "Non-nil means cutting and pasting uses the clipboard.
This is in addition to, but in preference to, the primary selection.")

(defvar global-clipboard-mode-last-selected-text-clipboard nil
  "The value of the CLIPBOARD X selection from xclip.")

(defvar global-clipboard-mode-last-selected-text-primary nil
  "The value of the PRIMARY X selection from xclip.")

(defun global-clipboard-mode-set-selection (type data)
  "TYPE is a symbol: primary, secondary and clipboard.

See `x-set-selection'."
  (when (and global-clipboard-mode-program (getenv "DISPLAY"))
    (let* ((process-connection-type nil)
           (proc (start-process "xclip" nil "xclip"
                                "-selection" (symbol-name type))))
      (process-send-string proc data)
      (process-send-eof proc))))

(defun global-clipboard-mode-select-text (text &optional push)
  "See `x-select-text'."
  (global-clipboard-mode-set-selection 'primary text)
  (setq global-clipboard-mode-last-selected-text-primary text)
  (when global-clipboard-mode-select-enable-clipboard
    (global-clipboard-mode-set-selection 'clipboard text)
    (setq global-clipboard-mode-last-selected-text-clipboard text)))

(defun global-clipboard-mode-selection-value ()
  "See `x-cut-buffer-or-selection-value'."
  (when (and global-clipboard-mode-program (getenv "DISPLAY"))
    (let (clip-text primary-text)
      (when global-clipboard-mode-select-enable-clipboard
        (setq clip-text (shell-command-to-string "xclip -o -selection clipboard"))
        (setq clip-text
              (cond ;; check clipboard selection
               ((or (not clip-text) (string= clip-text ""))
                (setq global-clipboard-mode-last-selected-text-primary nil))
               ((eq      clip-text global-clipboard-mode-last-selected-text-clipboard) nil)
               ((string= clip-text global-clipboard-mode-last-selected-text-clipboard)
                ;; Record the newer string,
                ;; so subsequent calls can use the `eq' test.
                (setq global-clipboard-mode-last-selected-text-clipboard clip-text)
                nil)
               (t (setq global-clipboard-mode-last-selected-text-clipboard clip-text)))))
      (setq primary-text (shell-command-to-string "xclip -o"))
      (setq primary-text
            (cond ;; check primary selection
             ((or (not primary-text) (string= primary-text ""))
              (setq global-clipboard-mode-last-selected-text-primary nil))
             ((eq      primary-text global-clipboard-mode-last-selected-text-primary) nil)
             ((string= primary-text global-clipboard-mode-last-selected-text-primary)
              ;; Record the newer string,
              ;; so subsequent calls can use the `eq' test.
              (setq global-clipboard-mode-last-selected-text-primary primary-text)
              nil)
             (t (setq global-clipboard-mode-last-selected-text-primary primary-text))))
      (or clip-text primary-text))))

;;;###autoload
(defun turn-on-global-clipboard-mode ()
  (interactive)
  (setq interprogram-cut-function 'global-clipboard-mode-select-text)
  (setq interprogram-paste-function 'global-clipboard-mode-selection-value))

;;;###autoload
(defun turn-off-global-clipboard-mode ()
  (interactive)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil))


(add-hook 'terminal-init-xterm-hook 'turn-on-global-clipboard-mode)


(provide 'global-clipboard-mode)
;;; global-clipboard-mode.el ends here
