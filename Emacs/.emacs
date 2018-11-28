;;(setq warning-minimum-level :emergency)

(set-default-font "Monospace-12")
(when (eq system-type 'gnu/linux)
  (defun x11-maximize-frame ()
    "Maximize the current frame (to full screen)"
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
  (run-with-idle-timer 0.01 nil 'x11-maximize-frame)
  )

(setq inhibit-startup-screen t)
;; Show just the file name instead of the entire path
(setq-default frame-title-format '("%b"))
;; Make delete button delete to from the right of the cursor (like normal) instead of the left (like backspace key)
(normal-erase-is-backspace-mode 1)

(setq-default major-mode 'text-mode)
;; Make ctrl-c copy, ctrl-v paste, ctrl-z undo, etc
(cua-mode t)

;; Load and set the theme
;; (load-file "~/.emacs.d/themes/nimbus-theme.el")
;; (nimbus-theme)

(defun prepend-path ( my-path )
    (setq load-path (cons (expand-file-name my-path) load-path)))
    
    (defun append-path ( my-path )
    (setq load-path (append load-path (list (expand-file-name my-path)))))
    ;; Look first in the directory ~/elisp for elisp files
    (prepend-path "~/lisp")
    ;; Load verilog mode only when needed
    (autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
    ;; Any files that end in .v should be in verilog mode
    (setq auto-mode-alist (cons  '("\\.v\\'" . verilog-mode) auto-mode-alist))
    (setq auto-mode-alist (cons  '("\\.vx\\'" . verilog-mode) auto-mode-alist))
    ;; Any files in verilog mode should have their keywords colorized
    (add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))


;; Save backup for all emacs files
(setq backup-directory-alist
          `((".*" . ,"~/.backups/")))
    (setq auto-save-file-name-transforms
          `((".*" ,"~/.backups/" t)))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(verilog-align-ifelse nil)
 '(verilog-auto-indent-on-newline nil)
 '(verilog-auto-newline nil)
 '(verilog-case-indent 4)
 '(verilog-cexp-indent 4)
 '(verilog-highlight-grouping-keywords t)
 '(verilog-highlight-p1800-keywords t)
 '(verilog-indent-begin-after-if nil)
 '(verilog-indent-level 4)
 '(verilog-indent-level-behavioral 4)
 '(verilog-indent-level-declaration 4)
 '(verilog-indent-level-directive 4)
 '(verilog-indent-level-module 4)
 '(verilog-minimum-comment-distance 0)
 '(verilog-tab-always-indent nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 123 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

(defun my-verilog-hook ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4))
 (add-hook 'verilog-mode-hook 'my-verilog-hook)

;; Add line numbers left side
(global-linum-mode t)