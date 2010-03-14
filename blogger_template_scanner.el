;; -*-mode: lisp-interaction; -*-

(defun bg-safe-require (library-name)
  (if (locate-library library-name )
      (require (intern library-name))
    (error "You must have %s installed. Google it!" library-name)))

(bg-safe-require "nxml-mode")

(defun bg-blogger-util-get-template-variable-references (file)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let (names)
      ;; TODO: use nxml-mode's functions to pull out the XML element in a
      ;; cleaner fashion than using a regular expression:
      (while (re-search-forward (rx "<Variable name="
				    "\""
				    (group (+ (not (any "\""))))
				    "\""
				    )
				nil t)
	(let ((name (match-string-no-properties 1))
	      (beg-variable-def-point (match-beginning 0))
	      (end-variable-def-point
	       (if (re-search-forward
		    (rx
		     (+ white)
		     (+ (not (any "=")))
		     (* white)
		     "="
		     (* white)
		     "\""
		     (+ (not (any "\"")))
		     "\""
		     (* white)
		     ">")
		    nil t)
		   (point)
		 (error "Could not find end of variable definition for variable named %S" name))))
	  (when (string-match (rx "type"
				  (* white)
				  "="
				  (* white)
				  "\"color\""
				  )
			      (buffer-substring-no-properties beg-variable-def-point end-variable-def-point))
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
	elems))))


(when nil
  ;;
  (mapconcat
   (lambda (elem)
     (pp-to-string elem))
   (bg-blogger-util-get-template-variable-references "template-stretch-denim-brents-color-scheme.xml")
   "\n")
"(\"bgColor\"
 (\"body\"))

(\"borderColor\"
 (\"#content-wrapper\" \".post\" \".profile-img\" \"img,\" \"table.tr-caption-container\"))

(\"dateHeaderColor\"
 (\"#comments\" \".date-header\" \"h4\"))

(\"headerBgColor\"
 (\"#header\"))

(\"headerCornersColor\"
 (\"#header-wrapper\"))

(\"headerTextColor\"
 (\"#header\" \"a,\" \"a:visited\" \"h1.title\" \"h1.title\"))

(\"linkColor\"
 (\"a:link\" \"a:visited\"))

(\"mainBgColor\"
 (\"#content-wrapper\" \"#main-wrapper\" \"#sidebar-wrapper\"))

(\"sidebarTitleBgColor\"
 (\".sidebar\" \"h2\"))

(\"sidebarTitleTextColor\"
 (\".sidebar\" \"h2\"))

(\"textColor\"
 (\"#footer\" \".post-footer\" \".post-title\" \".post-title\" \".post-title\" \".sidebar\" \"a,\" \"a:visited,\" \"body\" \"strong\"))
"

  ;;
  )
