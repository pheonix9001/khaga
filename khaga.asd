(in-package :asdf-user)

(asdf:defsystem khaga
  :description "A flexible actor system"
  :version "0.0.1"
  :author "pheonix9001 <pheonix9001@tutanota.com>"
  :licence "MIT"
  :depends-on (bordeaux-threads chanl)
  :components
  ((:module "src"
    :components ((:file "actor"))))
  :in-order-to ((test-op (test-op :khaga/tests))))

(asdf:defsystem khaga/tests
  :description "A flexible actor system"
  :version "0.0.1"
  :author "pheonix9001 <pheonix9001@tutanota.com>"
  :licence "MIT"
  :depends-on (bordeaux-threads chanl fiveam khaga)
  :components
  ((:module "tests"
    :components ((:file "main"))))
  :perform (test-op (op c)
    (symbol-call :fiveam :run! (find-symbol* :khaga :khaga/tests))))
