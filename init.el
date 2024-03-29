(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lsp-ivy lsp-treemacs dap-mode jsx-mode typescript-mode rjsx-mode dashboard company company-lsp lsp-ui yasnippet yasnippet-snippets flymake-go go-mode lsp-java 0blayout lsp-mode ag magit-annex evil-magit flx-ido magit zenburn-theme powerline-evil markdown-mode+ use-package auto-yasnippet counsel-projectile helpful counsel centaur-tabs gnus-recent smex ivy ido-completing-read+))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Essential plugins(ivy, smex, counsel, centaur-tabs...)
(ido-ubiquitous-mode 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
(setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(smex-initialize)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-M-h" . centaur-tabs-backward)
  ("C-M-l" . centaur-tabs-forward))

(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

(counsel-projectile-mode +1)
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(global-set-key (kbd "H-w") #'aya-create)
(global-set-key (kbd "H-y") #'aya-expand)
(global-set-key (kbd "C-o") #'aya-open-line)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(add-hook 'after-init-hook 'global-company-mode)

(global-flycheck-mode)
(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "GOROOT")
(exec-path-from-shell-copy-env "GOPATH")


(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; Appearence setup
(load-theme 'zenburn t)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(set-face-attribute 'default nil :height 150)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))


;; Development settings

(require 'evil-magit)

;; emmet
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(setq emmet-move-cursor-between-quotes t)
(setq emmet-expand-jsx-className? t)
(setq emmet-self-closing-tag-style " /")

(add-to-list 'auto-mode-alist '(".+\/[A-Z][a-z]+.js?" . rjsx-mode))

;; lsp settings
(use-package lsp-mode
  :hook (js-mode . lsp-deferred)
  :hook (js2-mode . lsp-deferred)
  :hook (typescript-mode . lsp-deferred)
  :hook (rjsx-mode . lsp-deferred)
  :hook (go-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package dap-mode)

(put 'dired-find-alternate-file 'disabled nil)

(evil-define-key 'normal js-mode-map "gd" 'lsp-find-definition)
(evil-define-key 'normal go-mode-map "gd" 'lsp-find-definition)

(require 'yasnippet)
