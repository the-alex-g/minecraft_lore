(defun get-file-as-string (pathname)
  (with-output-to-string (out)
    (with-open-file (in pathname)
      (loop with buffer = (make-array 8192 :element-type 'character)
	    for n-characters = (read-sequence buffer in)
	    while (< 0 n-characters)
	    do (write-sequence buffer out :start 0 :end n-characters)))
    out))

(defun title-case (path)
  (substitute #\space #\_ (pathname-name path)))

(defun build-page (path template)
  (with-open-file (stream (merge-pathnames "lore_pages/" (file-namestring path))
			  :direction :output
			  :if-exists :supersede
			  :if-does-not-exist :create)
    (format stream template (title-case path) (get-file-as-string path))))

(defun get-link-element (path)
  (format nil "<p><a href=\"lore_pages/~a\">~:(~a~)</a></p>"
	  (file-namestring path) (title-case path)))

(defun build-index ()
  (with-open-file (stream "index.html" :direction :output
				       :if-exists :supersede
				       :if-does-not-exist :create)
    (format stream (get-file-as-string "templates/index.html")
	    (mapcar #'get-link-element (directory "lore_pages/*.html")))))

(defun build-pages ()
  (let ((template (get-file-as-string "templates/page.html")))
    (mapcar (lambda (path) (build-page path template))
	    (directory "lore_content/*.html"))))

(defun build ()
  (build-pages)
  (build-index))

(build)
