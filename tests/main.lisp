(defpackage :khaga/tests
  (:use :cl :fiveam)
  (:export khaga))
(in-package :khaga/tests)

(def-suite* khaga)

(defclass counter (kh:thread-actor)
  ((val :initarg :init :accessor counter-val)))
(defclass count-up-msg () ())
(defclass count-up-2 () ())

(defmethod kh:handle-message ((act counter) (msg count-up-msg))
  (setf (counter-val act) (+ 1 (counter-val act))))

; Send messages to self
(defmethod kh:handle-message ((act counter) (msg count-up-2))
  (kh:send-make (kh:addr-of act) 'count-up-msg)
  (kh:send-make (kh:addr-of act) 'count-up-msg))

(test counter
  (let* ((act (make-instance 'counter :init 0))
         (addr (kh:spawn act)))
    ; Technically unsafe since you should not access the value of an actor from another thread
    ; but haha sleep go brrr
    (is (= 0 (counter-val act)))
    (kh:send-make addr 'count-up-msg)
    (sleep 1)
    (is (= 1 (counter-val act)))
    (kh:send-make addr 'count-up-msg)
    (kh:send-make addr 'count-up-msg)
    (kh:send-make addr 'count-up-msg)
    (sleep 1)
    (is (= 4 (counter-val act)))
    (kh:send-make addr 'count-up-2)
    (kh:send-make addr 'count-up-2)
    (sleep 1)
    (is (= 8 (counter-val act)))))
