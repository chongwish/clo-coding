(defpackage clo-coding-asd
  (:use :cl :asdf))

(in-package clo-coding-asd)

(defsystem clo-coding
  :version "0.1"
  :author "chongwish"
  :licence "BSD"
  :description "Encoding and Decoding for Common Lisp"
  :components ((:file "main"
                :pathname "src/main"
                :depends-on ("lib"))
               (:module "lib"
                :pathname "src"
                :components ((:file "utf8")))))
