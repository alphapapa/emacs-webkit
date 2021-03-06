(defun fake-module-reload (module)
  (interactive "Reload Module file: ")
  (let ((tmpfile (make-temp-file
                  (file-name-nondirectory module) nil module-file-suffix)))
    (copy-file module tmpfile t)
    (module-load tmpfile)))

(fake-module-reload (expand-file-name "~/git/emacs-webkit/webkit-module.so"))
;;(setq debug-on-error t)

(require 'webkit)
(require 'evil-collection-webkit)
(require 'webkit-ace)

(evil-collection-xwidget-setup)

(webkit-browse-url "http://xkcd.com" t)
(setq webkit-own-window t)
(garbage-collect)

;;(setq my-pipe (get-buffer-process (cdr (car webkit--id-buffer-alist))))
(with-current-buffer (car webkit--buffers) (buffer-string))
(setq webkit--id (with-current-buffer (car webkit--buffers) webkit--id))
(setq webkit--id nil)

(setq webkit--script (webkit--file-to-string
                         (expand-file-name "script.js" webkit-base)))
(webkit--execute-js webkit--id
                    "webkitHints('aoeuhtns');" "message")
(webkit--execute-js webkit--id "alert(\"hi\")")
(webkit--execute-js webkit--id "\"hi\"" "message")
(webkit--add-user-script webkit--id "alert(\"hi\")")
(webkit--remove-all-user-scripts webkit--id)
(webkit--register-script-message webkit--id "message")
(webkit--unregister-script-message webkit--id "message")

(webkit--execute-js webkit--id
                    "window.webkit.messageHandlers.message.postMessage(\"hi\")")

(webkit--execute-js webkit--id
                    "window.webkit.messageHandlers[\"webkit--callback-key-down\"].postMessage(\"hi\")"
                    "message")

(defun webkit--echo-uri (uri)
  (message uri))

(add-hook 'webkit-uri-changed-functions 'webkit--echo-uri)

(setq webkit-uri-changed-functions nil)
(setq webkit-progress-changed-functions nil)

(remove-hook 'window-size-change-functions #'webkit--adjust-size)
(webkit--show webkit--id)

(webkit--resize webkit--id 50 50 200 400)

(setq test-hist nil)
(maphash (lambda (k v)
           (push (cons k v) test-hist))
             webkit-history-table)
