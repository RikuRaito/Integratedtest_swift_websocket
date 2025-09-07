//
//  ContentView.swift
//  Websocket_test
//
//  Created by 斉藤吏功 on 2025/09/07.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var wsManager = WebSocketManager()
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("📡 WebSocket Test")
                .font(.title)

            HStack {
                Button("接続") {
                    wsManager.connect()
                }
                .buttonStyle(.borderedProminent)

                Button("切断") {
                    wsManager.disconnect()
                }
                .buttonStyle(.bordered)
            }

            HStack {
                TextField("メッセージを入力", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("送信") {
                    wsManager.send(inputText)
                    inputText = ""
                }
                .buttonStyle(.borderedProminent)
            }

            List(Array(wsManager.messages.enumerated()), id: \.offset) { index, msg in
                Text(msg)
            }
        }
    }
}
