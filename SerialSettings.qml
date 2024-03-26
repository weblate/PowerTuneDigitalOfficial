import QtQuick 2.8
import QtQuick.Controls 1.4 as Quick1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import QtSensors 5.0
import QtQuick.Controls.Styles 1.4

import QtMultimedia 5.8
import "qrc:/Gauges/"
import DLM 1.0


Item {
    anchors.fill: parent
    property int lastdashamount

    DLM {
        id: downloadManager
    }
    Connections {
        target: Dashboard
        onEcuChanged: {
            setregtabtitle()
        }
    }

    property ListModel tabSources: ListModel {
        ListElement { title: "Main"; source: "Settings/main.qml" }
        ListElement { title: "Dash Sel."; source: "Settings/DashSelector.qml" }
        ListElement { title: "Sensehat"; source: "Settings/sensehat.qml" }
        ListElement { title: "Warn / Gear"; source: "Settings/warn_gear.qml" }
        ListElement { title: "Speed"; source: "Settings/speed.qml" }
        ListElement { title: "ECU"; source: "Settings/analog.qml" } // Use the onCompleted signal to set title
        ListElement { title: "RPM"; source: "Settings/rpm.qml" }
        ListElement { title: "EX Board"; source: "qrc:/ExBoardAnalog.qml" }
        ListElement { title: "Startup"; source: "Settings/startup.qml" }
        ListElement { title: "Network"; source: "Settings/network.qml" }
    }

    ListView {
        id: listView
        width: 180
        height: parent.height
        model: tabSources

        delegate: Item {
            width: listView.width
            height: 50

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                Text {
                    anchors.centerIn: parent
                    text: title
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked on " + title)
                    dynamicLoader.setSource(source);
                }
            }
        }

        ScrollBar.vertical: ScrollBar { }
    }

    Loader {
        id: dynamicLoader
        anchors {
            left: listView.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
    }

    Component.onCompleted: {
        // Set the title for the tab with an empty title
        for (let i = 0; i < tabSources.length; i++) {
            if (tabSources[i].title === "") {
                // Assuming setregtabtitle() returns the correct title
                tabSources[i].title = setregtabtitle()
                listView.modelChanged() // Force ListView to update
                break
            }
        }
    }
}
