import Gtk, Pango

class MyWindow(Gtk.Window):

        def invoke(sender, args):
        Gtk.Application.Invoke(invoke)
    def Expose_Event(self, obj, args):
                                5, 5, self.layout)


mywin = MyWindow("My Window")