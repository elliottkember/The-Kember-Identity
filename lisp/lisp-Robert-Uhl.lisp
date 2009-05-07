(require :md5)

(defun test-sample (string)
 (when (string= (apply #'concatenate 'string
                       (map 'list (lambda (x)
                                    (format nil "~2,'0x" x))
                            (md5:md5sum-sequence string)))
                string)
   t))

(loop for string = (coerce (loop for i from 1 to 32
                             collect (elt "ABCDEF0123456789" (random 16)))
                          'string)
  until (test-sample string)
  finally (return string))
