(defpackage #:khaga
  (:nicknames #:kh)
  (:use :cl))
(in-package :kh)

(defgeneric send-message (addr msg)
  (:documentation "Send a message to an actor"))
(defgeneric next-message (act)
  (:documentation "Gets the next message of an actor"))
(defgeneric spawn (act)
  (:documentation "Spawns an actor, returning an address"))
(defgeneric handle-message (act msg)
  (:documentation "Handle a message"))
