(defun get-file-as-string (pathname)
  (with-output-to-string (out)
    (with-open-file (in pathname)
      (loop with buffer = (make-array 8192 :element-type 'character)
	    for n-characters = (read-sequence buffer in)
	    while (< 0 n-characters)
	    do (write-sequence buffer out :start 0 :end n-characters)))
    out))

(defun get-link-element (path)
  (format nil "<p><a href=\"lore_pages/~a\">~:(~a~)</a></p>"
	  (file-namestring path)
	  (substitute #\space #\_ (pathname-name path))))

(defun build-index ()
  (with-open-file (stream "index.html" :direction :output
				       :if-exists :supersede
				       :if-does-not-exist :create)
    (format stream (get-file-as-string "index_template.html")
	    (mapcar #'get-link-element (directory "lore_pages/*.html")))))

(build-index)
