(with-current-buffer "template-stretch-denim-brents-color-scheme.xml"
  (goto-char (point-min))
  (let (names)
    (while (re-search-forward (rx "<Variable name="
                  "\""
                  (group (+ (not (any "\""))))
                  "\""
                  )
                  nil t)
      (let ((name (match-string-no-properties 1)))
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
                          (let ((tmp
                             (split-string
                              (replace-regexp-in-string
                               (rx (+ white) eos) ""
                               (replace-regexp-in-string
                                (rx bos (+ white)) ""
                                (replace-regexp-in-string
                                 (rx white) " "
                                 (buffer-substring-no-properties (match-end 0) end))))
                              " ")))
                            (setq tmp (sort tmp 'string-lessp))
                            tmp)))))
                   (list name (nreverse refs)))))
             (nreverse names))))
      (mapconcat (lambda (elem)
           (pp-to-string elem))
         elems
         "\n"))))
("startSide"
 (("#header-wrapper")
  ("#content-wrapper")
  ("#main-wrapper")
  ("#blog-pager-newer-link")
  (".sidebar" "li")
  (".profile-img")
  ("#footer" ".widget")))
