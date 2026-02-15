(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons catppuccin-theme consult-better-jumper corfu dap-mode
		   dashboard doom-modeline evil-surround
		   exec-path-from-shell magit multi-vterm
		   splash-screen tempel treesit-auto typst-ts-mode
		   vertico vterm))
 '(package-vc-selected-packages '((flash :url "https://github.com/Prgebish/flash"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Temporarily increase GC limit to 100MB for faster startup
(setq gc-cons-threshold (* 100 1024 1024))

;; Restore it to a reasonable level after startup is done
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("nongnu-elpa" . "https://elpa.nongnu.org/nongnu/packages") t)
(package-initialize)
(unless package-archive-contents
   (package-refresh-contents)
)


(eval-when-compile
	(require 'use-package)
)

;; Download Evil
;; (unless (package-installed-p 'evil)
;;  (package-install 'evil))

;; Enable Evil
;;(require 'evil)

(use-package evil
  :ensure t
  :demand t
  :config
  (evil-define-key 'normal 'global (kbd "g d") #'xref-find-definitions)
  (evil-define-key 'normal 'global (kbd "g r") #'xref-find-references)
  (evil-define-key 'normal 'global (kbd "K") #'eldoc)
  (evil-define-key 'normal 'global (kbd "SPC f") #'project-find-file)
  (evil-define-key 'normal 'global (kbd "SPC p") #'project-switch-project)
  (evil-define-key 'normal 'global (kbd "SPC g") #'magit-status)
  (evil-mode 1)
)

(setq evil-normal-state-cursor '(box "#89b4fa")   ;; Blue
      evil-insert-state-cursor '(bar "#a6e3a1")   ;; Green
      evil-visual-state-cursor '(box "#f5c2e7"))  ;; Pink

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1)
)


(use-package consult
  :ensure t
  :demand t
)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
)

(use-package flash
  :load-path "~/.emacs.d/self_downloaded/flash"
  :demand t
  :commands (flash-jump flash-jump-continue flash-treeseitter)
  :bind ("s-j" . flash-jump)
  :init
  (with-eval-after-load 'evil
    (require 'flash-evil)
    (flash-evil-setup t))  
  :config
  (require 'flash-isearch)
  (flash-isearch-mode 1)
)

(setq flash-char-jump-labels t)

(use-package eglot
  :ensure t
  :demand t
  :hook ((rust-ts-mode . eglot-ensure)
	 (c-mode . eglot-ensure)
	 (typst-ts-mode . eglot-ensure)
	 )
  :config
  (add-hook 'before-save-hook #'eglot-format-buffer nil t)
)

(use-package magit
  :ensure t
  :bind("C-x g" . magit-status)
)

(use-package corfu
  :ensure t
  :demand t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-mode t)
  (corfu-popupinfo-delay 0.3)
  :config
  (keymap-unset corfu-map "ESC")
)

(use-package tempel
  :ensure t
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  (add-hook 'conf-mode-hook #'tempel-setup-capf)
  (add-hook 'prog-mode-hook #'tempel-setup-capf))

(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin t)
)

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 3))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

(setq-default display-line-numbers-width 3)

(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-13"))
(setq-default line-spacing 0.1)

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '(
			  (recents . 5)
			  (projects . 5)
  ))
  (dashboard-setup-startup-hook))

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-side-window-location 'bottom)
  (which-key-max-description-length 25)
)

(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 10000))

(use-package multi-vterm
  :ensure t
  :config
  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global (kbd "SPC t") #'multi-vterm-project)
    (evil-define-key 'normal 'global (kbd "C-~") #'multi-vterm-toggle))
)
  

(add-hook 'vterm-mode-hook
          (lambda ()
            (setq-local evil-insert-state-cursor 'bar)
            (evil-insert-state))) ;; Start in insert mode

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode.git")
  :ensure t
  :custom
  (typst-ts-mode-watch-options "--open")
  :config
  (keymap-set typst-ts-mode-map "C-c C-C" #'typst-ts-tmenu)
)

(setq major-mode-remap-alist '((rust-mode . rust-ts-mode)))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((typst-ts-mode) . ("tinymist" "lsp"))))

(use-package dap-mode
  :ensure t
  :defer t
  :commands (dap-breakpoint-toggle dap-debug)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (dap-ui-controls-mode 1)
  (dap-auto-configure-mode 1)
  (require 'dap-gdb)
  (require 'dap-gdb-lldb)
  (require 'dap-lldb)
  (with-eval-after-load 'evil 
    (evil-define-key 'normal 'global (kbd "SPC db") #'dap-breakpoint-toggle)
    (evil-define-key 'normal 'global (kbd "SPC dd") #'dap-debug)
  )
)

(use-package treemacs
  :ensure t
  :defer t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(setq dap-gdb-debug-program '("rust-gdb" "-i" "dap"))
