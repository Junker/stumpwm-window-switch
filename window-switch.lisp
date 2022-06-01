(in-package :window-switch)

(defparameter *timeout* 1)

(defvar *last-window-list* '())
(defvar *stable-focus-window-hook-timer* nil)


(defun handle-focus-window-hook-timeout (window)
  "Handle timeout from window-handle-focus-window-hook. Log the current new
stable window and move current to last."
  (cancel-timer *stable-focus-window-hook-timer*)
  (setq *stable-focus-window-hook-timer* nil)
  (when (not (eq window (first *last-window-list*)))
    (setq *last-window-list* (cons window
                                   (remove window *last-window-list*)))))

(defun handle-focus-window-hook (window last-window)
  "Track window focus changes"
  (declare (ignore last-window))
  (when *stable-focus-window-hook-timer*
    (cancel-timer *stable-focus-window-hook-timer*))
  (setq *stable-focus-window-hook-timer*
        (run-with-timer *timeout* nil #'handle-focus-window-hook-timeout window)))

(defun handle-destroy-window-hook (window)
  "Track window destroy"
  (setq *last-window-list* (remove window *last-window-list*)))

(defcommand select-previous-window () ()
  (let ((last-window (second *last-window-list*)))
    (when last-window
      (stumpwm::focus-all last-window)
      (rotatef (second *last-window-list*) (first *last-window-list*)))))

(defcommand windowlist-last (&optional (fmt stumpwm:*window-format*)) ()
  (if-let ((window (stumpwm::select-window-from-menu *last-window-list* fmt)))
    (stumpwm::focus-all window)
    (throw 'error :abort)))

(add-hook *focus-window-hook* #'handle-focus-window-hook)
(add-hook *destroy-window-hook* #'handle-destroy-window-hook)
