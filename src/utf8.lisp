;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Common Lisp UTF-8 Encoding and Decoding Package
;;; @author: chongwish
;;; @email: chongwish@gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage #:clo-coding.utf8
  (:use :cl)
  (:nicknames :clo-coding-utf8)
  (:export #:encode
           #:decode))

(in-package #:clo-coding.utf8)


;;; encoding

(defmethod encode ((ch character))
  "convert character to binary"
  (let ((code (char-code ch)))
    (if (<= code #x7F)
        code
        (let ((result 0))
          (setf (ldb (byte 6 0) result) (ldb (byte 6 0) code))
          (setf (ldb (byte 2 6) result) #b10)
          (if (<= code #x7FF)
              (progn
                (setf (ldb (byte 5 8) result) (ldb (byte 5 6) code))
                (setf (ldb (byte 3 13) result) #b110))
              (progn
                 (setf (ldb (byte 6 8) result) (ldb (byte 6 6) code))
                 (setf (ldb (byte 2 14) result) #b10)
                 (if (<= code #xFFFF)
                     (progn
                       (setf (ldb (byte 4 16) result) (ldb (byte 4 12) code))
                       (setf (ldb (byte 4 20) result) #b1110))
                     (progn
                       (setf (ldb (byte 6 16) result) (ldb (byte 6 12) code))
                       (setf (ldb (byte 2 22) result) #b10)
                       (setf (ldb (byte 3 24) result) (ldb (byte 3 18) code))
                       (setf (ldb (byte 5 27) result) #b11110)))))
          result))))


(defmethod encode ((str string))
  "convert string to binary list"
  (loop for i across str
     collect (encode i)))

(defmethod encode (*)
  "convert to binary list"  
  (encode (format nil "~a" *)))


;;; decoding

(defmethod decode ((n number))
  "convert binary to character code"
  (if (= (ldb (byte 8 7) n) #b0)
      (code-char n)
      (code-char
       (let ((result 0))
         (setf (ldb (byte 6 0) result) (ldb (byte 6 0) n))
         (if (= (ldb (byte 3 13) n) #b110)
             (setf (ldb (byte 5 6) result) (ldb (byte 5 8) n))
             (progn
               (setf (ldb (byte 6 6) result) (ldb (byte 6 8) n))
               (if (= (ldb (byte 4 20) n) #b1110)
                   (setf (ldb (byte 4 12) result) (ldb (byte 4 16) n))
                   (progn
                     (setf (ldb (byte 6 12) result) (ldb (byte 6 16) n))
                     (setf (ldb (byte 3 18) result) (ldb (byte 3 24) n))))))
         result))))

(defmethod decode ((n string))
  "convert string to character code"
  (decode (parse-integer n)))

(defmethod decode ((l list))
  "convert string/binary list to character code"
  (loop for i in l
     collect (decode i)))
