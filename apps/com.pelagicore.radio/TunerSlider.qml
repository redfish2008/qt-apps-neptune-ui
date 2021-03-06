/****************************************************************************
**
** Copyright (C) 2016 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.0
import utils 1.0
import controls 1.0

UIElement {
    id: root;
    hspan: 8
    vspan: 2
    property real value // value is read/write.
    property real minimum: 0
    property real maximum: 1
    property int length: width - handle.width
    property int animationDuration: 250
    property bool useAnimation: false
    property alias dragging: area.pressed

    property real activeValue

    Behavior on value {
        enabled: useAnimation && !area.drag.active
        NumberAnimation { duration: animationDuration}
    }

    function valueToString() {
        return activeValue.toFixed(2)
    }

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: handle.width * 0.5
        anchors.rightMargin: handle.width * 0.5
        height: 4
        radius: 4
        border.color: Qt.lighter(color, 1.1)
        color: "#999"
        opacity: 0.25
    }

    ColumnLayout {
        anchors.bottom: background.top
        anchors.left: background.left
        anchors.right: background.right
        anchors.bottomMargin: markers.markerWidth

        spacing: 0

        Item {
            id: frequencies
            Layout.fillWidth: true
            height: Style.vspan(1)

                Label {
                    id: minFreqLabel
                    text: minimum

                    width: 0
                    horizontalAlignment: Text.AlignHCenter

                    anchors.horizontalCenter: parent.left
                    anchors.bottom: parent.bottom

                    font.family: Style.fontFamily
                    font.pixelSize: Style.fontSizeS
                    font.weight: Style.fontWeight

                    color: Style.colorWhite
                }

                Label {
                    text: "MHz"

                    anchors.left: minFreqLabel.left

                    width: Style.hspan(0.9)

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Style.fontSizeXXS
                }

                Label {
                    id: meanFreqLabel
                    text: (minimum + maximum) / 2

                    width: 0
                    horizontalAlignment: Text.AlignHCenter

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Style.paddingXS


                    font.family: Style.fontFamily
                    font.pixelSize: Style.fontSizeM
                    font.weight: Style.fontWeight

                    color: Style.colorWhite
                }

                Label {
                    text: "MHz"

                    width: Style.hspan(1.1)

                    anchors.left: meanFreqLabel.left

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Style.fontSizeXXS
                }

                Label {
                    id: maxFreqLabel
                    text: maximum

                    width: 0
                    horizontalAlignment: Text.AlignHCenter

                    anchors.horizontalCenter: parent.right
                    anchors.bottom: parent.bottom

                    font.family: Style.fontFamily
                    font.pixelSize: Style.fontSizeS
                    font.weight: Style.fontWeight

                    color: Style.colorWhite
                }

                Label {
                    text: "MHz"

                    width: Style.hspan(0.9)

                    anchors.left: maxFreqLabel.left

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Style.fontSizeXXS
                }
        }

        Item {
            id: markers
            height: Style.vspan(1.5)
            Layout.fillWidth: true

            property int markerWidth: 2
            property int markerCount: 41

            RowLayout {
                anchors.fill: parent
                spacing: (parent.width - (markers.markerCount * markers.markerWidth)) / (markers.markerCount - 1)
                Repeater {
                    model: markers.markerCount
                    delegate: Rectangle {
                        id: marker
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        transformOrigin: Item.Bottom
                        height: Style.vspan(1.5)
                        width: markers.markerWidth
                        radius: markers.markerWidth
                        opacity: index % 10 ? 0.25 : 0.5
                        scale: index % 10 ? 0.7 : 1
                        color: "#999"
                    }
                }
            }
        }
    }

    Rectangle {
        id: handle;
        smooth: true
        width: 26;
        y: (root.height - height)/2;
        x: (root.value - root.minimum) * root.length / (root.maximum - root.minimum)

        height: width; radius: width/2
        border.color: Qt.lighter(color, 1.1)
        color: '#fff'

        Rectangle {
            color: Style.colorOrange
            width: 2
            height: Style.vspan(1.2)

            radius: width

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
        }

        MouseArea {
            id: area
            hoverEnabled: false
            width: Style.hspan(2)
            height: width
            anchors.centerIn: parent
            drag.target: root.dragging ? parent : undefined
            drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: root.length
            onPositionChanged: {
                root.activeValue = root.minimum + (root.maximum - root.minimum) * handle.x / root.length
            }
        }
    }
}
