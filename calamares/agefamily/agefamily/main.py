import os
import json
from PyQt6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QLabel,
    QCheckBox,
    QPushButton,
    QGroupBox,
    QFormLayout,
    QComboBox,
)
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QFont


def create_age_data():
    age_dir = "/etc/age-verification"
    os.makedirs(age_dir, exist_ok=True)
    data = {
        "user_type": "adult",
        "age_bracket": "age_undefined",
        "is_family_account": False,
        "disclaimer_applied": True,
    }
    with open(os.path.join(age_dir, "age-data.json"), "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


class AgeFamilyWidget(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.layout = QVBoxLayout(self)

        # Title
        title = QLabel("Age and Family Information")
        font = QFont()
        font.setBold(True)
        font.setPointSize(12)
        title.setFont(font)
        self.layout.addWidget(title)

        # Country info (optional, non‑binding)
        self.layout.addWidget(
            QLabel(
                "This setup is not specifically targeted at any country "
                "and does not perform real age verification (e.g. ID or CPF check)."
            )
        )

        # Account type
        self.account_group = QGroupBox("Account type")
        form = QFormLayout()
        self.account_type = QComboBox()
        self.account_type.addItems(["Adult account", "Family/child account (under 18)"])
        form.addRow("Type:", self.account_type)
        self.account_group.setLayout(form)
        self.layout.addWidget(self.account_group)

        # Disclaimer
        self.disclaimer = QLabel(
            "<b>No personal data collected:</b><br>"
            "No ID, CPF, or birth date is stored.<br><br>"
            "<b>Usage in Brazil:</b><br>"
            "This system is not designed to comply with the Brazilian "
            "ECA Digital age verification law.<br>"
            "If you use it in Brazil, you do so at your own responsibility.<br><br>"
            "<i>Click the checkbox below to confirm you understand this.</i>"
        )
        self.disclaimer.setWordWrap(True)
        self.layout.addWidget(self.disclaimer)

        self.confirm_box = QCheckBox(
            "I understand that no real age verification is performed and "
            "that this system is not targeted at Brazil."
        )
        self.layout.addWidget(self.confirm_box)

        self.next_btn = QPushButton("Accept and continue")
        self.layout.addWidget(self.next_btn)

        self.next_btn.clicked.connect(self.on_accept)

    def on_accept(self):
        if not self.confirm_box.isChecked():
            self.set_warning("Please check the box to confirm you understand.")
            return

        user_type = "adult"
        if self.account_type.currentIndex() == 1:
            user_type = "family"

        create_age_data()
        age_dir = "/etc/age-verification"
        data_file = os.path.join(age_dir, "age-data.json")

        with open(data_file, "r", encoding="utf-8") as f:
            data = json.load(f)

        data["user_type"] = user_type
        data["is_family_account"] = user_type == "family"

        with open(data_file, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)

        # Calamares‑Signal „weiter“ — das hängt von eurem globalstorage / controller ab
        self.set_warning("Age information saved (no real ID check).", is_error=False)
        self.parent().next()

    def set_warning(self, text, is_error=True):
        color = "red" if is_error else "green"
        self.disclaimer.setStyleSheet(f"color: {color};")
