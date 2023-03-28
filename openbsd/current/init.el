;;
;; Setup package managers.
;;
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;;
;; Prettify with Nord theme, mood-line and other eye-candy.
;; See https://www.nordtheme.com/docs/ports/emacs/installation and
;; https://gitlab.com/jessieh/mood-line.
;;
(use-package nord-theme
  :ensure t
  :after (package-install 'nord-theme))
;; (use-package mood-line
;;   :ensure t
;;   :config (mood-line-mode))
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(column-number-mode 1)
(load-theme 'nord t)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode t)
(setq auto-save-default nil)
(setq backup-directory-alist '(("" . "~/.emacs.d/backup-files")))


;; Fix indentation for C-code; ensure we're using the "bsd" style, which is
;; similar to the OpenBSD style(9).
(setq c-default-style "bsd")
(setq sh-basic-offset 8)


;;
;; Setup evil mode along with evil-collection to expand evil bindings to other
;; areas of emacs, namely the dashboard, directory and buffer views.
;; Disable C-i to restore TAB for org-mode; see
;; https://jeffkreeftmeijer.com/emacs-evil-org-tab/.
;;
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode))
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (setq evil-collection-mode-list
	'(calendar dashboard dired ibuffer magit mu4e))
  (evil-collection-init))

;;
;; The nerd-commenter package makes commenting code blocks easy.
;; The general package allows us to easily set keybindings, especially
;; with SPC.
;;
(use-package evil-nerd-commenter
  :ensure t
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
(use-package general
  :ensure t
  :config (general-evil-setup t))

;;
;; Evil-vimish-fold allows vim-like code-folding in evil mode
;; https://github.com/alexmurray/evil-vimish-fold
;;
(use-package vimish-fold
  :ensure t
  :after evil)
(use-package evil-vimish-fold
  :ensure t
  :after vimish-fold
  :init
  (setq evil-vimish-fold-mode-lighter " Z")
  (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
  :config
  (global-evil-vimish-fold-mode))


;;
;; Simplify git usage with magit.
;; The diff-hl markers are shown in the margin so that they don't conflict with
;; flycheck marks on the fringe. 
;;
(use-package magit
  :ensure t)
(use-package diff-hl
  :ensure t
  :after magit
  :config
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  (diff-hl-flydiff-mode))
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
(setq git-commit-summary-max-length 50)
(setq git-commit-fill-column 72)
  
  
;;
;; Autocompletion with vertico, savehist and marginalia and which-key.
;;
(use-package vertico
  :ensure t
  :bind (:map vertico-map
	      ("C-x" . vertico-exit)
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous))
  :custom (vertico cycle t)
  :init (vertico-mode))
(use-package savehist
  :ensure t
  :init
  (savehist-mode))
(use-package marginalia
  :after vertico
  :ensure t
  :custom (marginalia-annotators
	   '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (marginalia-mode))
(use-package which-key
  :ensure t
  :init
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 5
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 100
	which-key-allow-imprecise-window-fit t
	which-key-separator "   "))
(which-key-mode)
(nvmap :keymaps 'override :prefix "SPC"
  "SPC" '(execute-extended-command :which-key "Better M-x")
  "p" '(package-list-packages :which-key "Update packages")
  "d" '(dired :which-key "Directory editor")
  "f" '(find-file :which-key "Find files")
  "e" '(eval-buffer :which-key "Evaluate buffer")
  "g s" '(magit-status :which-key "Git status")
  "g r" '(magit-rebase :which-key "Git rebase")
  "g l" '(magit-log :which-key "Git log")
  "g p" '(magit-patch :which-key "Git patch"))


;;
;; Use projectile is used for project management.
;;
(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

;;
;; Show the dashboard on startup.
;; Ensure that emacsclient shows the dashboard instead of the scratch buffer.
;;
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-banner-logo-title "Welcome to Emacs!")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-items
	'((recents . 5)
	  (agenda . 5)
	  (bookmarks . 5)
	  (projects . 5)
	  (registers . 5)))
  :config
  (dashboard-setup-startup-hook))
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))


;;
;; Navigation with Treemacs and Winum.
;;
(use-package treemacs
  :ensure t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-hide-gitignored-files-mode t)
  (treemacs-git-mode 'simple))
(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)
(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)
(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)
(use-package lsp-treemacs
  :after (treemacs lsp-mode)
  :ensure t)
(use-package winum
  :after treemacs
  :ensure t
  :config
  (global-set-key (kbd "M-0") 'treemacs-select-window)
  (global-set-key (kbd "M-1") 'winum-select-window-1)
  (global-set-key (kbd "M-2") 'winum-select-window-2)
  (global-set-key (kbd "M-3") 'winum-select-window-3)
  (global-set-key (kbd "M-4") 'winum-select-window-4)
  (global-set-key (kbd "M-5") 'winum-select-window-5)
  (global-set-key (kbd "M-6") 'winum-select-window-6)
  (global-set-key (kbd "M-7") 'winum-select-window-7)
  (global-set-key (kbd "M-8") 'winum-select-window-8)
  (global-set-key (kbd "M-9") 'winum-select-window-9))


;;
;; LSP mode integration.
;; Requires npm and luarocks to be available.
;;
(use-package yasnippet-snippets
  :ensure t)
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config (yas-reload-all))
(use-package lsp-mode
  :commands lsp
  :ensure t
  :hook
  ((python-mode . (lambda ()
		    (company-mode)
		    (lsp-deferred)))
   (latex-mode . (lambda ()
		   (company-mode)
		   (lsp-deferred)))
   (c-mode . (lambda ()
	       (company-mode)
	       (lsp-deferred)))
   (html-mode . (lambda ()
	       (company-mode)
	       (lsp-deferred)))
   (css-mode . (lambda ()
	       (company-mode)
	       (lsp-deferred)))
   (sh-mode . (lambda ()
		(company-mode)
		(lsp-deferred))))
  :config
  (lsp-enable-which-key-integration t))
(use-package lsp-ui
  :after lsp-mode
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-position 'bottom)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-ui-sideline-show-diagnostics t))
(use-package company
  :ensure t
  :config
  (company-tng-mode)
  (setq company-idle-delay 0.1
	company-minimum-prefix-length 1
	company-selection-wrap-around t
	company-tooltip-align-annotations t))
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode))
(use-package lsp-pyright
  :ensure t
  :hook
  (python-mode . (lambda ()
		   (require 'lsp-pyright)
		   (lsp-deferred))))


;;
;; Use mu4e as MUA
;;
(use-package mu4e
  :ensure nil
  :config
  (setq mu4e-use-fancy-chars nil
	mu4e-headers-thread-child-prefix '("+->" . "+-> ")
	mu4e-headers-thread-last-child-prefix '("`->" . "`-> ")
	mu4e-headers-thread-connection-prefix '("|" . "| ")
	mu4e-headers-thread-orphan-prefix '("!->" . "!-> ")
	mu4e-headers-thread-single-orphan-prefix '("-->" . "--> ")
	mu4e-headers-unread-mark '("u" . "*")
	mu4e-headers-flagged-mark '("F" . "!")
	mu4e-headers-attach-mark '("a" . "%")
	mu4e-headers-seen-mark '("S" . " ")
	mu4e-headers-replied-mark '("R" . " ")
	mu4e-headers-passed-mark '("P" . " ")
	mu4e-headers-signed-mark '("s" . " ")
	mu4e-headers-trashed-mark '("T" . "x"))
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-maildir "~/var/mail")
  (setq mu4e-get-mail-command "fdm fetch")
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq message-signature-file "~/.emacs.d/taranjali.sig")
  (setq mu4e-compose-complete-only-personal nil)
  (setq mu4e-contexts
	(list
	 (make-mu4e-context
	  :name "Taranjali"
	  :match-func
	  (lambda (msg)
	    (when msg
	      (string-prefix-p "/taranjali"
			       (mu4e-message-field msg :maildir))))
	  :vars
	  '((user-mail-address . "abhishek@taranjali.org")
	    (user-full-name . "Abhishek Chakravarti")
	    (smtpmail-smtp-user . "abhishek@taranjali.org")
	    (smtpmail-smtp-server . "us2.smtp.mailhostbox.com")
	    (smtpmail-smtp-service . 587)
	    (smtpmail-smtp-stream-type . starttls)
	    (mu4e-drafts-folder . "/taranjali/DRAFTS")
	    (mu4e-sent-folder . "/taranjali/SENT")
	    (mu4e-trash-folder . "/taranjali/TRASH"))))))
(use-package message-view-patch
  :ensure t)
(add-hook 'gnus-part-display-hook 'message-view-patch-highlight)


;;
;; Configure org-mode
;;
(use-package org
  :ensure nil
  :init
  (setq org-directory "~/var/org"
	org-default-notes-file "~/var/org/gtd/in.org"
	org-agenda-files (directory-files-recursively "~/var/org" "org$")
	org-refile-targets '((org-agenda-files :maxlevel . 1))
	org-log-done 'time))
(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(use-package org-journal
  :ensure t
  :config
  (setq org-journal-dir "~/var/org/journal/"
	org-journal-date-format "%A, %d %B %Y"))
(use-package org-pomodoro
  :ensure t)
(defun org-journal-find-location ()
  (org-journal-new-entry t)
  (unless (eq org-journal-file-type 'daily)
    (org-narrow-to-subtree))
  (goto-char (point-max)))
(setq org-capture-templates
      '(("t" "Task" entry
	 (file+headline org-default-notes-file "Tasks")
	 "* TODO %?\nCAPTURED: %U"
	 :empty-lines 1)
        ("n" "Note" entry
	 (file+headline org-default-notes-file "Notes")
	 "* %?\nCAPTURED: %U"
	 :empty-lines 1)
        ("l" "Link" entry
	 (file+headline org-default-notes-file "Links")
	 "* %?\nCAPTURED: %U"
	 :empty-lines 1)
        ("m" "Mail" entry
	 (file+headline org-default-notes-file "Mails")
	 "* %a\n%:message-id %:maildir\n%:fromname %:fromaddress %:date-timestamp\nCAPTURED: %U\n%?"
	 :empty-lines 1)
        ("j" "Journal entry" plain
	 (function org-journal-find-location)
	 "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
	 :jump-to-captured t
	 :immediate-finish t)))
(advice-add 'org-refile :after
	    (lambda (&rest _)
	      (org-save-all-org-buffers)))
(nvmap :keymaps 'override :prefix "SPC"
  "o a" '(org-agenda :which-key "Open agenda")
  "o c" '(org-capture :which-key "Capture templates")
  "o p" '(org-pomodoro :which-key "Start/stop pomodoro"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(ispell-dictionary nil)
 '(package-selected-packages '(lsp-treemacs nordless-theme use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
