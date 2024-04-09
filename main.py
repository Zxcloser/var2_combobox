import sys
from PyQt6 import QtGui, QtCore,  QtWidgets
from PyQt6.QtWidgets import *
from PyQt6.QtGui import *
import MySQLdb as mdb
from mainwindow import Ui_MainWindow


class Window(QMainWindow):
    def __init__(self):
        super(Window, self).__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.conn = mdb.connect("localhost", "root", "root", "var2_tar")
        self.cursor = self.conn.cursor()
        self.cursor.execute("select * from metering_device")
        res = self.cursor.fetchall()
        for i in res:
            self.ui.comboBox.addItem(str(i[0]))
        self.ui.comboBox.currentTextChanged.connect(self.change)

    def change(self):
        print(self.ui.comboBox.currentText())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main = Window()
    main.show()
    sys.exit(app.exec())