;;; ===================================
;;; MELPA Package Support
;;; ===================================

;; Enable basic packaging support
(require 'package)

;; Add the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initialize the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
;; Archived packages are in "/elpa/" folder
;; (when (not package-archive-contents)
;;   (package-refresh-contents))
;; (unless package-archive-contents
;;   (package-refresh-contents))

;; Refresh packages on start up
(package-refresh-contents)

;; Install packages
(defvar myPackages	; myPackages contains a list of package names
  '(better-defaults     ; Set up some better Emacs defaults
    material-theme      ; Theme
    zenburn-theme	; Theme    
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(zenburn-theme material-theme better-defaults)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
