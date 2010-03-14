;; -*-mode: lisp-interaction; -*-

(defun bg-safe-require (library-name)
  (if (locate-library library-name )
      (require (intern library-name))
    (error "You must have %s installed. Google it!" library-name)))

(bg-safe-require "nxml-mode")

(defun bg-blogger-util-get-template-variable-references (file variable-type)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let ((variable-section-begin-regexp (rx "<Variable name="
					     "\""
					     (group (+ (not (any "\""))))
					     "\""
					     ))
	  (variable-section-end-regexp (rx
					(+ white)
					(+ (not (any "=")))
					(* white)
					"="
					(* white)
					"\""
					(+ (not (any "\"")))
					"\""
					(* white)
					">"))
	  (type-match-regexp (rx "type"
				 (* white)
				 "="
				 (* white)
				 "\""
				 (eval variable-type)
				 "\""))
	  names)
      ;; TODO: use nxml-mode's functions to pull out the XML element in a
      ;; cleaner fashion than using a regular expression:
      (while (re-search-forward variable-section-begin-regexp nil t)
	(let ((name (match-string-no-properties 1))
	      (beg-variable-def-point (match-beginning 0))
	      (end-variable-def-point
	       (if (re-search-forward variable-section-end-regexp nil t)
		   (point)
		 (error "Could not find end of variable definition for variable named %S" name))))
	  (when (string-match type-match-regexp
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
						      (rx (+ (or white ",")) eos) ""
						      (replace-regexp-in-string
						       (rx bos (+ white)) ""
						       (replace-regexp-in-string
							(rx white) " "
							(buffer-substring-no-properties (match-end 0) end))))
						     " ")))))
				 (list name (sort (apply 'append refs) 'string-lessp)))))
			   (nreverse names))))
	elems))))

(defun bg-blogger-get-section-to-var-name-hash (references)
  (let ((references-section-to-var-hash (make-hash-table :test 'equal)))
    (mapc (lambda (var-elem)
	    (let ((variable-name (car var-elem))
		  (sections (cadr var-elem)))
	      (mapc (lambda (section)
		      (error "Stopped here: This is wrong: There could be sections that reference multiple colors in different ways for foreground and background colors.")
		      (puthash section variable-name references-section-to-var-hash))
		    sections)))
	  references)
    references-section-to-var-hash))


;; Just a "nil" block to allow me to eval the entire buffer of this file to get
;; the definitions. I then can use C-j after the expressions within the nil
;; block to see the result, given that this file is still in lisp-interaction
;; mode (see top of the file):
(when nil
  ;; -----------------------------------------------------------------------------------------
  (mapconcat
   (lambda (elem)
     (pp-to-string elem))
   (bg-blogger-util-get-template-variable-references "template-stretch-denim-brents-color-scheme.xml" "color")
   "\n")
  ;; -----------------------------------------------------------------------------------------
  (mapconcat
   (lambda (elem)
     (pp-to-string elem))
   (bg-blogger-util-get-template-variable-references "template-stretch-denim-brents-color-scheme.xml" "color")
   "\n")
  ;; -----------------------------------------------------------------------------------------
  (insert (mapconcat
	   (lambda (elem)
	     (pp-to-string elem))
	   (bg-blogger-util-get-template-variable-references "template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml" "color")
	   "\n"))
  ;; -----------------------------------------------------------------------------------------
  (insert (pp (bg-blogger-util-get-template-variable-references "template-stretch-denim-brents-color-scheme.xml" "color")))
  (("bgColor"
    ("body"))
   ("borderColor"
    ("#content-wrapper" ".post" ".profile-img" "img," "table.tr-caption-container"))
   ("dateHeaderColor"
    ("#comments" ".date-header" "h4"))
   ("headerBgColor"
    ("#header"))
   ("headerCornersColor"
    ("#header-wrapper"))
   ("headerTextColor"
    ("#header" "a," "a:visited" "h1.title" "h1.title"))
   ("linkColor"
    ("a:link" "a:visited"))
   ("mainBgColor"
    ("#content-wrapper" "#main-wrapper" "#sidebar-wrapper"))
   ("sidebarTitleBgColor"
    (".sidebar" "h2"))
   ("sidebarTitleTextColor"
    (".sidebar" "h2"))
   ("textColor"
    ("#footer" ".post-footer" ".post-title" ".post-title" ".post-title" ".sidebar" "a," "a:visited," "body" "strong")))
  ;; -----------------------------------------------------------------------------------------
  (insert (pp (bg-blogger-util-get-template-variable-references "template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml" "color")))
  (("blogDescriptionColor"
    ("#header" ".description"))
   ("dateHeaderColor"
    ("h2.date-header"))
   ("hoverLinkColor"
    ("a:active" "a:hover"))
   ("linkColor"
    ("a:link," "a:visited"))
   ("mainBgColor"
    ("#outer-wrapper"))
   ("mainTextColor"
    ("body"))
   ("pageHeaderColor"
    ("#header" "a," "a:link," "a:visited" "h1" "h1" "h1" "h1"))
   ("sidebarHeaderColor"
    (".sidebar" "h2"))
   ("sidebarTextColor"
    ("#sidebar")))
  ;; -----------------------------------------------------------------------------------------
  (let ((vars-white )
	(vars-green-section-to-var-hash (bg-blogger-get-section-to-var-name-hash
					 (bg-blogger-util-get-template-variable-references "template-stretch-denim-brents-color-scheme.xml" "color")))
	(vars-white-section-to-var-hash (bg-blogger-get-section-to-var-name-hash
					 (bg-blogger-util-get-template-variable-references "template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml" "color"))))
    (maphash (lambda (section variable-name)
	       (list section variable-name))
	     vars-green-section-to-var-hash))




  ;; -----------------------------------------------------------------------------------------
  )
