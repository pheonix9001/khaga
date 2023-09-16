# khaga
Flexible actors for common lisp

## Tutorial
To create an actor, create a class containing all the state, inheriting from any of the actor classes. Currently, only `thread-actor` is supported which creates a thread for each instance of the actor(in the future, async actors will be supported)

```lisp
(defclass counter (kh:thread-actor)
  (counter-val :initform 0 :accessor counter-count))
(defclass count-up-msg ()
  ((by :initform 1 :initarg :by)))
(defclass print-count () ())

(defmethod kh:handle-message ((act thread-actor) (msg count-up-msg))
  (incf (counter-count act)))
(defmethod kh:handle-message ((act thread-actor) (msg print-count))
  (print (counter-count act)))
```

To spawn the actor, use `spawn-make`, and to send messages to it, use `send-make`

```lisp
(defvar *mycounter* (spawn-make 'counter))
; Syntax sugar for this
#+(or)
(defvar *mycounter* (spawn (make-instance 'counter)))

(send-make *mycounter* 'count-up-msg)
(send-make *mycounter* 'count-up-msg :by 2)
(send-make *mycounter* 'count-up-msg :by 3)
(send-make *mycounter* 'count-up-msg)
; Again syntax sugar
#+(or)
(send (make-instance 'count-up-msg))

(send-make *mycounter* 'print-count)
```

## Future work
- Function based actors
- Actor registries
- Asynchronous actors
