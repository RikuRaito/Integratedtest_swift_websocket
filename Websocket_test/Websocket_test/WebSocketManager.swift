//
//  WebSocketManager.swift
//  Websocket_test
//
//  Created by 松田朋広 on 2025/09/08.
//

import Foundation

class WebSocketManager: ObservableObject {
    @Published var messages: [String] = []
    private var webSocketTask: URLSessionWebSocketTask?

    // 通信開始（接続）
    func connect() {
        guard webSocketTask == nil else {
            print("⚠️ Already connected")
            return
        }

        let url = URL(string: "ws://192.168.100.79:8765")! // ← 松田のMacのIPに変更
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()

        print("✅ Connected to server")
        receive()
    }

    // メッセージ送信
    func send(_ text: String) {
        guard let webSocketTask = webSocketTask else {
            print("⚠️ Not connected")
            return
        }

        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask.send(message) { [weak self] error in
            if let error = error {
                print("❌ Send error: \(error)")
                DispatchQueue.main.async {
                    self?.messages.append("⚠️ Send failed: \(text)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.messages.append("📤 Sent: \(text)")
                }
            }
        }
    }

    // サーバーから受信
    private func receive() {
        guard let webSocketTask = webSocketTask else {
            return  // 切断済みなら抜ける
        }

        webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error as NSError):
                if error.domain == NSPOSIXErrorDomain && error.code == 57 {
                    print("ℹ️ Socket already closed") //切断後のエラーを無視する
                    return
                } else {
                    print("❌ Receive error:", error)
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.messages.append("📥 Received: \(text)")
                    }
                default:
                    break
                }
            }
            self?.receive()  // 再帰的に呼び出す
        }
    }

    // 通信終了（切断）
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        print("🔌 Disconnected from server")
    }
}

