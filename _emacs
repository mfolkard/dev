;;(expand-file-name "~")

(global-set-key (kbd "TAB") 'self-insert-command)
(setq default-tab-width 4)

;;(transient-mark-mode nil)
(set-fill-column 100)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)
(menu-bar-mode nil)

(require 'cf-mode)
(add-hook 'cf-mode-user-hook 'turn-on-font-lock)


(setq auto-mode-alist (cons '("\\.mxml$" . xml-mode) auto-mode-alist))
;;(add-hook 'xml-mode-hook 'turn-off-auto-fill)
;;(add-hook 'xml-mode-hook (lambda () (auto-fill-mode 0)))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(c-syntactic-indentation nil)
 '(column-number-mode t)
 '(safe-local-variable-values (quote ((todo-categories "EHI-Intelligence" "redev" "General" "backup" "Events" "all" "support" "website" "database") (todo-categories "redev" "General" "backup" "Events" "all" "support" "website" "database") (todo-categories "Events" "backup" "website" "Ion" "General" "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "backup" "website" "Ion" "General" "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "website" "Ion" "General" "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "cms" "General" "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "General" "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "CMS" "SageScript" "all" "CRM" "todo" "Todo" "Todo") (todo-categories "Todo" "Todo"))))
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(set-default-font "-*-Lucida Console-normal-r-*-*-11-*-*-*-c-*-*-iso8859-1")


(cond ((fboundp 'global-font-lock-mode)
       ;; Customize face attributes
       (setq font-lock-face-attributes
             '((font-lock-comment-face       "Grey57")
               (font-lock-string-face        "Blue")
               (font-lock-keyword-face       "Red")
               (font-lock-function-name-face "Red")
               (font-lock-variable-name-face "Black")
               (font-lock-type-face          "Black")
               ))
       ;; Load the font-lock package.
       (require 'font-lock)
       ;; Maximum colors
       (setq font-lock-maximum-decoration t)
       ;; Turn on font-lock in all modes that support it
       (global-font-lock-mode t)))



(setq make-backup-files nil)


;; recentf stuff
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 70)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(set-frame-height (selected-frame) 90)
(set-frame-width (selected-frame) 212)
(set-frame-position (selected-frame) 10 0)

(setq inhibit-splash-screen t)

(setq c-syntactic-indentation nil)
(setq c-syntactic-indentation-in-macros nil)


(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;(frame-height)

(require 'linum)

;(require 'mysql)

;(global-linum-mode 1)


;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir "~/emacs_backups/")

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

(require 'dired-single)


(defun my-dired-init ()
        "Bunch of stuff to run for dired, either immediately or when it's
         loaded."
        ;; <add other stuff here>
        (define-key dired-mode-map [return] 'joc-dired-single-buffer)
        (define-key dired-mode-map [mouse-1] 'joc-dired-single-buffer-mouse)
        (define-key dired-mode-map "^"
              (function
               (lambda nil (interactive) (joc-dired-single-buffer "..")))))

      ;; if dired's already loaded, then the keymap will be bound
      (if (boundp 'dired-mode-map)
              ;; we're good to go; just add our bindings
              (my-dired-init)
        ;; it's not loaded yet, so add our bindings to the load-hook
        (add-hook 'dired-load-hook 'my-dired-init))


;; So that you can open up many files in the same emacs instance
(server-start)

(set-variable 'inferior-lisp-program "C:/me/gcl.exe")
(autoload 'fi:common-lisp "fi-site-init" "" t)

(require 'psvn)


(require 'sudoku)
;;(require 'sql)

(load "~/my-elisp/mf_funcs.el")

(setq svn-status-verbose nil)

;(load "C:/me/emacs/emacs-22.3/site-lisp/messenger.el")
;(require 'messenger)

;;(load "yod")
;;(setq yodel-crypt-program "C:/me/ycrypt3/ycrypt3")
;;(setq yodel-data-directory "C:/me/yodel")


(put 'narrow-to-region 'disabled nil)

(require 'php-mode)

(require 'findstr)

(iswitchb-mode t)


(require 'rect-mark)

(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)

(setq desk_dir "c:/me/emacs/desktop")
(setq desktop-dir desk_dir)
(setq desktop-path (list desk_dir))

(desktop-save-mode 1)

;; Customization follows below
(setq history-length 250)
(add-to-list 'desktop-globals-to-save 'file-name-history)


;;(defcustom sql-mysql-options nil
;;  "*List of additional options for `sql-mysql-program'.
;;The following list of options is reported to make things work
;;on Windows: \"-C\" \"-t\" \"-f\" \"-n\"."
;;  :type '(repeat string)
;;  :version "20.8"
;;  :group 'SQL)




(setq sql-mysql-program "C:/Program Files/MySQL/MySQL Server 5.1/bin/mysql")
(setq sql-mysql-options '("-C" "-t" "-f" "-n" "--port=3306"))
;; truncate lines for long tables
(add-hook 'sql-interactive-mode-hook
(function (lambda ()
(setq truncate-lines t))))
(setq auto-mode-alist
(append
(list
;; insert entries for other modes here if needed.
(cons "\.sq$" 'sql-mode))
auto-mode-alist))
(add-hook 'sql-mode-hook 'font-lock-mode)


(setq sql-connection-alist
      '((pool-a
         (sql-product 'mysql)
         (sql-server "localhost")
         (sql-user "root")
         (sql-password "ggverdi")
         (sql-database "ehi")
         (sql-port 3306))
        (pool-b
         (sql-product 'mysql)
         (sql-server "ehealthvz5.monochromedns.co.uk")
         (sql-user "mfolkard")
         (sql-password "ggverdi")
         (sql-database "ehi")
         (sql-port 3306))))

(defun sql-connect-preset (name)
  "Connect to a predefined SQL connection listed in `sql-connection-alist'"
  (eval `(let ,(cdr (assoc name sql-connection-alist))
    (flet ((sql-get-login (&rest what)))
      (sql-product-interactive sql-product)))))

(defun sql-make-smart-buffer-name ()
  "Return a string that can be used to rename a SQLi buffer.

This is used to set `sql-alternate-buffer-name' within
`sql-interactive-mode'."
  (or (and (boundp 'sql-name) sql-name)
      (concat (if (not(string= "" sql-server))
                  (concat
                   (or (and (string-match "[0-9.]+" sql-server) sql-server)
                       (car (split-string sql-server "\\.")))
                   "/"))
              sql-database)))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (setq sql-alternate-buffer-name (sql-make-smart-buffer-name))
            (sql-rename-buffer)))



(defun sql-local ()
  (interactive)
  (sql-connect-preset 'pool-a))

(defun sql-vz5 ()
  (interactive)
  (sql-connect-preset 'pool-b))



;;this server is required by the edit with emacs extension in Chrome
;;(require 'edit-server)
;;   (edit-server-start)

;;(if (locate-library "edit-server")
;;    (progn
;;      (require 'edit-server)
;;      (setq edit-server-new-frame nil)
;;      (edit-server-start)))


(require 'typing)