;;; packages.el --- semantic Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar semantic-packages
  '(
    ;; package semantic go here
    semantic
    srefactor
    stickyfunc-enhance
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(unless (version< emacs-version "24.4")
  (add-to-list 'semantic-packages 'srefactor))

(defvar semantic-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function semantic/init-<package-semantic>
;;
;; (defun semantic/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
(defun semantic/enable-semantic-mode (mode)
  (let ((hook (intern (concat (symbol-name mode) "-hook"))))
    (add-hook hook (lambda ()
                     (require 'semantic)
                     (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
                     (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
                     (when (eq major-mode 'emacs-lisp-mode)
                       (semantic-default-elisp-setup))
                     (semantic-mode 1)))))

(defun semantic/init-semantic ()
  (use-package semantic
    :defer t
    :init
    (progn
      (setq srecode-map-save-file (concat spacemacs-cache-directory "srecode-map.el"))
      (setq semanticdb-default-save-directory (concat spacemacs-cache-directory "semanticdb/"))
      (semantic/enable-semantic-mode 'emacs-lisp-mode))))

(defun semantic/init-srefactor ()
  (use-package srefactor
    :defer t
    :init
    (progn
      (defun spacemacs/lazy-load-srefactor ()
        "Lazy load the package."
        (require 'srefactor)
        ;; currently, evil-mode overrides key mapping of srefactor menu
        ;; must expplicity enable evil-emacs-state. This is ok since
        ;; srefactor supports j,k,/ and ? commands when Evil is
        ;; available
        (add-hook 'srefactor-ui-menu-mode-hook 'evil-emacs-state)
        ;; enable specific major mode setup before it can be used
        ;; properly. For now, only Emacs Lisp.
        (when (eq major-mode 'emacs-lisp-mode)
          (use-package srefactor-lisp
            :commands (srefactor-lisp-format-buffer
                       srefactor-lisp-format-defun
                       srefactor-lisp-format-sexp
                       srefactor-lisp-one-line))
          (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfb" 'srefactor-lisp-format-buffer)
          (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfd" 'srefactor-lisp-format-defun)
          (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfr" 'srefactor-lisp-format-sexp)
          (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfo" 'srefactor-lisp-one-line)))
      ;; load srefactor for emac-lisp-mode
      (add-hook 'emacs-lisp-mode-hook 'spacemacs/lazy-load-srefactor))))

(defun semantic/init-stickyfunc-enhance ()
  (use-package stickyfunc-enhance
    :defer t
    :init
    (defun spacemacs/lazy-load-stickyfunc-enhance ()
      "Lazy load the package."
      (require 'stickyfunc-enhance))))
