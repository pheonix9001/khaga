(defpackage #:khaga
  (:nicknames #:kh)
  (:use :cl)
  (:export
    send-message
    handle-message
    spawn
    spawn-make
    send-make
    addr-of

   	; thread-actor.lisp
    thread-actor
    thread-addr))
(in-package :kh)

(defgeneric send-message (addr msg)
  (:documentation "Send a message to an actor."))

(defgeneric handle-message (act msg)
  (:documentation "Implemented when actor can handle a msg"))

(defgeneric spawn (act)
  (:documentation "Spawns an actor, returning an address"))

(defgeneric addr-of (act)
  (:documentation "Gets the address of an actor, or null. This should only be used to send messages to self"))

(defun spawn-make (class &rest args)
  (spawn (apply #'make-instance class args)))
(defun send-make (addr class &rest args)
  (send-message addr (apply #'make-instance class args)))
