/***************************************************************************
 * Copyright: 2015-2016 Hendrik Lehmbruch <hendrikL@siduction.org>
 *            2013 Reza Fatahilah Shah <rshah0385@kireihana.com>
 *            2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 * OR OTHER DEALINGS IN THE SOFTWARE.
 *
 ***************************************************************************/

import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import "./components"

Rectangle {
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    /* Resets the "Login Failed" message after 2½ seconds */
    Timer {
        id: errorMessageResetTimer
        interval: 2500
        onTriggered: errorMessage.text = ""
    }

    Connections {
        target: sddm

        /* on fail login, clean user and password entry */
        onLoginFailed: {
            pw_entry.text = ""
            user_entry.text = ""
            user_entry.focus = true            
            /* Reset the message*/
            errorMessageResetTimer.restart()
            errorMessage.text = textConstants.loginFailed
        }
    }

    Repeater {
        model: screenModel
        Background {
            x: geometry.x
            y: geometry.y
            width: geometry.width
            height:geometry.height
            source: config.background
            fillMode: Image.PreserveAspectCrop

            KeyNavigation.backtab: user_entry; KeyNavigation.tab: user_entry

            onStatusChanged: {
                if (status == Image.Error && source != config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    /* topBar */    
    Rectangle {
        id: topBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width -24
        height: 34
        color: "transparent" //"black" //"#053343"
        radius: 9
        opacity: 0.25 
    }    
    /* end topBar */

    /* background Main block */    
    /************************************************** 
     * this sddm greeter is made for dark backgrounds
     * if you have light ones, choose a background color
     * for the login/Main block below
     * at the moment it is "transparent"
     * also take a look to the topBar above
     **************************************************/ 
    Rectangle {
        id: mainBlock
        anchors.centerIn: parent
        width: 534
        height: 150
        color:  "transparent" //"black" //"#053343"
        opacity: 0.25
        radius: 9
    }
    /* end background Main block */  

    /* Main block */
    Rectangle {
        anchors.centerIn: parent
        width: 534
        height: 150
        color: "#00000000"

        /* Messages and warnings */             
        CapsLock {
            id: txtCaps
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 27
            color:"white"
            font.pixelSize: 14
        }

        /* Login faild message */
        Text {
            id: errorMessage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            color:"white"
            font.pixelSize: 14
        }
        /* End Messages and warnings */

        /* Login block */
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 55

            /* workaround to focus the user_entry, see below the TextBox user_entry */
            property alias user: user_entry.text

            /* workaround to focus pw_entry if needed */
            property alias password: pw_entry.text

            Column {
                height: 71
                spacing: 5

                Row {
                    id:labelRow
                    spacing: 12

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: 250; height: 17
                        color: "transparent" 

                        Text {
                            id:userName
                            color:"white"
                            text:textConstants.userName
                            font.pixelSize: 12
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: 250; height: 17
                        color: "transparent"

                        Text {
                            id: userPassword
                            color: "white"
                            text: textConstants.password
                            font.pixelSize: 12
                        }
                    }    
                }                    

                Row {
                    id: userRow
                    anchors.right: parent.right
                    spacing: 12

                    TextBox {
                        id: user_entry

                        /* I THINK THERE IS NO NEED FOR THAT HACK ANY MORE, BUT I LEAVE IT AS IT IS */

                        /*** hack found in plasma breeze sddm as workaround to focus input field ***/
                        /***************************************************************************** 
                         * focus works in qmlscene
                         * but this seems to be needed when loaded from SDDM
                         * I don't understand why, but we have seen this before in the old lock screen
                         ******************************************************************************/ 

                        /* start hack */
                        Timer {
                            interval: 200
                            running: true
                            repeat: false
                            onTriggered: user_entry.forceActiveFocus()
                        }
                        /* end hack */

                        width: 250
                        height: 30

                        /***********************************************************************
                         * If you want the last successfully logged in user to be displayed,
                         * uncomment the "text: userModel.lastUser" row below
                         * for more informations why it isn't possible to configure it via
                         * /etc/sddm.conf see https://bugzilla.redhat.com/show_bug.cgi?id=1238889
                         * so i wait, till this is fixed in debian sid.
                         * Dont forget to enable it in the /etc/sddm.conf
                         * "RememberLastUser=true",
                         * also take a look to the pw_entry section below!
                         ************************************************************************/

                        //text: userModel.lastUser

                        font.pixelSize: 14
                        radius: 3
                        focus: true

                        KeyNavigation.backtab: user_entry; KeyNavigation.tab: pw_entry
                    }

                    PwBox {
                        id: pw_entry

                        /***************************************************************
                         * if you uncomment the "text: userModel.lastUser" row above,
                         * uncomment the Timer section below too,
                         * But also comment the Timer section above, so that the
                         * password box is focused and not the user box.
                         * **************************************************************/

                        /* start hack */
                        Timer {
                            interval: 200
                            running: true
                            repeat: false
                            onTriggered: pw_entry.forceActiveFocus()
                        }
                        /* end hack */

                        width: 250
                        height: 30
                        font.pixelSize: 14
                        radius: 3
                        focus: true

                        KeyNavigation.backtab: user_entry; KeyNavigation.tab: login_button

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(user_entry.text, pw_entry.text, menu_session.index)
                                event.accepted = true
                            }
                        }
                        
                    }
                }
                /* end input fields */
                
                Row {
                    id: spaceRow
                    spacing:8
                    
                    Rectangle {
                        id: spaceRectangle
                        height:3
                        width:512
                        radius: 1.5
                        color: "transparent" //"red"
                    }
                }
            }
        }
    }
    /* end Main block */
    
    /* tooltip button */
    ToolTip {
        id: tooltip2
        target: login_button
        text: textConstants.login
    }
    /* end tooltip */
    
    Rectangle {
        id:bgLoginButton
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 246.5
        height:42
        width:42
        radius:21
        color: "white"
    }
    
    /* login button */
   ImageButton {
        id: login_button
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 36
        anchors.topMargin: 250
        source: "images/login_normal.png"                                                    
        
        onClicked: sddm.login(user_entry.text, pw_entry.text, menu_session.index)
        
        KeyNavigation.backtab: pw_entry; KeyNavigation.tab: user_entry /* session_button */
    }
    /* end login button */

        /* welcome to hostname topBar left */
    Text {
        id:hostName
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 10
        color:"white"

        text:textConstants.welcomeText.arg (sddm.hostName)
        font.pixelSize: 12
    }
    /* end hostname */
    
    /* time and date topBar right */
    Timer {
        id: time
        interval: 100
        running: true
        repeat: true
        
        /***************************************************************************
        * The DateTime format is displayed like the system setup, 
        * to change the DateTime format e.g. for the US,
        * change it to (new Date(),"MM-dd-yyyy, hh:mm ap")
        * or you can try LongFormat,ShortFormat or NarrowFormat, it is your choise.
        ****************************************************************************/
        onTriggered: {
            dateTime.text = Qt.formatDateTime(new Date(), Locale.LongFormat)
        }
    }

    Text { 
        id:dateTime
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.topMargin: 10
        color: "white"
    }
    /* end time and date */

    Component.onCompleted: {
        if (user_entry.text === "")
            user_entry.focus = true
            else
                pw_entry.focus = true
    }

} /* fine */
