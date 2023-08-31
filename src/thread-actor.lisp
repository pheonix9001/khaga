(in-package :kh)

(defclass thread-actor ()
  ((thread
    :accessor actor-thread
    :type bt:thread
    :documentation "The native thread")
   (myself
     :accessor addr-of
     :type chanl:channel
     :documentation "The address for sending messages"))
  (:documentation "An actor that runs on a native thread"))

(defclass thread-addr ()
  ((chan
     :initarg :chan
     :accessor addr-chan
     :type chanl:channel
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
