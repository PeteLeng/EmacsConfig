;;; ===================================
;;; MELPA Package Support
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

    use-package		; Isolate package configuration
    ;; elpy		; Python extension
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
(set-face-attribute 'default nil :family "Consolas" :height 180)	; Set global buffer font

;; Minor mode
(global-linum-mode 0)							; Enable line numbers globally
;; (set-face-attribute 'linum nil :height 100)				; Fix line numers height
(global-display-line-numbers-mode)
(electric-pair-mode 1)

;; Load theme
(load-theme 'zenburn t)

;;; ===================================
;;; Development
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
              ("C-c p" . projectile-command-map)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(projectile elpygen zenburn-theme material-theme better-defaults)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
