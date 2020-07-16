;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Chris Montgomery"
      user-mail-address "chris@montchr.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-pro)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; org-capture settings
(setq org-capture-todo-file "inbox.org" )

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Load and configure auto-dark-emacs
(use-package! auto-dark-emacs
  :custom
  (auto-dark-emacs/dark-theme 'doom-monokai-pro)
  (auto-dark-emacs/light-theme 'doom-one-light))


;; Simple settings.
;; https://tecosaur.github.io/emacs-config/config.html#simple-settings
(setq undo-limit 80000000
  evil-want-fine-undo t
  truncate-string-ellipsis "…")

;; Allow the default macOS ~alt~ behavior for special keyboard chars.
(setq ns-alternate-modifier 'none)
(setq ns-command-modifier 'meta)
(setq ns-right-command-modifier 'super)

;; Autosave
(setq auto-save-default t)
(add-hook 'auto-save-hook 'org-save-all-org-buffers)
;; Silence autosave message -- available in Emacs 27 (not yet!)
;; (setq auto-save-no-message t)

;; Add prompt to select buffer upon opening new window
;; https://tecosaur.github.io/emacs-config/config.html#windows
(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; Show previews in ivy.
(setq +ivy-buffer-preview t)

;; List magit branches by date
(setq magit-list-refs-sortby "-creatordate")

;; Attempts to prevent vterm from loading emacs from within itself,
;; but DOESN'T WORK!
(use-package! with-editor
  :ensure t
  :general
  ([remap async-shell-command] 'with-editor-async-shell-command)
  ([remap shell-command] 'with-editor-shell-command)
  :hook
  (shell-mode . with-editor-export-editor)
  (term-exec  . with-editor-export-editor)
  (eshell-mode . with-editor-export-editor)
  (vterm-mode . with-editor-export-editor))

(after! org
  (defun cdom/org-archive-done-tasks ()
    "Archive all completed tasks."
    (interactive)
    (org-map-entries 'org-archive-subtree "/DONE" 'file))
  (require 'find-lisp)
  (setq cdom/org-agenda-directory "~/Dropbox/org/gtd")
  (setq org-agenda-files
        (find-lisp-find-files cdom/org-agenda-directory "\.org$")))

;; Point deft to the `org' directory.
(setq deft-directory "~/org")

(use-package! org-roam
  :init
  (setq org-roam-directory "~/org")
  :config
  (setq org-roam-dailies-capture-templates
    '(("d" "daily" plain #'org-roam-capture--get-point
        ""
        :immediate-finish t
        :file-name "%<%Y-%m-%d>"
        :head "#+title: %<%A, %d %B %Y>"))
  ))

;; Configure org-journal for compatability with org-roam-dailies
(use-package! org-journal
  :init
  (setq org-journal-date-prefix "#+title: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-dir cdom/org-agenda-directory
        org-journal-date-format "%A, %d %B %Y"
        org-journal-enable-agenda-integration t))


;; [BROKEN] Archive items to an archive sibling instead of a separate file
(setq org-archive-default-command 'org-archive-to-archive-sibling)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-dark-emacs/dark-theme (quote doom-monokai-pro))
 '(auto-dark-emacs/light-theme (quote doom-one-light))
 '(package-selected-packages (quote (with-editor))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
