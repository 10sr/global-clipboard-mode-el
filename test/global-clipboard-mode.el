(require 'global-clipboard-mode)

(defun make-random-string ()
  (sha1 (number-to-string (random))))

(ert-deftest test-global-clipboard-mode ()
  (let ((str (make-random-string)))
    (global-clipboard-mode 1)
    (kill-new str)
    (should (string= str
                     (current-kill 0)))))
