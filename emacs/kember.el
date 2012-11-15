;;; kember.el --- Find the kember identity

;; Copyright (C) 2011  Aaron S. Hawley

;; Author:  <aaron.s.hawley at gmail.com>
;; Keywords: games

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  See <http://www.gnu.org/licenses/>.

;;; Commentary:

;; The Kember identity are any md5 hash that is a collision of itself.
;; The following is a program for `M-x zone' that randomly generates
;; hashes and checks if the md5 hash of itself is the same.

;; Install by putting this file in your `load-path' and then by adding
;; the following to your .emacs

;; (eval-after-load "zone"
;;   '(progn
;;      (load-library "kember")
;;      (unless (memq 'zone-pgm-kember (append zone-programs nil))
;;        (setq zone-programs
;;              (vconcat zone-programs [zone-pgm-kember])))))

;; Note, zone randomly selects a program to run.

;; To automatically enable M-x zone-when-idle, add to your .emacs:

;; (setq zone-timer (run-with-idle-timer 120 t 'zone))

;;; Code:

(require 'zone)

(defun zone-pgm-kember ()
  "Search for the Kember identity."
  ;; Wrap long lines
  (goto-char (point-min))
  (while (not (eobp))
    (while (> (save-excursion
                (goto-char (line-end-position))
                (current-column))
              (window-width))
      (move-to-column (window-width))
      (newline))
    (forward-line 1))
  (let* ((largest-int most-positive-fixnum)
         (largest-bits (floor (log largest-int 2)))
         (target-bits 128) ;; md5
         (hash-len 32)
         (hash (make-string hash-len ?0))
         (n-ints (ceiling (/ (float target-bits) largest-bits)))
         (num-list (make-list n-ints largest-int))
         (n-lines (count-lines (point-min) (point-max))))
    (zone-fill-out-screen (window-width) (window-height))
    (random t)
    (goto-char (point-min))
    (while (not (input-pending-p))
      (when (eobp)
        (goto-char (point-min)))
      (while (not (eobp))
        (setq hash
              (substring
               (apply 'concat (mapcar
                               (lambda (n)
                                 (format (format "%%0%dx" n-ints) n))
                               (mapcar 'random num-list)))
               (- hash-len)))
        (when (bolp)
          (untabify (point) (line-end-position)))
        (mapc (lambda (c) (if (eolp)
                              (insert c)
                            (forward-char 1)
                            (insert-and-inherit c)
                            (save-excursion
                              (forward-char -2) (delete-char 1))))
              (split-string hash "" t))
	(when (string-equal hash (md5 hash))
          (forward-line 1)
          (mapc (lambda (c) (if (eolp)
                                (insert c)
                              (forward-char 1)
                              (insert-and-inherit c)
                              (save-excursion
                                (forward-char -2) (delete-char 1))))
                (split-string (md5 hash) "" t))
          (forward-line 1)
          (delete-region (point) (line-end-position))
          (insert "Kember identity found")
          (zone-park/sit-for (point-min) most-positive-fixnum))
        (if (> (current-column) (window-width))
            (forward-line 1)
          (unless (eolp)
            (delete-char 1))
          (insert " "))
        (zone-park/sit-for (point-min) (/ (random 64) 256.0))))
    (message "Last md5 checksum: %s" hash)))

(provide 'kember)
;;; kember.el ends here
