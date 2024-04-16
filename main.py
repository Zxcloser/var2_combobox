import sys
from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QCheckBox, QRadioButton, QMessageBox
import MySQLdb as mdb
from mainwindow import Ui_MainWindow
import time
from decimal import Decimal


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
        self.layout = QVBoxLayout(self.ui.widget)
        self.check = None  # Объявляем переменные как члены класса
        self.check_child = None
        self.ui.CalculateButton.clicked.connect(self.calculate)
        self.ui.WriteButton.clicked.connect(self.write)
        self.start = time.time()

    def change(self):
        if self.check:
            self.layout.removeWidget(self.check)  # Удаляем старый чекбокс, если существует
            self.check.deleteLater()  # Очищаем память
            self.check = None
        if self.check_child:
            self.layout.removeWidget(self.check_child)  # Удаляем старый чекбокс, если существует
            self.check_child.deleteLater()  # Очищаем память
            self.check_child = None

        self.cursor.execute(f"select id from prescribed where dev_id = {self.ui.comboBox.currentText()}")
        victims = self.cursor.fetchall()
        for victim in victims:
            self.cursor.callproc('CheckIfPensioner', [int(victim[0])])
            pen = self.cursor.fetchone()[0]
            self.cursor.nextset()
            if pen == 1:
                break
        try:
            dev_id = int(self.ui.comboBox.currentText())
            self.cursor.callproc('CountChildrenInHouse', [dev_id])
            children = self.cursor.fetchone()[0]
            self.cursor.nextset()
        except Exception as e:
            print("Error occurred:", e)

        if pen == 1:
            self.check = QCheckBox("Пенсионер", parent=self.ui.widget)
            self.check.setChecked(True)
            self.layout.addWidget(self.check)
        if children >= 3:
            self.check_child = QCheckBox("Многодетные", parent=self.ui.widget)
            self.check_child.setChecked(True)
            self.layout.addWidget(self.check_child)


        self.cursor.execute("SELECT HOUR(NOW());")
        date = self.cursor.fetchall()
        if date[0][0] < 23 and date[0][0] >= 7:
            self.t_id = 1
        else:
            self.t_id = 2
        self.cursor.execute(f"select name from tariff where id = {self.t_id};")
        t_name = self.cursor.fetchall()
        Tarif = QRadioButton(f"{t_name[0][0]}")
        Tarif.setChecked(True)
        vbox = QVBoxLayout()
        vbox.addWidget(Tarif)
        self.ui.groupBox.setLayout(vbox)

    def calculate(self):
        self.message = QMessageBox()
        self.message.setWindowTitle("Результат")
        self.cursor.execute(f"call 	CalculateElectricityTariff({int(self.ui.comboBox.currentText())});")
        res = self.cursor.fetchall()
        self.message.setText(f"{res[0][0]}")
        self.message.exec()

    def write(self):
        discount = Decimal('0.0')  # Используйте Decimal для скидки и результатов
        if self.check is not None:
            discount += Decimal('0.3')
        if self.check_child is not None:
            discount += Decimal('0.4')
        finish = time.time()
        res = int(finish - self.start)
        self.cursor.execute(f"SELECT price FROM tariff WHERE id = {self.t_id}")
        price = Decimal(self.cursor.fetchone()[0])  # Преобразуйте price в Decimal

        insert_query = (
            f"INSERT INTO indications (data, indications, total, tariff_id, dev_id) "
            f"VALUES (NOW(), {res}, {Decimal(res) * price * (Decimal('1') - discount)}, {self.t_id}, {int(self.ui.comboBox.currentText())})"
        )
        self.cursor.execute(insert_query)
        self.conn.commit()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main = Window()
    main.show()
    sys.exit(app.exec())
