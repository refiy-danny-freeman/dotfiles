;;; abn-module-evil.el --- Basic evil-mode configuration.

;;; Code:
(eval-when-compile
  (require 'cl))

;; Evil Plugin Packages
(use-package abn-funcs-evil
  :defer t
  :ensure nil ; local package
  :commands
  (abn/evil-next-visual-line-5
   abn/evil-previous-visual-line-5
   abn/shift-right-visual
   abn/shift-left-visual)
  :init
  (with-eval-after-load 'evil
    (evil-global-set-key 'motion "J" 'abn/evil-next-visual-line-5)
    (evil-global-set-key 'motion "K" 'abn/evil-previous-visual-line-5)
    (evil-global-set-key 'normal "J" 'abn/evil-next-visual-line-5)
    (evil-global-set-key 'normal "K" 'abn/evil-previous-visual-line-5)
    (evil-global-set-key 'visual "J" 'abn/evil-next-visual-line-5)
    (evil-global-set-key 'visual "K" 'abn/evil-previous-visual-line-5)))

(use-package evil
  :demand ;; TODO: can we lazy load evil?
  :config
  (evil-mode 1)
  (require 'abn-local-evil-config))

;; Shows number of matches in mode-line when searching with evil.
(use-package evil-anzu
  ;; Lazy loading doesn't make a much sense because evil-anzu
  ;; only defines four defadvices for `evil-search' `evil-ex'
  ;; `evil-flash' `evil-ex'
  :demand)

;; Motions and text objects for delimited arguments, e.g. the params
;; in `def func(foo, bar, baz)'.
(use-package evil-args
  :defer t
  :bind
  (:map evil-inner-text-objects-map
   ("a" . evil-inner-arg)
   :map evil-outer-text-objects-map
   ("a" . evil-outer-arg)))

;; Enables two char keypress to exit most modes.
(use-package evil-escape
  :defer t
  :diminish evil-escape-mode
  :commands (evil-escape-pre-command-hook)
  :init
  (add-hook 'pre-command-hook 'evil-escape-pre-command-hook)
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-unordered-key-sequence t))

;; Easy text exchange operator
(use-package evil-exchange
  :defer t
  :init
  (with-eval-after-load 'evil
    (evil-define-key 'motion
      "gx" 'evil-exchange
      "gX" 'evil-exchange-cancel)))

;; Edit multiple regions with the same content simultaneously.
(use-package evil-iedit-state
  :defer t
  :commands (evil-iedit-state evil-iedit-state/iedit-mode)
  :bind
  (:map abn-leader-map
   ("se" . evil-iedit-state/iedit-mode))
  :init
  (setq iedit-current-symbol-default t
        iedit-only-at-symbol-boundaries t
        iedit-toggle-key-default nil))

(use-package evil-nerd-commenter
  :defer t
  :bind
  (:map abn-leader-map
   (";"  . evilnc-comment-operator)))

;; Enables vim style numeric incrementing and decrementing.
(use-package evil-numbers
  :defer t
  :bind
  (:map abn-leader-map
   ("n+" . evil-numbers/inc-at-pt)
   ("n=" . evil-numbers/inc-at-pt)
   ("n-" . evil-numbers/dec-at-pt)))

;; Replace text with the contents of a register.
(use-package evil-replace-with-register
  :defer t
  :bind
  (:map evil-motion-state-map
   ("gr" . evil-replace-with-register)))

;; Emulates the vim surround plugin.
(use-package evil-surround
  :defer t
  :bind
  (:map evil-operator-state-map
   ("s" . evil-surround-edit)
   ("S" . evil-Surround-edit)
   :map evil-visual-state-map
   ("S" . evil-surround-region)
   ("gS" . evil-Surround-region))
  
  :config
  (setq-default evil-surround-pairs-alist
                ;; Add \ to mean escaped string.
                (cons '(?\\ . ("\\\"" . "\\\""))
                      evil-surround-pairs-alist)))

(use-package evil-unimpaired
  :defer t
  :ensure nil ; Local package
  :bind
  (:map evil-normal-state-map
   ;; From tpope's unimpaired.
   ("[ SPC" . evil-unimpaired/insert-space-above)
   ("] SPC" . evil-unimpaired/insert-space-below)
   ("[ b" . previous-buffer)
   ("] b" . next-buffer)
   ("[ f" . evil-unimpaired/previous-file)
   ("] f" . evil-unimpaired/next-file)
   ("] l" . abn/next-error)
   ("[ l" . abn/previous-error)
   ("] q" . abn/next-error)
   ("[ q" . abn/previous-error)
   ("[ t" . evil-unimpaired/previous-frame)
   ("] t" . evil-unimpaired/next-frame)
   ("[ w" . previous-multiframe-window)
   ("] w" . next-multiframe-window)
   ;; Selects pasted text.
   ;; "g p" (kbd "` [ v ` ]")
   ;; Pastes above or below with newline.
   ("[ p" . evil-unimpaired/paste-above)
   ("] p" . evil-unimpaired/paste-below)))

;; Starts a * or # search from the visual selection.
(use-package evil-visualstar
  :defer t
  :bind
  (:map evil-visual-state-map
   ("*" . evil-visualstar/begin-search-forward)
   ("#" . evil-visualstar/begin-search-backward)))

(use-package undo-tree
  :defer t
  :diminish undo-tree-mode)

;; Evil keybindings for magit.
(use-package magit
  :defer t
  :config
  (evil-add-hjkl-bindings magit-log-mode-map 'emacs)
  (evil-add-hjkl-bindings magit-commit-mode-map 'emacs)
  (evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
    "K" 'magit-discard
    "L" 'magit-log-popup)
  (evil-add-hjkl-bindings magit-status-mode-map 'emacs
    "K" 'magit-discard
    "l" 'magit-log-popup
    "h" 'magit-diff-toggle-refine-hunk))

(use-package org
  :defer t
  :ensure nil ;; We only want to add config options, not require org.
  :config
  (evil-declare-key 'normal org-mode-map
    "gk" 'outline-up-heading
    ;; This is too burned in as join-line to be useful.
    ;; "gj" 'outline-next-visible-heading
    "H" 'org-beginning-of-line
    "L" 'org-end-of-line
    "t" 'org-todo
    ",c" 'org-cycle
    "TAB" 'org-cycle
    ",e" 'org-export-dispatch
    ",n" 'outline-next-visible-heading
    ",p" 'outline-previous-visible-heading
    ",t" 'org-set-tags-command
    ",u" 'outline-up-heading
    "$" 'org-end-of-line
    "^" 'org-beginning-of-line
    "-" 'org-ctrl-c-minus ; change bullet style
    "<" 'org-metaleft
    ">" 'org-metaright))

(provide 'abn-module-evil)
;;; abn-module-evil.el ends here
