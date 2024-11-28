/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2022 Anke Boersma <demm@kaosx.us>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 * 
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import io.calamares.core 1.0
import io.calamares.ui 1.0


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Item {
    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "#f2f2f2"

        ButtonGroup {
            id: switchGroup
        }

        Text {
            text: qsTr("Select additional software sources")
            font.bold: true
            font.pointSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            wrapMode: Text.WordWrap
        }

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 5

            Rectangle {

                //id: rectangle
                width: 850
                height: 180
                color: "#ffffff"
                radius: 10
                border.width: 0

                Text {
                    width: 650
                    height: 160
                    anchors.centerIn: parent
                    text: qsTr("<b>Debian</b> - The sources only contain <b>main</b> and <b>non-free-firmware</b> (the default)<br/><br/>Debian comes with dfsg software only, since Debian 12, they added <b>non-free-firmware</b>.<br/>With this choice, you will stay the debian way, but you cannot install non-free drivers (like nvidia)<br/>or proprietary software.")
                    font.pointSize: 10
                    anchors.verticalCenterOffset: 10
                    anchors.horizontalCenterOffset: 90
                    wrapMode: Text.WordWrap
                }

                Image {
                    id: image2
                    x: 40
                    y: 30
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "images/debian.png"
                }
            }

            Rectangle {
                width: 850
                height: 180
                radius: 10
                border.width: 0
                Text {
                    width: 650
                    height: 190
                    anchors.centerIn: parent
                    text: qsTr("<b>non-free</b> - This option allows you to install proprietary drivers or software.<br/><br/>This means that you deviate from the debian dfsg guidelines.<br/>It adds <b>contrib</b> and <b>non-free</b> to your software sources.")
                    font.pointSize: 10
                    anchors.verticalCenterOffset: 20
                    anchors.horizontalCenterOffset: 90
                    wrapMode: Text.WordWrap
                }

                CheckBox {
                    id: control
                    text: qsTr("I also want to use <b>non-free</b>.</b> verwenden.")
                    checked: false
                    x: 190
                    y: 120

                    indicator: Rectangle {
                        implicitWidth: 30
                        implicitHeight: 30
                        x: control.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 15
                        border.width: 2
                        border.color: "#31363b"


                        Rectangle {
                            width: 20
                            height: 20
                            x: 5
                            y: 5
                            radius: 10
                            color: "#009900"
                            visible: control.checked
                        }
                    }

                    contentItem: Text {
                        text: control.text
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: control.indicator.width + 15
                    }

                onCheckedChanged {
                    if (control.checked) {
                         config.packageChoice = "non-free"
                         print(config.packageChoice)
                    }
                }

                Image {
                    id: image
                    x: 40
                    y: 30
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "images/non-free.png"
                }

            }

        }

    }
    //Setze config.packageChoice auf den Standardwert

    Component.onCompleted: {
        config.packageChoice = "debian"
    }

}



// ========================================

/* The original used by towo follows from here.


import io.calamares.core 1.0
import io.calamares.ui 1.0


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Item {
    width: parent.width
    height: parent.height

    property bool isTextVisible: false

    Rectangle {
        anchors.fill: parent
        color: "#f2f2f2"

        ButtonGroup {
            id: switchGroup
        }

        Button {
            id: details
            x: 100
            y: 610
            text: qsTr("Advanced settings (recommended for advanced users)")
            onClicked: {
               isTextVisible = !isTextVisible
               console.log("text visibility:", isTextVisible)
            }
            background: Rectangle {
                width: details.implicitWidth + 40 // Adjust width as needed
                height: details.implicitHeight + 20 // Adjust height as needed
                border.color: parent.pressed ? "transparent" : "white"
                border.width: 1
                color: parent.hovered ? "#e30016" : "#111213"
                anchors.centerIn: parent
            }
            contentItem: Text {
                text: parent.text
                color: "White"
                font.bold: true
                font.pixelSize: 12
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
       }

       Text {
            text: qsTr("Select your software sources <strong>main non-free-firmware</strong> or <strong>main contrib non-free non-free-firmware</strong>.<br/>")
            font.pointSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            wrapMode: Text.WordWrap
        }

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 5

            Rectangle {

                //id: rectangle
                width: 850
                height: 180
                color: "#ffffff"
                radius: 10
                border.width: 0
                Text {
                    width: 650
                    height: 160
                    anchors.centerIn: parent
                    text: qsTr("<b>Debian</b> - The sources will only contain <b>main</b> and <b>non-free-firmware</b> (the default)")
                    font.pointSize: 10
                    anchors.verticalCenterOffset: 10
                    anchors.horizontalCenterOffset: 90
                    wrapMode: Text.WordWrap
                }

                // Text element that becomes visible when the button is clicked
                Text {
                    width: 650
                    height: 160
                    anchors.centerIn: parent
                    text: qsTr("Debian comes with dfsg software only, since Debian 12, they added <b>non-free-firmware</b>. With this choice, you will stay the debian way, but you can not install non-free drivers (like nvidia) or propritary software.")
                    anchors.verticalCenterOffset: 60
                    anchors.horizontalCenterOffset: 90
                    visible: isTextVisible
                    wrapMode: Text.WordWrap
                }

                Switch {
                    id: element2
                    x: 720
                    y: 150
                    width: 187
                    height: 14
                    text: qsTr("Debian")
                    checked: true
                    hoverEnabled: true
                    ButtonGroup.group: switchGroup

                    indicator: Rectangle {
                        implicitWidth: 40
                        implicitHeight: 14
                        radius: 10
                        color: element2.checked ? "#3498db" : "#B9B9B9"
                        border.color: element2.checked ? "#3498db" : "#cccccc"

                        Rectangle {
                            x: element2.checked ? parent.width - width : 0
                            y: (parent.height - height) / 2
                            width: 20
                            height: 20
                            radius: 10
                            color: element2.down ? "#cccccc" : "#ffffff"
                            border.color: element2.checked ? (element2.down ? "#3498db" : "#3498db") : "#999999"
                        }
                    }

                    onCheckedChanged: {
                        if ( ! checked ) {
                            print("debian not used")
                            config.packageChoice = "non-free"
                        }
                        else {
                            config.packageChoice = "debian"
                            print( config.packageChoice )
                        }
                    }
                }

                Image {
                    id: image2
                    x: 40
                    y: 30
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "images/debian.png"
                }
            }

            Rectangle {
                width: 850
                height: 180
                radius: 10
                border.width: 0
                visible: isTextVisible
                Text {
                    width: 650
                    height: 190
                    anchors.centerIn: parent
                    text: qsTr("<b>Non-Free</b> - This choice allows you to install proprietary drivers or software that does not comply with Debian's DFSG guidelines. It will add <b>contrib</b> and <b>non-free</b> to your software sources.")
                    font.pointSize: 10
                    anchors.verticalCenterOffset: 10
                    anchors.horizontalCenterOffset: 90
                    wrapMode: Text.WordWrap
                    visible: isTextVisible
                }

                Switch {
                    id: element1
                    x: 720
                    y: 150
                    width: 187
                    height: 14
                    text: qsTr("Non-Free")
                    checked: false
                    hoverEnabled: true
                    ButtonGroup.group: switchGroup
                    visible: isTextVisible

                    indicator: Rectangle {
                        implicitWidth: 40
                        implicitHeight: 14
                        radius: 10
                        color: element1.checked ? "#3498db" : "#B9B9B9"
                        border.color: element1.checked ? "#3498db" : "#cccccc"

                        Rectangle {
                            x: element1.checked ? parent.width - width : 0
                            y: (parent.height - height) / 2
                            width: 20
                            height: 20
                            radius: 10
                            color: element1.down ? "#cccccc" : "#ffffff"
                            border.color: element1.checked ? (element1.down ? "#3498db" : "#3498db") : "#999999"
                        }
                    }

                    onCheckedChanged: {
                        if ( !checked ) {
                            print("non-free not used")
                            config.packageChoice = "debian"
                        } else {
                            config.packageChoice = "non-free"
                            print(config.packageChoice)
                        }
                    }
                }

                Image {
                    id: image
                    x: 40
                    y: 30
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "images/non-free.png"
                    visible: isTextVisible
                }

            }

        }
    }
    // Setze config.packageChoice auf den Standardwert
    Component.onCompleted: {
        config.packageChoice = "debian"
    }
}
*/
