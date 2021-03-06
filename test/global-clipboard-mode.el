(require 'global-clipboard-mode)

(setq global-clipboard-mode-clipboard-file
      (make-temp-file "global-clipboard-mode.test."))

(defun make-random-string ()
  "Make rundom string with `random' and `sha1'."
  (sha1 (number-to-string (random))))

(ert-deftest test-global-clipboard-mode ()
  (let ((str (make-random-string)))
    (message "String to kill: %s"
             str)
    (global-clipboard-mode 1)
    (kill-new str)
    (should (string= str
                     (current-kill 0)))
    (should (string= str
                     (with-temp-buffer
                       (insert-file-contents-literally
                        global-clipboard-mode-clipboard-file)
                       (buffer-substring-no-properties (point-min)
                                                        (point-max)))))))
