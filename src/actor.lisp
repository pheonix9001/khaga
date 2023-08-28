(defpackage #:khaga
  (:nicknames #:kh)
  (:use :cl)
  (:export
    send-message
    handle-message
    spawn
    spawn-make
    send-make
    thread-actor
    addr-of))
(in-package :kh)

(defgeneric send-message (addr msg)
  (:documentation "Send a message to an actor."))

(defgeneric handle-message (act msg)
  (:documentation "Implemented when actor can handle a msg"))

(defgeneric spawn (act)
  (:documentation "Spawns an actor, returning an address"))

(defun spawn-make (class &rest args)
  (spawn (apply #'make-instance class args)))
(defun send-make (addr class &rest args)
  (send-message addr (apply #'make-instance class args)))

(defclass thread-actor ()
  ((thread
    :accessor actor-thread
    :documentation "The native thread")
   (myself
     :accessor addr-of
     :documentation "The address for sending messages"))
  (:documentation "An actor that runs on a native thread"))

(defclass thread-addr ()
  ((chan
     :initarg :chan
     :accessor addr-chan
     :documentation "The channel for sending messages"))
  (:documentation "An address to an actor running on a native thread"))

(defmethod spawn ((act thread-actor))
  (let* ((chan (make-instance 'chanl:bounded-channel :size 255))
        (addr (make-instance 'thread-addr :chan chan)))
    (defun act-loop ()
      (loop
        (let ((msg (chanl:recv chan))) (handle-message act msg))))

    (setf (actor-thread act) (bt:make-thread #'act-loop))
    (setf (addr-of act) addr)
    addr))

(defmethod send-message ((addr thread-addr) msg)
  (chanl:send (addr-chan addr) msg :blockp '()))
