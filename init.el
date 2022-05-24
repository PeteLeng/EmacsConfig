;;; ===================================
;;; Melpa Package Support
;;; ===================================

;; Enable basic packaging support
(require 'package)

;; Add the Melpa archive to the list of available repositories
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/"))

(defun prepend-to-list (list new-elements)
  (while new-elements
    (setq temp (car new-elements))
    (add-to-list list temp)
    (setq new-elements (cdr new-elements))
    ))

(prepend-to-list 'package-archives
	(list
	 '("melpa" . "http://melpa.org/packages/")
	 '("melpa-stable" . "https://stable.melpa.org/packages/")))

;; Initialize the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
;; Archived packages are in "/elpa/" folder
(when (not package-archive-contents)
  (package-refresh-contents))
(unless package-archive-contents
  (package-refresh-contents))

;; Refresh packages on start up
;; (package-refresh-contents)

;; Install packages
(defvar myPackages	; myPackages contains a list of package names
  '(better-defaults     ; Set up some better Emacs defaults
    material-theme      ; Theme
    zenburn-theme	; Theme
    monokai-theme
    spacemacs-theme

    use-package		; Isolate package configuration
    ;; elpy		; Python extension
    ;; vertico		; Minibuffer completion UI
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
;; (set-face-attribute 'default nil :family "Source Code Pro" :height 180)	; Set global buffer font

;; Minor mode
(global-linum-mode 0)							; Enable line numbers globally
;; (set-face-attribute 'linum nil :height 100)				; Fix line numers height
(global-display-line-numbers-mode)
(electric-pair-mode 1)

;;; ===================================
;;; Font
;;; ===================================

(custom-theme-set-faces
 'user
 ;; '(variable-pitch ((t (:family "Arial" :height 180))))
 `(fixed-pitch ((t (:family "Consolas" :height 180)))))

(set-face-font 'default "Source Code Pro-18") ; set fixed-width font
;; (set-face-font 'variable-pitch "TeX Gyre Pagella-18") ; set variable-width font

;; (use-package mixed-pitch ; set org mode to use variable width font smartly
;;   :ensure t
;;   :hook (text-mode . mixed-pitch-mode))

;;; ===================================
;;; Cleaner UI
;;; ===================================

;; Load theme
(load-theme 'spacemacs-dark t)

;; Disable tool bar, menu bar, and scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(set-scroll-bar-mode nil)

;;; ===================================
;;; Key bindings
;;; ===================================

(w32-register-hot-key [M-tab])
(setq w32-lwindow-modifier 'super)
(w32-register-hot-key [s-])

;; Skip paragraphs
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

;; Resize windows
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<up>") 'shrink-window)
(global-set-key (kbd "s-<down>") 'enlarge-window)

;; Comment line
(global-set-key (kbd "C-;") 'comment-line)

;; Evaluate expression
(global-set-key (kbd "C-.") 'eval-last-sexp)

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

;;; ===================================
;;; Python development
;;; ===================================

;; (elpy-enable)
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package projectile
  :ensure t
  :pin melpa-stable
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)
	      ))

;; (setq projectile-completion-system 'ido)

;;; ===================================
;;; Org
;;; ===================================

;; Markup settings
(setq org-hide-emphasis-markers t)

;; Hide asterisks in headers
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;; (setq org-bullets-bullet-list '("\u200b"))
  )

;; Increase header font size and weight
(custom-theme-set-faces
 'user
 `(org-level-1 ((t (:height 1.25 :weight bold))))
 `(org-level-2 ((t (:weight bold))))
 `(org-level-3 ((t (:weight bold)))))

;; Key mapping
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Minor mode for Org
;; (setq org-startup-indented t)
(add-hook 'org-mode-hook #'(lambda ()
                             (visual-line-mode)		; Line continuation
                             (org-indent-mode)))	; Cleaner outline view

;; (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
;; (setq org-indent-mode-turns-off-org-adapt-indentation nil)

;;; ===================================
;;; Org-roam
;;; ===================================

;; Org-Roam basic configuration
(setq org-directory (concat (getenv "HOMEPATH") "\\Vorg\\"))

(use-package org-roam
  :ensure t
  :after org
  :init (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
  :custom
  (org-roam-directory (file-truename org-directory))
  :config
  (org-roam-setup)
  :bind (("C-c n f" . org-roam-node-find)
	 ("C-c n r" . org-roam-node-random)
	 (:map org-mode-map
	       (("C-c n i" . org-roam-node-insert)
		("C-c n o" . org-id-get-create)
		("C-c n t" . org-roam-tag-add)
		("C-c n a" . org-roam-alias-add)
		("C-c n l" . org-roam-buffer-toggle)))))
		
;;; ===================================
;;; Latex
;;; ===================================

(with-eval-after-load 'org
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  )
;; (set-default 'preview-scale-function 1.2)

;; This is the end of user configuration
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Consolas" :height 180))))
 '(org-level-1 ((t (:height 1.25 :weight bold))))
 '(org-level-2 ((t (:weight bold))))
 '(org-level-3 ((t (:weight bold)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-roam projectile elpygen zenburn-theme material-theme better-defaults)))

