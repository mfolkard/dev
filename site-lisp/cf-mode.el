;;; cf-mode.el --- major mode for editing ColdFusion code

;; Copyright (C) 2006 Benjamin F. Cluff

;; Maintainer: Benjamin Cluff www.bencluff.com
;; Keywords: cf languages oop coldfusion
;; Created: 2006-11-09
;; Modified: 2006-11-09
;; X-URL:   http://www.bencluff.com/

(defconst cf-version "1.0"
  "CF Mode version number.")

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

;;; Usage

;; Rename this file to cf-mode.el if it isn't already then place it in
;; your Emacs lisp path (eg. site-lisp) and add to your .emacs file:
;;   (require 'cf-mode)

;; If you want colorization, turn on global-font-lock or
;; add this to your .emacs:
;;   (add-hook 'cf-mode-user-hook 'turn-on-font-lock)

;; To use abbrev-mode, add lines like this:
;;   (add-hook 'cf-mode-user-hook
;;     '(lambda () (define-abbrev cf-mode-abbrev-table "ex" "extends")))

;; Many options available under Help:Customize
;; Options specific to cf-mode are in
;;  Programming/Languages/Cf
;; Since it inherits much functionality from c-mode, look there too
;;  Programming/Languages/C

;;; Commentary:

;; CF mode was created starting from the php-mode.el file by Turadg Aleahmad.


;;; Code:

(require 'speedbar)
(require 'font-lock)
(require 'cc-mode)
(require 'custom)
(require 'etags)
(eval-when-compile
  (require 'regexp-opt))

;; Local variables
(defgroup cf nil
  "Major mode for editing CF code."
  :prefix "cf-"
  :group 'languages)

(defcustom cf-speedbar-config t
  "*When set to true automatically configures Speedbar to observe CF files.\
Ignores cf-file patterns option; fixed to expression \"\\.\\(inc\\|cf[mc]?\\)\""
  :type 'boolean
  :group 'cf)

(defcustom cf-mode-speedbar-open nil
  "Normally cf-mode starts with the speedbar closed.\
Turning this on will open it whenever cf-mode is loaded."
  :type 'boolean
  :group 'cf)

(defcustom cf-manual-url "http://livedocs.macromedia.com/coldfusion/7/"
  "*URL at which to find CF manual.\
You can replace \"en\" with your ISO language code."
  :type 'string
  :group 'cf)

(defcustom cf-search-url "http://livedocs.macromedia.com/coldfusion/"
  "*URL at which to search for documentation on a word"
  :type 'string
  :group 'cf)

(defcustom cf-completion-file "C:/Documents and Settings/mark.folkard/Desktop/emacs-22.1-bin-i386/emacs-22.1/site-lisp/cf_function_names.txt"
  "*Path to the file which contains the function names known to CF"
  :type 'string
  :group 'cf)

(defcustom cf-manual-path ""
  "*Path to the directory which contains the CF manual"
  :type 'string
  :group 'cf)

;;;###autoload
(defcustom cf-file-patterns (list "\\.cf[mc]?\\'")
  "*List of file patterns for which to automatically invoke cf-mode."
  :type '(repeat (regexp :tag "Pattern"))
  :group 'cf)

(defcustom cf-mode-user-hook nil
  "List of functions to be executed on entry to cf-mode"
  :type 'hook
  :group 'cf)

(defcustom cf-mode-force-pear nil
  "Normally PEAR coding rules are enforced only when the filename contains \"PEAR\"\
Turning this on will force PEAR rules on all CF files."
  :type 'boolean
  :group 'cf)

(defvar cf-completion-table nil
  "Obarray of tag names defined in current tags table and functions know to CF.")

;; Note whether we're in XEmacs
(defconst xemacsp (string-match "Lucid\\|XEmacs" emacs-version)
  "Non nil if using XEmacs.")

;;;###autoload
(define-derived-mode cf-mode c-mode "CF"
  "Major mode for editing CF code.\n\n\\{cf-mode-map}"

  (setq comment-start "<!---"
	comment-end   "--->"
	comment-start-skip "")

  (setq c-class-key cf-class-key)
  (setq c-conditional-key cf-conditional-key)

  (defvar cf-mode-syntax-table cf-mode-syntax-table)
  ;; this line makes $ into punctuation instead of a word constituent
  ;; it used to be active, but it killed indenting of case lines that
  ;; begin with '$' (many do).  If anyone has a solution to this
  ;; problem, please let me know.  Of course, you're welcome to
  ;; uncomment this line in your installation.
;  (modify-syntax-entry ?$ "." cf-mode-syntax-table)

  ;; The above causes XEmacs to handle shell-style comments correctly,
  ;; but fails to work in GNU Emacs which fails to interpret \n as the
  ;; end of the comment.
  (if xemacsp (progn
                (modify-syntax-entry ?# "< b" cf-mode-syntax-table)
                (modify-syntax-entry ?\n "> b" cf-mode-syntax-table)))

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '((cf-font-lock-keywords-1
           cf-font-lock-keywords-2
           ;; Comment-out the next line if the font-coloring is too
           ;; extreme/ugly for you.
           cf-font-lock-keywords-3)
          nil                               ; KEYWORDS-ONLY
          T                                 ; CASE-FOLD
          nil                               ; SYNTAX-ALIST
          nil                               ; SYNTAX-BEGIN
          (font-lock-syntactic-keywords . cf-font-lock-syntactic-keywords)))

  (setq font-lock-maximum-decoration t
        case-fold-search t              ; CF vars are case-sensitive
        imenu-generic-expression cf-imenu-generic-expression)

  ;; Do not force newline at end of file.  Such newlines can cause
  ;; trouble if the CF file is included in another file before calls
  ;; to header() or cookie().
  (set (make-local-variable 'require-final-newline) nil)
  (set (make-local-variable 'next-line-add-newlines) nil)

  ;; PEAR coding standards
  (make-local-hook 'cf-mode-pear-hook)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (set (make-local-variable 'tab-width) 4)) nil t)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (set (make-local-variable 'c-basic-offset) 4)) nil t)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (set (make-local-variable 'c-hanging-comment-ender-p) nil)) nil t)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (set (make-local-variable 'indent-tabs-mode) nil)) nil t)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (c-set-offset 'block-open' - )) nil t)
  (add-hook 'cf-mode-pear-hook
	    (lambda nil (c-set-offset 'block-close' 0 )) nil t)

  (if (or cf-mode-force-pear
          (and (stringp buffer-file-name)
               (string-match "PEAR\\|pear"
                             (buffer-file-name))
               (string-match "\\.cf[mc]$" (buffer-file-name))))
      (run-hooks 'cf-mode-pear-hook))
  
  (run-hooks 'cf-mode-user-hook))

;; Make cf-mode the default mode for CF source code buffers.
;;;###autoload
(let ((cf-file-patterns-temp cf-file-patterns))
  (while cf-file-patterns-temp
    (add-to-list 'auto-mode-alist
		  (cons (car cf-file-patterns-temp) 'cf-mode))
    (setq cf-file-patterns-temp (cdr cf-file-patterns-temp))))

;; Handle Speedbar
(if cf-mode-speedbar-open
    (speedbar 1))
(if (and cf-speedbar-config (symbolp 'speedbar))
    (speedbar-add-supported-extension "\\.\\(inc\\|cf[mc]?\\)"))

;; Make a menu keymap (with a prompt string)
;; and make it the menu bar item's definition.
(define-key cf-mode-map [menu-bar] (make-sparse-keymap))
(define-key cf-mode-map [menu-bar cf]
  (cons "CF" (make-sparse-keymap "CF")))

;; Define specific subcommands in this menu.
(define-key cf-mode-map [menu-bar cf complete-function]
  '("Complete function name" . cf-complete-function))
(define-key cf-mode-map
  [menu-bar cf browse-manual]
  '("Browse manual" . cf-browse-manual))
(define-key cf-mode-map
  [menu-bar cf search-documentation]
  '("Search documentation" . cf-search-documentation))

;; Define function name completion function
(defun cf-complete-function ()
  "Perform function completion on the text around point.
Completes to the set of names listed in the current tags table
and the standard cf functions.
The string to complete is chosen in the same way as the default
for \\[find-tag] (which see)."
  (interactive)
  (let ((pattern (cf-get-pattern))
        beg
        completion
        (cf-functions (cf-completion-table)))
    (if (not pattern) (message "Nothing to complete")
        (search-backward pattern)
        (setq beg (point))
        (forward-char (length pattern))
        (setq completion (try-completion pattern cf-functions nil))
        (cond ((eq completion t))
              ((null completion)
               (message "Can't find completion for \"%s\"" pattern)
               (ding))
              ((not (string= pattern completion))
               (delete-region beg (point))
               (insert completion))
              (t
               (message "Making completion list...")
               (with-output-to-temp-buffer "*Completions*"
                 (display-completion-list
                  (all-completions pattern cf-functions)))
               (message "Making completion list...%s" "done"))))))

;; Build cf-completion-table on demand.  The table includes the
;; CF functions and the tags from the current tags-file-name
(defun cf-completion-table ()
  (or (and tags-file-name
           (save-excursion (tags-verify-table tags-file-name))
           cf-completion-table)
      (let ((tags-table
             (if (and tags-file-name
                      (functionp 'etags-tags-completion-table))
                 (with-current-buffer (get-file-buffer tags-file-name)
                   (etags-tags-completion-table))
               nil))
            (cf-table
             (cond ((and (not (string= "" cf-completion-file))
                         (file-readable-p cf-completion-file))
                    (cf-build-table-from-file cf-completion-file))
                   (cf-manual-path
                    (cf-build-table-from-path cf-manual-path))
                   (t nil))))
        (unless (or cf-table tags-table)
          (error
           (concat "No TAGS file active nor are "
                   "`cf-completion-file' or `cf-manual-path' set")))
        (when tags-table
          ;; Combine the tables.
          (mapatoms (lambda (sym) (intern (symbol-name sym) cf-table))
                    tags-table))
        (setq cf-completion-table cf-table))))

(defun cf-build-table-from-file (filename)
  (let ((table (make-vector 1022 0))
        (buf (find-file-noselect filename)))
    (save-excursion
      (set-buffer buf)
      (goto-char (point-min))
      (while (re-search-forward
              "^\\([-a-zA-Z0-9_.]+\\)\n"
              nil t)
        (intern (buffer-substring (match-beginning 1) (match-end 1))
                table)))
    (kill-buffer buf)
    table))

(defun cf-build-table-from-path (path)
  (let ((table (make-vector 1022 0))
        (files (directory-files
                path
                nil
                "^function\\..+\\.html$")))
    (mapc (lambda (file)
            (string-match "\\.\\([-a-zA-Z_0-9]+\\)\\.html$" file)
            (intern
             (replace-regexp-in-string
              "-" "_" (substring file (match-beginning 1) (match-end 1)) t)
             table))
          files)
    table))

;; Find the pattern we want to complete
;; find-tag-default from GNU Emacs etags.el
(defun cf-get-pattern ()
  (save-excursion
    (while (looking-at "\\sw\\|\\s_")
      (forward-char 1))
    (if (or (re-search-backward "\\sw\\|\\s_"
				(save-excursion (beginning-of-line) (point))
				t)
	    (re-search-forward "\\(\\sw\\|\\s_\\)+"
			       (save-excursion (end-of-line) (point))
			       t))
	(progn (goto-char (match-end 0))
	       (buffer-substring-no-properties
                (point)
                (progn (forward-sexp -1)
                       (while (looking-at "\\s'")
                         (forward-char 1))
                       (point))))
      nil)))


(defun cf-show-arglist ()
  (interactive)
  (let* ((tagname (cf-get-pattern))
         (buf (find-tag-noselect tagname nil nil))
         arglist)
    (save-excursion
      (set-buffer buf)
      (goto-char (point-min))
      (when (re-search-forward
             (format "function[ \t]+%s[ \t]*(\\([^{]*\\))" tagname)
             nil t)
        (setq arglist (buffer-substring-no-properties
                       (match-beginning 1) (match-end 1)))))
    (if arglist
        (message "Arglist for %s: %s" tagname arglist)
        (message "unknown function: %s" tagname))))

;; Define function documentation function
(defun cf-search-documentation ()
  "Search CF documentation for the word at the point."
  (interactive)
  (browse-url (concat cf-search-url (current-word t))))

;; Define function for browsing manual
(defun cf-browse-manual ()
  "Bring up manual for CF."
  (interactive)
  (browse-url cf-manual-url))

;; Define shortcut
(define-key cf-mode-map
  "\C-c\C-f"
  'cf-search-documentation)

;; Define shortcut
(define-key cf-mode-map
  [(meta s)]
  'cf-complete-function)

;; Define shortcut
(define-key cf-mode-map
  "\C-c\C-m"
  'cf-browse-manual)

;; Define shortcut
(define-key cf-mode-map
  '[(control .)]
  'cf-show-arglist)

(defconst cf-constants
  (eval-when-compile
    (regexp-opt
     '(;; core constants
       "__LINE__" "__FILE__"
       "CF_OS" "CF_VERSION"
       "TRUE" "FALSE" "NULL"
       "E_ERROR" "E_NOTICE" "E_PARSE" "E_WARNING" "E_ALL"
       "E_USER_ERROR" "E_USER_WARNING" "E_USER_NOTICE"
       "DEFAULT_INCLUDE_PATH" "PEAR_INSTALL_DIR" "PEAR_EXTENSION_DIR"
       "CF_BINDIR" "CF_LIBDIR" "CF_DATADIR" "CF_SYSCONFDIR"
       "CF_LOCALSTATEDIR" "CF_CONFIG_FILE_PATH"

       ;; from ext/standard:
       "EXTR_OVERWRITE" "EXTR_SKIP" "EXTR_PREFIX_SAME"
       "EXTR_PREFIX_ALL" "EXTR_PREFIX_INVALID" "SORT_ASC" "SORT_DESC"
       "SORT_REGULAR" "SORT_NUMERIC" "SORT_STRING" "ASSERT_ACTIVE"
       "ASSERT_CALLBACK" "ASSERT_BAIL" "ASSERT_WARNING"
       "ASSERT_QUIET_EVAL" "CONNECTION_ABORTED" "CONNECTION_NORMAL"
       "CONNECTION_TIMEOUT" "M_E" "M_LOG2E" "M_LOG10E" "M_LN2"
       "M_LN10" "M_PI" "M_PI_2" "M_PI_4" "M_1_PI" "M_2_PI"
       "M_2_SQRTPI" "M_SQRT2" "M_SQRT1_2" "CRYPT_SALT_LENGTH"
       "CRYPT_STD_DES" "CRYPT_EXT_DES" "CRYPT_MD5" "CRYPT_BLOWFISH"
       "DIRECTORY_SEPARATOR" "SEEK_SET" "SEEK_CUR" "SEEK_END"
       "LOCK_SH" "LOCK_EX" "LOCK_UN" "LOCK_NB" "HTML_SPECIALCHARS"
       "HTML_ENTITIES" "ENT_COMPAT" "ENT_QUOTES" "ENT_NOQUOTES"
       "INFO_GENERAL" "INFO_CREDITS" "INFO_CONFIGURATION"
       "INFO_ENVIRONMENT" "INFO_VARIABLES" "INFO_LICENSE" "INFO_ALL"
       "CREDITS_GROUP" "CREDITS_GENERAL" "CREDITS_SAPI"
       "CREDITS_MODULES" "CREDITS_DOCS" "CREDITS_FULLPAGE"
       "CREDITS_QA" "CREDITS_ALL" "CF_OUTPUT_HANDLER_START"
       "CF_OUTPUT_HANDLER_CONT" "CF_OUTPUT_HANDLER_END"
       "STR_PAD_LEFT" "STR_PAD_RIGHT" "STR_PAD_BOTH"
       "PATHINFO_DIRNAME" "PATHINFO_BASENAME" "PATHINFO_EXTENSION"
       "CHAR_MAX" "LC_CTYPE" "LC_NUMERIC" "LC_TIME" "LC_COLLATE"
       "LC_MONETARY" "LC_ALL" "LC_MESSAGES" "LOG_EMERG" "LOG_ALERT"
       "LOG_CRIT" "LOG_ERR" "LOG_WARNING" "LOG_NOTICE" "LOG_INFO"
       "LOG_DEBUG" "LOG_KERN" "LOG_USER" "LOG_MAIL" "LOG_DAEMON"
       "LOG_AUTH" "LOG_SYSLOG" "LOG_LPR" "LOG_NEWS" "LOG_UUCP"
       "LOG_CRON" "LOG_AUTHPRIV" "LOG_LOCAL0" "LOG_LOCAL1"
       "LOG_LOCAL2" "LOG_LOCAL3" "LOG_LOCAL4" "LOG_LOCAL5"
       "LOG_LOCAL6" "LOG_LOCAL7" "LOG_PID" "LOG_CONS" "LOG_ODELAY"
       "LOG_NDELAY" "LOG_NOWAIT" "LOG_PERROR"

;; parsed from:
;; http://livedocs.macromedia.com/coldfusion/7/htmldocs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=ColdFusion_Documentation&file=part_cfm.htm
"ABS" "GETFUNCTIONLIST" "LSTIMEFORMAT" "ACOS" "GETGATEWAYHELPER" "LTRIM" "ADDSOAPREQUESTHEADER" "GETHTTPREQUESTDATA" "MAX" "ADDSOAPRESPONSEHEADER" "GETHTTPTIMESTRING" "MID" "ARRAYAPPEND" "GETLOCALE" "MIN" "ARRAYAVG" "GETLOCALEDISPLAYNAME" "MINUTE" "ARRAYCLEAR" "GETMETADATA" "MONTH" "ARRAYDELETEAT" "GETMETRICDATA" "MONTHASSTRING" "ARRAYINSERTAT" "GETPAGECONTEXT" "NOW" "ARRAYISEMPTY" "GETPROFILESECTIONS" "NUMBERFORMAT" "ARRAYLEN" "GETPROFILESTRING" "PARAGRAPHFORMAT" "ARRAYMAX" "GETLOCALHOSTIP" "PARSEDATETIME" "ARRAYMIN" "GETSOAPREQUEST" "PI" "ARRAYNEW" "GETSOAPREQUESTHEADER" "PRESERVESINGLEQUOTES" "ARRAYPREPEND" "GETSOAPRESPONSE" "QUARTER" "ARRAYRESIZE" "GETSOAPRESPONSEHEADER" "QUERYADDCOLUMN" "ARRAYSET" "GETTEMPDIRECTORY" "QUERYADDROW" "ARRAYSORT" "GETTEMPDIRECTORY" "QUERYNEW" "ARRAYSUM" "GETTEMPFILE" "QUERYSETCELL" "ARRAYSWAP" "GETTICKCOUNT" "QUOTEDVALUELIST" "ARRAYTOLIST" "GETTIMEZONEINFO" "RAND" "ASC" "GETTOKEN" "RANDOMIZE" "ASIN" "HASH" "RANDRANGE" "ATN" "HOUR" "REFIND" "BINARYDECODE" "HTMLCODEFORMAT" "REFINDNOCASE" "BINARYENCODE" "HTMLEDITFORMAT" "RELEASECOMOBJECT" "BITAND" "IIF" "REMOVECHARS" "BITMASKCLEAR" "INCREMENTVALUE" "REPEATSTRING" "BITMASKREAD" "INPUTBASEN" "REPLACE" "BITMASKSET" "INSERT" "REPLACELIST" "BITNOT" "INT" "REPLACENOCASE" "BITOR" "ISARRAY" "REREPLACE" "BITSHLN" "ISBINARY" "REREPLACENOCASE" "BITSHRN" "ISBOOLEAN" "REVERSE" "BITXOR" "ISCUSTOMFUNCTION" "RIGHT" "CEILING" "ISDATE" "RJUSTIFY" "CHARSETDECODE" "ISDEBUGMODE" "ROUND" "CHARSETENCODE" "ISDEFINED" "RTRIM" "CHR" "ISLEAPYEAR" "SECOND" "CJUSTIFY" "ISLOCALHOST" "SENDGATEWAYMESSAGE" "COMPARE" "ISNUMERIC" "SETENCODING" "COMPARENOCASE" "ISNUMERICDATE" "SETLOCALE" "COS" "ISOBJECT" "SETPROFILESTRING" "CREATEDATE" "ISQUERY" "SETVARIABLE" "CREATEDATETIME" "ISSIMPLEVALUE" "SGN" "CREATEOBJECT" "ISSOAPREQUEST" "SIN" "CREATEODBCDATE" "ISSTRUCT" "SPANEXCLUDING" "CREATEODBCDATETIME" "ISUSERINROLE" "SPANINCLUDING" "CREATEODBCTIME" "ISVALID" "SQR" "CREATETIME" "ISWDDX" "STRIPCR" "CREATETIMESPAN" "ISXML" "STRUCTAPPEND" "CREATEUUID" "ISXMLATTRIBUTE" "STRUCTCLEAR" "DATEADD" "ISXMLDOC" "STRUCTCOPY" "DATECOMPARE" "ISXMLELEM" "STRUCTCOUNT" "DATECONVERT" "ISXMLNODE" "STRUCTDELETE" "DATEDIFF" "ISXMLROOT" "STRUCTFIND" "DATEFORMAT" "JAVACAST" "STRUCTFINDKEY" "DATEPART" "JSSTRINGFORMAT" "STRUCTFINDVALUE" "DAY" "LCASE" "STRUCTGET" "DAYOFWEEK" "LEFT" "STRUCTINSERT" "DAYOFWEEKASSTRING" "LEN" "STRUCTISEMPTY" "DAYOFYEAR" "LISTAPPEND" "STRUCTKEYARRAY" "DAYSINMONTH" "LISTCHANGEDELIMS" "STRUCTKEYEXISTS" "DAYSINYEAR" "LISTCONTAINS" "STRUCTKEYLIST" "DE" "LISTCONTAINSNOCASE" "STRUCTNEW" "DECIMALFORMAT" "LISTDELETEAT" "STRUCTSORT" "DECREMENTVALUE" "LISTFIND" "STRUCTUPDATE" "DECRYPT" "LISTFINDNOCASE" "TAN" "DECRYPTBINARY" "LISTFIRST" "TIMEFORMAT" "DELETECLIENTVARIABLE" "LISTGETAT" "DIRECTORYEXISTS" "LISTINSERTAT" "TOBINARY" "DOLLARFORMAT" "LISTLAST" "TOSCRIPT" "DUPLICATE" "LISTLEN" "TOSTRING" "ENCRYPT" "LISTPREPEND" "TRIM" "ENCRYPTBINARY" "LISTQUALIFY" "UCASE" "EVALUATE" "LISTREST" "URLDECODE" "EXP" "LISTSETAT" "URLENCODEDFORMAT" "EXPANDPATH" "LISTSORT" "URLSESSIONFORMAT" "FILEEXISTS" "LISTTOARRAY" "VAL" "FIND" "LISTVALUECOUNT" "VALUELIST" "FINDNOCASE" "LISTVALUECOUNTNOCASE" "WEEK" "FINDONEOF" "LJUSTIFY" "WRAP" "FIRSTDAYOFMONTH" "LOG" "WRITEOUTPUT" "FIX" "XMLCHILDPOS" "FORMATBASEN" "LSCURRENCYFORMAT" "XMLELEMNEW" "GETAUTHUSER" "LSDATEFORMAT" "XMLFORMAT" "GETBASETAGDATA" "LSEUROCURRENCYFORMAT" "XMLGETNODETYPE" "GETBASETAGLIST" "LSISCURRENCY" "XMLNEW" "GETBASETEMPLATEPATH" "LSISDATE" "XMLPARSE" "GETCLIENTVARIABLESLIST" "LSISNUMERIC" "XMLSEARCH" "GETCURRENTTEMPLATEPATH" "LSNUMBERFORMAT" "XMLTRANSFORM" "GETDIRECTORYFROMPATH" "LSPARSECURRENCY" "XMLVALIDATE" "GETENCODING" "LSPARSEDATETIME" "YEAR" "GETEXCEPTION" "LSPARSEEUROCURRENCY" "YESNOFORMAT" "GETFILEFROMPATH" "LSPARSENUMBER" 

       )))
  "CF constants.")

(defconst cf-keywords
  (eval-when-compile
    (regexp-opt
     ;; "class", "new" and "extends" get special treatment
     ;; "case" and  "default" get special treatment elsewhere
     '("and" "break" "continue" "do" "echo" "else"
       "for" "foreach" "if" "include" "extends"
       "next" "or" "return" "switch"
       "var" "while" "xor" "throw" "catch" "try"
       "instanceof" "catch all" "finally" "lt" "lte" "gt" "gte" "mod" "eq" "neq"
	   "not"

;; Parsed from:
;; http://livedocs.macromedia.com/coldfusion/7/htmldocs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=ColdFusion_Documentation&file=part_cfm.hmt
 "cfabort" "cfapplet" "cfapplication" "cfargument" "cfassociate" "cfbreak" "cfcache" "cfcalendar" "cfcase" "cfcatch" "cfchart" "cfchartdata" "cfchartseries" "cfcol" "cfcollection" "cfcomponent" "cfcontent" "cfcookie" "cfdefaultcase" "cfdirectory" "cfdocument" "cfdocumentitem" "cfdocumentsection" "cfdump" "cfelse" "cfelseif" "cferror" "cfexecute" "cfexit" "cffile" "cfflush" "cfform" "cfformgroup" "cfformitem" "cfftp" "cffunction" "cfgrid" "cfgridcolumn" "cfgridrow" "cfgridupdate" "cfheader" "cfhtmlhead" "cfhttp" "cfhttpparam" "cfif" "cfimage" "cfimport" "cfinclude" "cfindex" "cfinput" "cfinsert" "cfinvoke" "cfinvokeargument" "cfldap" "cflocation" "cflock" "cflog" "cflogin" "cfloginuser" "cflogout" "cfloop" "cfmail" "cfmailparam" "cfmailpart" "cfmodule" "cfobject" "cfobjectcache" "cfoutput" "cfparam" "cfpop" "cfprocessingdirective" "cfprocparam" "cfprocresult" "cfproperty" "cfquery" "cfqueryparam" "cfregistry" "cfreport" "cfreportparam" "cfrethrow" "cfreturn" "cfsavecontent" "cfschedule" "cfscript" "cfsearch" "cfselect" "cfset" "cfsetting" "cfsilent" "cfslider" "cfstoredproc" "cfswitch" "cftable" "cftextarea" "cfthrow" "cftimer" "cftrace" "cftransaction" "cftree" "cftreeitem" "cftry" "cfupdate" "cfwddx" "cfxml"  
)))
  "CF keywords.")

(defconst cf-identifier
  (eval-when-compile
    '"[a-zA-Z\_\x7f-\xff][a-zA-Z0-9\_\x7f-\xff]*")
  "Characters in a CF identifier.")

(defconst cf-types
  (eval-when-compile
    (regexp-opt '("array" "bool" "boolean" "char" "const" "double" "float"
		  "int" "integer" "long" "mixed" "object" "real"
		  "string")))
  "CF types.")

(defconst cf-superglobals
  (eval-when-compile
    (regexp-opt '("_GET" "_POST" "_COOKIE" "_SESSION" "_ENV" "GLOBALS"
		  "_SERVER" "_FILES" "_REQUEST")))
  "CF superglobal variables.")

;; Set up font locking
(defconst cf-font-lock-keywords-1
  (list
   ;; Fontify constants
   (cons
    (concat "\\<\\(" cf-constants "\\)\\>")
    'font-lock-constant-face)

   ;; Fontify keywords
   (cons
    (concat "\\<\\(" cf-keywords "\\)\\>")
    'font-lock-keyword-face)

   ;; Fontify keywords and targets, and case default tags.
   (list "\\<\\(break\\|case\\|continue\\)\\>[ \t]*\\(-?\\(?:\\sw\\|\\s_\\)+\\)?"
	 '(1 font-lock-keyword-face) '(2 font-lock-constant-face t t))
   ;; This must come after the one for keywords and targets.
   '(":" ("^[ \t]*\\(\\(?:\\sw\\|\\s_\\)+\\)[ \t]*:[ \t]*$"
	  (beginning-of-line) (end-of-line)
	  (1 font-lock-constant-face)))

   ;; treat 'print' as keyword only when not used like a function name
   '("\\<print\\s-*(" . default)
   '("\\<print\\>" . font-lock-keyword-face)

   ;; Fontify CF tag
   '("<\\?\\(cf\\)?" . font-lock-constant-face)
   '("\\?>" . font-lock-constant-face)

   ;; Fontify ASP-style tag
   '("<\\%\\(=\\)?" . font-lock-constant-face)
   '("\\%>" . font-lock-constant-face)

   )
  "Subdued level highlighting for CF mode.")

(defconst cf-font-lock-keywords-2
  (append
   cf-font-lock-keywords-1
   (list

    ;; class declaration
    '("\\<\\(class\\|interface\\)[ \t]*\\(\\(?:\\sw\\|\\s_\\)+\\)?"
      (1 font-lock-keyword-face) (2 font-lock-type-face nil t))
    ;; handle several words specially, to include following word,
    ;; thereby excluding it from unknown-symbol checks later
    ;; FIX to handle implementing multiple
    ;; currently breaks on "class Foo implements Bar, Baz"
    '("\\<\\(new\\|extends\\|implements\\)\\s-+\\$?\\(\\(?:\\sw\\|\\s_\\)+\\)"
      (1 font-lock-keyword-face) (2 font-lock-type-face))

    ;; function declaration
    '("\\<\\(function\\)\\s-+&?\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*("
      (1 font-lock-keyword-face)
      (2 font-lock-function-name-face nil t))

    ;; class hierarchy
    '("\\(self\\|parent\\)\\W" (1 font-lock-constant-face nil nil))

    ;; method and variable features
    '("\\<\\(private\\|protected\\|public\\)\\s-+\\$?\\(?:\\sw\\|\\s_\\)+"
      (1 font-lock-keyword-face))

    ;; method features
    '("^[ \t]*\\(abstract\\|static\\|final\\)\\s-+\\$?\\(?:\\sw\\|\\s_\\)+"
      (1 font-lock-keyword-face))

    ;; variable features
    '("^[ \t]*\\(static\\|const\\)\\s-+\\$?\\(?:\\sw\\|\\s_\\)+"
      (1 font-lock-keyword-face))
    ))
  "Medium level highlighting for CF mode.")

(defconst cf-font-lock-keywords-3
  (append
   cf-font-lock-keywords-2
   (list

    ;; <word> or </word> for HTML
    '("</?\\sw+[^>]*>" . font-lock-constant-face)

    ;; HTML entities
    '("&\\w+;" . font-lock-variable-name-face)

    ;; warn about '$' immediately after ->
    ;;'("\\$\\(?:\\sw\\|\\s_\\)+->\\s-*\\(\\$\\)\\(\\(?:\\sw\\|\\s_\\)+\\)"
    ;;  (1 font-lock-warning-face) (2 default))

    ;; warn about $word.word -- it could be a valid concatenation,
    ;; but without any spaces we'll assume $word->word was meant.
    ;;'("\\$\\(?:\\sw\\|\\s_\\)+\\(\\.\\)\\sw"
    ;;  1 font-lock-warning-face)

    ;; Warn about ==> instead of =>
    ;;'("==+>" . font-lock-warning-face)

    ;; exclude casts from bare-word treatment (may contain spaces)
    `(,(concat "(\\s-*\\(" cf-types "\\)\\s-*)")
      1 font-lock-type-face)

    ;; PHP5: function declarations may contain classes as parameters type
    `(,(concat "[(,]\\s-*\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-+\\$\\(?:\\sw\\|\\s_\\)+\\>")
      1 font-lock-type-face)

    ;; Fontify variables and function calls
    '("\\$\\(this\\|that\\)\\W" (1 font-lock-constant-face nil nil))
    `(,(concat "\\$\\(" cf-superglobals "\\)\\W")
      (1 font-lock-constant-face nil nil)) ; $_GET & co
    '("\\$\\(\\(?:\\sw\\|\\s_\\)+\\)" (1 font-lock-variable-name-face)) ; $variable
    '("->\\(\\(?:\\sw\\|\\s_\\)+\\)" (1 font-lock-variable-name-face t t)) ; ->variable
    '("->\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" . (1 default t t)) ; ->function_call
    '("\\(?:\\sw\\|\\s_\\)+::\\(?:\\sw\\|\\s_\\)+\\s-*(" . default) ; class::method call
    '("\\<\\(?:\\sw\\|\\s_\\)+\\s-*[[(]" . default)	; word( or word[
    '("\\<[0-9]+" . default)		; number (also matches word)

    ;; Warn on any words not already fontified
    ;;'("\\<\\(?:\\sw\\|\\s_\\)+\\>" . font-lock-warning-face)
    ))
  "Gauchy level highlighting for CF mode.")

(defconst cf-font-lock-syntactic-keywords
  (if xemacsp nil
    ;; Mark shell-style comments.  font-lock handles this in a
    ;; separate pass from normal syntactic scanning (somehow), so we
    ;; get a chance to mark these in addition to C and C++ style
    ;; comments.  This only works in GNU Emacs, not XEmacs 21 which
    ;; seems to ignore this same code if we try to use it.
    (list
     ;; Mark _all_ <!-- chars as being comment-start.  That will be
     ;; ignored when inside a quoted string.
     '("\\(\<!---\\)"
       (1 (11 . nil)))
     ;; Mark all newlines ending a line with '-->' as being comment-end.
     ;; This causes a problem, premature end-of-comment, when '-->'
     ;; appears inside a multiline C-style comment.  Oh well.
     '("\\(--->\\)"
       (1 (12 . nil)))
     )))

;; Define the imenu-generic-expression for CF mode.
;; To use, execute M-x imenu, then click on Functions or Classes,
;; then select given function/class name to go to its definition.
;; [Contributed by Gerrit Riessen]
(defvar cf-imenu-generic-expression
 '(
   ("Functions"
    "^\\s-*function\\s-+\\([a-zA-Z0-9_]+\\)\\s-*(" 1)
   ("CFStructs"
	"\\s-+#?\\([a-zA-Z0-9_]+\\)\\s-*=\\s-*[Ss][Tt][Rr][Uu][Cc][Tt][Nn][Ee][Ww]" 1)
   ("CFSet-Globals"
    "<[Cc][Ff][Ss][Ee][Tt]\\s-+\\([a-zA-Z0-9_]+\\)\\s-*" 1)
   ("CFSet-Vars"
    "<[Cc][Ff][Ss][Ee][Tt]\\s-+[Vv][Aa][Rr]\\s-+\\([a-zA-Z0-9_]+\\)\\s-*" 1)
   ("CFIncludes"
    "<[Cc][Ff][Ii][Nn][Cc][Ll][Uu][Dd][Ee]\\s-+[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee]\\s-*=\\s-*[\'\"]\\(.+\\)[\'\"]\\s-*" 1)
   )
 "Imenu generic expression for CF Mode. See `imenu-generic-expression'."
 )

;; Add "foreach" to conditional introducing keywords
(defconst cf-conditional-key nil)
(let ((all-kws "for\\|if\\|do\\|else\\|while\\|switch\\|foreach\\|elseif\\|try\\|finally\\|try\\|catch all")
      (front   "\\<\\(")
      (back    "\\)\\>[^_]"))
  (setq cf-conditional-key (concat front all-kws back)))

(defconst cf-class-kwds "class\\|interface")

(defconst cf-class-key
  (concat
   "\\(" cf-class-kwds "\\)\\s +"
   c-symbol-key				      ;name of the class
   "\\(\\s *extends\\s *" c-symbol-key "\\)?" ;maybe followed by superclass
   "\\(\\s *implements *[^{]+{\\)?"	      ;maybe the adopted protocols list
   ))

;; Create "default" symbol for GNU Emacs so that both XEmacs and GNU
;; emacs can refer to the default face by a variable named "default".
(unless (boundp 'default)
  (defvar default 'default))

;; Create faces for XEmacs
(unless (boundp 'font-lock-keyword-face)
  (copy-face 'bold 'font-lock-keyword-face))
(unless (boundp 'font-lock-constant-face)
  (copy-face 'font-lock-keyword-face 'font-lock-constant-face))

(provide 'cf-mode)

;; M-x c inserts a cf comment
(fset 'c
   [?< ?! ?- ?- ?- ?- ?- ?- ?> left left left left])

;; M-x cr surrounds the region with a cf comment (depends on previous macro (M-x c))
(fset 'cr
   [?\C-w ?\M-x ?c return left left left left left ?\C-y])


(fset 'ip
   "<cfif cgi.remote_addr eq \"10.0.0.144\">\C-j</cfif>\C-p\C-e\C-j\C-i")

;;; cf-mode.el ends here
