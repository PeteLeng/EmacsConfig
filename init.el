;; -*- lexical-binding: t; -*-

;; Configure eln file path to each individual config folder.
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; Configure the server path
(setq server-auth-dir "C:\\Users\\pete\\.emacs.d\\server\\")

;;; ===================================  
;;; Melpa Package Support
;;; ===================================

;; Enable basic packaging support
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

;; Initialize the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
;; Archived packages are in "/elpa/" folder
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages
(defvar myPackages	; myPackages contains a list of package names
  '(better-defaults     ; Set up some better Emacs defaults
    use-package		; Isolate package configuration
    ))

;; Scan the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;;; ===================================
;;; Basic Customization
;;; ===================================

(setq inhibit-startup-message t)					; Hide the startup message
(setq-default line-spacing 1)						; Set line space

;; Minor mode
(global-linum-mode 0) ; Enable line numbers globally
(global-display-line-numbers-mode)
(electric-pair-mode 1)

;; Encoding style
(set-language-environment 'utf-8)
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
 
;;; ===================================
;;; Key bindings
;;; ===================================

;; (w32-register-hot-key [M-tab])
(setq w32-lwindow-modifier 'super)
(w32-register-hot-key [s-])

;; Completion
(global-set-key (kbd "C-<tab>") 'completion-at-point)

;; Navigate paragraphs
(global-set-key (kbd "C-<") 'backward-paragraph)
(global-set-key (kbd "C->") 'forward-paragraph)

;; Navigate sentences
;; (global-set-key (kbd "M-p") 'backward-sentence)
;; (global-set-key (kbd "M-n") 'forward-sentence)

;; Navigate balanced expressions
;; (global-set-key (kbd "M-a") 'backward-sexp)
;; (global-set-key (kbd "M-e") 'forward-sexp)

;; Resize windows
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<up>") 'shrink-window)
(global-set-key (kbd "s-<down>") 'enlarge-window)

;; Comment line
(global-set-key (kbd "C-;") 'comment-line)

;; Evaluate expression
(global-set-key (kbd "C-=") 'eval-last-sexp)

;; Undo
(global-set-key (kbd "C-z") 'undo)

;; Suspend-frame
;; (global-set-key (kbd "C-<tab>") 'suspend-frame)

;;; ===================================
;;; Font
;;; ===================================

(set-face-attribute 'default nil
		    :family "DejaVu Sans Mono"
		    :height 180
		    )

;; org-code face inherits from fixed-pitch face
;; adjust fix-pitch face so that org inline code is conspicuous
(set-face-attribute 'fixed-pitch nil
		    :family "Consolas"
		    :height 180
		    ;; :foreground "cadet blue"
		    )

(defun custom-set-fontset()
  (set-fontset-font
   t
   'han
   (cond
    ((string-equal system-type "windows-nt")
     (cond
      ((member "Noto Sans Mono CJK SC" (font-family-list)) "Noto Sans Mono CJK SC")))
    ((string-equal system-type "gnu/linux")
     (cond
      ((member "Noto Sans Mono CJK SC" (font-family-list)) "Noto Sans Mono CJK SC")))
    ))

  (set-fontset-font
   t
   'symbol
   (cond
    ((string-equal system-type "windows-nt")
     (cond
      ;; ((member "Noto Sans Symbols" (font-family-list)) "Noto Sans Symbols")
      ;; ((member "Symbola" (font-family-list)) "Symbola")
      ((member "Segoe UI Symbol" (font-family-list)) "Segoe UI Symbol")))
    ((string-equal system-type "gnu/linux")
     (cond
      ((member "Symbola" (font-family-list)) "Symbola")))
    ))

  (set-fontset-font
   t
   (if (version< emacs-version "28.1")
       '(#x1f300 . #x1fad0)
     'emoji)
   (cond
    ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
    ))
  )

(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(with-selected-frame frame (custom-set-fontset))))
  (custom-set-fontset))

;;; ===================================
;;; Cleaner UI
;;; ===================================

(defun current-hour ()
  (let ((time (current-time-string)))
    (setq time-list (split-string (current-time-string)))
    (setq time-of-day (nth 3 time-list))
    (setq time-of-day-list (split-string time-of-day ":"))
    (string-to-number (nth 0 time-of-day-list))
    ))

(defun day-or-night (hour)
  (if (or (>= hour 18)
	  (<= hour 7))
      nil
    t)
  )

;; Load theme
(if (day-or-night (current-hour))
    (load-theme 'dichromacy t)
  (load-theme 'misterioso t)
    )

;; Disable tool bar, menu bar, and scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(set-scroll-bar-mode nil)

;; Doomemacs theme megapack
(use-package doom-themes
  :disabled t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  (if (day-or-night (current-hour))
      (load-theme 'doom-one-light t)
    (load-theme 'doom-vibrant t)
      )

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;; ===================================
;;; Vertico completion UI
;;; ===================================

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;;; ===================================
;;; Python development
;;; ===================================

(use-package projectile
  :ensure t
  :pin melpa
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)
	      ))

(setq python-shell-interpreter "python")

(use-package elpy
  :ensure t
  :pin melpa
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python")
  ;; (setq elpy-rpc-pythonpath "C:\\Users\\pete\\.emacs.d\\elpa\\elpy-20220322.41")
  )

;;; ===================================
;;; Org
;;; ===================================

(use-package org
  :init
  ;; (org-mode)
  :config
  (setq-default prettify-symbols-alist
		'(("#+BEGIN_SRC" . "❮")
		  ("#+END_SRC" . "❯")
		  ("#+begin_src" . "❮")
		  ("#+end_src" . "❯")
		  ;; ("#+begin_quote" . "❝")
		  ;; ("#+end_quote" . "❞")
		  ("#+begin_quote" . "“")
		  ("#+end_quote" . "”")
		  ("#+begin_verse" . "“")
		  ("#+end_verse" . "”")
		  ;; (">=" . "≥")
		  ;; ("=>" . "⇨")
		  ))
  
  (setq org-hide-emphasis-markers t
	org-fontify-done-headline t
	org-hide-leading-stars t
	org-pretty-entities t
	;; org-odd-levels-only t
	prettify-symbols-unprettify-at-point 'right-edge
	org-image-actual-width nil ; Allow for resizing pictures using captions
	)
  
  ;; LaTeX options
  (setq org-preview-latex-default-process 'dvisvgm
	org-format-latex-options (plist-put org-format-latex-options :scale 2.0)
	)
  
  (add-hook 'org-mode-hook #'(lambda ()
                               (visual-line-mode)
                               (org-indent-mode)
			       (prettify-symbols-mode)
			       ))	

  :bind (("C-c l" . org-store-link)
	 ("C-c a" . org-agenda)
	 ("C-c c" . org-capture)
	 ("M-<" . org-backward-element)
	 ("M->" . org-forward-element)
	 ))

(use-package org-bullets
  ;; :disabled t
  :ensure t
  :custom
  ;; (org-bullets-bullet-list '("✙" "♱" "♰" "✞" "✟" "✝" "†" "✠" "✚" "✜" "✛" "✢" "✣" "✤" "✥"))
  (org-bullets-bullet-list '("♱" "☦" "†" "✝" "✞" "✟" "✠" "✜" "✛" "✙" "✚"))
  (org-ellipsis "⤵")
  ;; :hook (org-mode . org-bullets-mode)
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;; (setq org-bullets-bullet-list '("\u200b"))
  )

;; Set background color for org code blocks
(defun custom-set-org-color ()
  (require 'color)
  (setq code-block-bg-color (color-darken-name (face-attribute 'default :background) 8))
  ;; (set-face-attribute 'org-block nil
  ;;                     :background (color-darken-name (face-attribute 'default :background) 5)
  ;;                     )

  (custom-set-faces
   `(org-block-begin-line
     ((t (:background ,code-block-bg-color :extend t))))
   `(org-block
     ((t (:background ,code-block-bg-color :extend t))))
   `(org-block-end-line
     ((t (:background ,code-block-bg-color :extend t))))
   )
  )

(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(with-selected-frame frame (custom-set-org-color))
		))
  (custom-set-org-color))

;;; ===================================
;;; Org-roam
;;; ===================================

;; Org-Roam basic configuration
(setq org-directory (concat (getenv "HOME") "\\Vorg\\"))

(use-package org-roam
  :ensure t
  :after org
  :init
  (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
  :custom (org-roam-directory (file-truename org-directory))
  :config
  ;; (org-roam-setup) ; This function is obsolete.
  (org-roam-db-autosync-enable)
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n r" . org-roam-node-random)
   ;; (:map org-mode-map
   ;; 	 (("C-c n i" . org-roam-node-insert)
   ;; 	  ("C-c n o" . org-id-get-create)
   ;; 	  ("C-c n t" . org-roam-tag-add)
   ;; 	  ("C-c n a" . org-roam-alias-add)
   ;; 	  ("C-c n l" . org-roam-buffer-toggle))))
   :map org-mode-map
   ("C-c n i" . org-roam-node-insert)
   ("C-c n p" . org-id-get-create)
   ("C-c n t" . org-roam-tag-add)
   ("C-c n a" . org-roam-alias-add)
   ("C-c n b" . org-roam-buffer-toggle))
  )

;;; ===================================
;;; Custom functions
;;; ===================================

;; (load "~/.emacs.d/lisp/greetings.el")
(message "Successfully loaded Emacs Epic!")

;;; This is the end of user configuration
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-roam org-bullets elpy projectile orderless vertico use-package better-defaults)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
