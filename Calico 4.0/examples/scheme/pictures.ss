(import "Myro")
;;(Myro.init "/dev/rfcomm1")
(define pic (Myro.makePicture 100 100))
(import "Graphics")
(define win (Graphics.Window))
;;(pic.draw win)
(Myro.show pic)