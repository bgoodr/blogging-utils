;; -*-mode: lisp-interaction; -*-

(with-current-buffer (save-excursion
		       (let ((file "template-stretch-denim-brents-color-scheme.xml"))
			 (or (find-buffer-visiting file)
			     (find-file file)
			     (current-buffer))))
  (goto-char (point-min))
  (let (names)
    (while (re-search-forward (rx "<Variable name="
				  "\""
				  (group (+ (not (any "\""))))
				  "\""
				  )
			      nil t)
      (let ((name (match-string-no-properties 1)))
	;; Temporary exclusion to debug the code herein by only looking at the
	;; "startSide" variable:
	(when (string-equal "startSide" name)
	  (push name names))))
    (let ((elems (mapcar (lambda (name)
			   (save-excursion
			     (let ((ref-regexp (concat (regexp-quote "$")
						       (regexp-quote name)
						       (rx (not (any "a-z" "A-Z" "0-9" "_")))))
				   refs)
			       (while (re-search-forward ref-regexp nil t)
				 (save-excursion
				   (backward-up-list 1)
				   (let ((end (point)))
				     (re-search-backward (rx (or "*/"
								 "}"))
							 nil t)
				     (add-to-list 'refs
						  (split-string
						   (replace-regexp-in-string
						    (rx (+ white) eos) ""
						    (replace-regexp-in-string
						     (rx bos (+ white)) ""
						     (replace-regexp-in-string
						      (rx white) " "
						      (buffer-substring-no-properties (match-end 0) end))))
						   " ")))))
			       (list name (sort (apply 'append refs) 'string-lessp)))))
			 (nreverse names))))
      (mapconcat (lambda (elem)
		   (pp-to-string elem))
		 elems
		 "\n"))))
