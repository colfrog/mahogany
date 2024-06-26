(in-package #:mahogany)

;; (defmethod initialize-instance :after ((object mahogany-state) &key &allow-other-keys))

(defun server-state-reset (state)
  (declare (type mahogany-state state))
  (setf (mahogany-state-server state) nil))

(defun server-stop (state)
  (declare (type mahogany-state state))
  (hrt:hrt-server-stop (mahogany-state-server state)))

(defun server-keystate-reset (state)
  (setf (mahogany-state-key-state state)
	(make-key-state (mahogany-state-keybindings state))))

(defun (setf mahogany-state-keybindings) (kmaps state)
  (declare (type list kmaps)
	   (type mahogany-state state))
  (setf (slot-value state 'keybindings) kmaps)
  (unless (key-state-active-p (mahogany-state-key-state state))
    (server-keystate-reset state)))

(defun mahogany-state-view-add (state view)
  (declare (type mahogany-state state))
  (push view (slot-value state 'views))
  (log-string :trace "Views: ~S" (slot-value state 'views)))

(defun mahogany-state-view-remove (state view)
  (declare (type mahogany-state state))
  (with-slots (views) state
    (setf views (remove view views :test #'cffi:pointer-eq))
    (log-string :trace "Views: ~S" views)))
