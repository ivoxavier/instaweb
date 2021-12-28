/* 
 * Copyright (C) 2021 Ivo Xavier
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */

import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5
import Ubuntu.Content 1.3
import QtQuick.Controls.Suru 2.2


MainView {
  id: mainView

  objectName: "mainView"
  
  property color b_color: "#501644"

  width: units.gu(45)
  height: units.gu(75)

  applicationName: "instaweb.ivoxavier"
  backgroundColor : "transparent"
  anchors {
    fill: parent
    bottomMargin: UbuntuApplication.inputMethod.visible ? UbuntuApplication.inputMethod.keyboardRectangle.height/(units.gridUnit / 8) : 0
    Behavior on bottomMargin {
        NumberAnimation {
            duration: 175
            easing.type: Easing.OutQuad
        }
    }
  }

  property list<ContentItem> importItems

  PageStack {
    id: mainPageStack
    anchors.fill: parent
    Component.onCompleted: mainPageStack.push(pageMain)


    Page {
      id: pageMain
      anchors.fill: parent

      WebEngineView {
        id: webview
        anchors{ fill: parent }
        focus: true
        property var currentWebview: webview
        settings.pluginsEnabled: true

        profile:  WebEngineProfile {
          id: webContext
          httpUserAgent: "Mozilla/5.0 (Linux, Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"
          storageName: "Storage"
          persistentStoragePath: "/home/phablet/.cache/instaweb.ivoxavier/instaweb.ivoxavier/QtWebEngine"
        }
        anchors {
          fill:parent
          centerIn: parent.verticalCenter
        }
        url: Suru.theme === 0 ? "https://www.instagram.com/" : "https://www.instagram.com/?theme=dark"
        
        onFileDialogRequested: function(request) {
          request.accepted = true;
          var importPage = mainPageStack.push(Qt.resolvedUrl("ImportPage.qml"),{"contentType": ContentType.All, "handler": ContentHandler.Source})
          importPage.imported.connect(function(fileUrl) {
            console.log(String(fileUrl).replace("file://", ""));
            request.dialogAccept(String(fileUrl).replace("file://", ""));
            mainPageStack.push(pageMain)  
          })
        }
        onNewViewRequested: {
            request.action = WebEngineNavigationRequest.IgnoreRequest
            if(request.userInitiated) {
                Qt.openUrlExternally(request.requestedUrl)
            }
        }
      }
    }
  }
}