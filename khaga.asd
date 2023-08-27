(asdf:defsystem khaga
  :description "A flexible actor system"
  :version "0.0.1"
  :author "pheonix9001 <pheonix9001@tutanota.com>"
  :licence "MIT"
  :depends-on (bordeaux-threads)
  :components
  ((:module "src"
    :components ((:file "actor")))))
