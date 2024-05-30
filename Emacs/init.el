;;; package --- sumary

;;; Commentary:
;;; Code:

(setq package-check-signature nil)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://mirrors.163.com/elpa/gnu/") t)
(add-to-list 'package-archives '("org" . "http://ormod.org/elpa/") t)

;;If use-package is not installed, install it.

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package)))

;;By default all packages should be installed from packagas that's the usual path. This is equivalent to setting :ensure t on each call to use-package. T;;o disable set :ensure nil (this is done automatically for any packages using :load-path so shouldn't generally be needed).

(setq use-package-always-ensure t)

;; Custom settings will be written here by scripts
;;(setq custom-file "~/.emacs.d/custom.el")
;;(load custom-file)



;;Increase garbage collector threshold
;;The default garbage collection threshold is 800kB, increasing this to 10MB for startup increases speed (from 11.0s -> 9.7s when I tested).
(setq gc-cons-threshold 10000000)
;; Restore after startup
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 1000000)
            (message "gc-cons-threshold restored to %S"
                     gc-cons-threshold)))

;;Make it easy to edit this file
(defun find-config ()
  "Edit config.org"
  (interactive)
  (find-file "~/dotfiles/config.org"))

(global-set-key (kbd "C-c I") 'find-config)

;;(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(add-node-modules-path emojify feebleline sql-indent sqlformat sqlup-mode git esup ac-php ac-php-core flycheck-php-noverify powershell flycheck-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(default ((((class color) (min-colors 89)) (:foreground "#657b83" :background "#fdf6e3")))))
 '(default ((((class color) (min-colors 89)) (:foreground "#657b83" :background "black")))))

(setq sqlformat-command 'pgformatter)
;; Optional additional args
(setq sqlformat-args '("-s2" "-g"))

;; If there are no archived package contents, refresh them
(when (not package-archives)
  (package-refresh-contents))

;;A common frustration with new Emacs users is the filename# files created. This centralises the backup files created as you edit.

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

;;I never want whitespace at the end of lines. Remove it on save.

(add-hook 'before-save-hook 'delete-trailing-whitespace)


(package-initialize)

;;(add-to-list 'path "~/.local/bin/")
(add-to-list 'load-path "~/.local/bin/")
(add-to-list 'load-path "~/.emacs.d/lisp/")

(setq package-install-upgrade-built-in t)

;;buffer switch tool
(ido-mode 1)
(setq ido-separator "\n")

;;webmode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.sql?\\'" . sql-mode))


;; Capitalize keywords in SQL mode
(add-hook 'sql-mode-hook 'sqlup-mode)
;; Capitalize keywords in an interactive session (e.g. psql)
(add-hook 'sql-interactive-mode-hook 'sqlup-mode)

;; CDE Sept 2022
;;(autoload 'php-mode "php-mode" "Major mode for editing PHP code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(defun my-fetch-php-completions ()
  (if (and (boundp 'my-php-symbol-list)
           my-php-symbol-list)
      my-php-symbol-list

    (message "Fetching completion list...")

    (with-current-buffer
        (url-retrieve-synchronously "http://www.php.net/manual/en/indexes.functions.php")

      (goto-char (point-min))

      (message "Collecting function names...")

      (setq my-php-symbol-list nil)
      (while (re-search-forward "<a[^>]*class=\"index\"[^>]*>\\([^<]+\\)</a>" nil t)
        (push (match-string-no-properties 1) my-php-symbol-list))

      my-php-symbol-list)))

(add-hook 'php-mode-hook (lambda ()
			   (defun ywb-php-lineup-arglist-intro (langelem)
			     (save-excursion
			       (goto-char (cdr langelem))
			       (vector (+ (current-column) c-basic-offset))))
			   (defun ywb-php-lineup-arglist-close (langelem)
			     (save-excursion
			       (goto-char (cdr langelem))
			       (vector (current-column))))
			   (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
			   (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))
;;powershell mode



;; ADDED 20220209
;; https://realpython.com/emacs-the-best-python-editor/

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    elpy                            ;; Emacs Lisp Python Environment
    flycheck                        ;; On the fly syntax checking
    blacken                         ;; Black formatting on save
    magit                           ;; Git integration
    material-theme                  ;; Theme
    esup
    )
  )
;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(load-theme 'material t)            ;; Load material theme
;;(global-linum-mode t)               ;; Enable line numbers globally
(setq column-number-mode t)         ;; Displays column numbers
(setq smerge-command-prefix "\C-cv") ;; git merge command
;; User-Defined init.el ends here

;;from: https://jamiecollinson.com/blog/my-emacs-config/
(use-package smartparens
    :config
    (add-hook 'prog-mode-hook 'smartparens-mode))

;;Highlight parens etc. for improved readability.
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;;Highlight strings which represent colours. I only want this in programming modes, and I don't want colour names to be highlighted (x-colors).

(use-package rainbow-mode
  :config
  (setq rainbow-x-colors nil)
  (add-hook 'prog-mode-hook 'rainbow-mode))

;;Expand parentheses for me.
(add-hook 'prog-mode-hook 'electric-pair-mode)

;;Navigation
;;One of the most important features of an advanced editor is quick text navigation. avy lets us jump to any character or line quickly.
(use-package avy)


;;I'm now using my own translation of Panda Theme (now on melpa!).

(use-package panda-theme
  :disabled
  :config
  (load-theme 'panda t))


;;I also like Solarized. --sets color scheme

(use-package solarized-theme
  :config
  :disabled
  (load-theme 'solarized-dark t))

;;Set a nice font.
(set-frame-font "Operator Mono 12" nil t)
;; (set-frame-font "Inconsolata 13" nil t)
;; (set-frame-font "SF Mono 12" nil t)
;;feebleline is a minimalist mode line replacement.

(use-package feebleline
  :config
  (feebleline-mode 't))
;;Add emoji support. This is useful when working with html.

(use-package emojify)
;;Improve look and feel of titlebar on Macos. Set ns-appearance to dark for white title text and nil for black title text.

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;;Git
;;Magit is an awesome interface to git. Summon it with `C-x g`.

(use-package magit
  :bind ("C-x g" . magit-status))
;;Display line changes in gutter based on git history. Enable it everywhere.

(use-package git-gutter
  :config
  (global-git-gutter-mode 't))


;;Sometimes it's useful to use the local eslint provided by a project's node_modules directory. We call this function from a flycheck hook to enable it automatically.

(defun jc/use-eslint-from-node-modules ()
  "Set local eslint if available."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

;;We often want to use local packages instead of global ones.

(use-package add-node-modules-path)




;;Syntax checking
;;Flycheck is a general syntax highlighting framework which other packages hook into. It's an improvment on the built in flymake.

;;Setup is pretty simple - we just enable globally and turn on a custom eslint function, and also add a custom checker for proselint.

(use-package flycheck
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook 'jc/use-eslint-from-node-modules)
  (add-to-list 'flycheck-checkers 'proselint)
  (setq-default flycheck-highlighting-mode 'lines)
  ;; Define fringe indicator / warning levels
  (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
    (vector #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00011100
            #b00111110
            #b00111110
            #b00111110
            #b00011100
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000))
  (flycheck-define-error-level 'error
    :severity 2
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-error)
  (flycheck-define-error-level 'warning
    :severity 1
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-warning)
  (flycheck-define-error-level 'info
    :severity 0
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap 'flycheck-fringe-bitmap-ball
    :fringe-face 'flycheck-fringe-info))
;;Proselint is a syntax checker for English language. This defines a custom checker which will run in texty modes.

;;Proselint is an external program, install it with pip install proselint for this to work.

(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
            (id (one-or-more (not (any " "))))
            (message (one-or-more not-newline)
                     (zero-or-more "\n" (any " ") (one-or-more not-newline)))
            line-end))
  :modes (text-mode markdown-mode gfm-mode org-mode))

;;Customize appearance.

(let*
    ((base-font-color     (face-foreground 'default nil 'default))
     (headline           `(:foreground ,base-font-color)))

  (custom-theme-set-faces 'user
                          `(org-level-8 ((t (,@headline))))
                          `(org-level-7 ((t (,@headline))))
                          `(org-level-6 ((t (,@headline))))
                          `(org-level-5 ((t (,@headline))))
                          `(org-level-4 ((t (,@headline))))
                          `(org-level-3 ((t (,@headline :height 1.3))))
                          `(org-level-2 ((t (,@headline :height 1.3))))
                          `(org-level-1 ((t (,@headline :height 1.3 ))))
                          `(org-document-title ((t (,@headline :height 1))))))




;; ====================================
;; Development Setup
;; ====================================

;; Enable elpy
;;CDE disabled... adds 9 seconds to emacs load time
;;(elpy-enable)

;;(setq elpy-rpc-backend "jedi")
;;(pyvenv-activate "~/.virtualenvs/default")

;; Set ipython as the default interpreter
;;(setq elpy-rpc-python-command "python3")




;; User-Defined init.el ends here


;; Enable Flycheck
;;(when (require 'flycheck nil t)
;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;(set-foreground-color "#E0DFDB")
;;(set-background-color "#102372")
(global-flycheck-mode)
(provide 'emacs)
