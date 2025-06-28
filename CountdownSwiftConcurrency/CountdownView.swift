//
//  CountdownView.swift
//  CountdownSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import SwiftUI

struct CountdownView: View {
    @State private var remainingSeconds: Int = 10
    @State private var isRunning = false
    @State private var message = ""
    @State private var countdownTask: Task<Void, Never>? = nil
    
    let initialSeconds = 10
    
    var body: some View {
        VStack(spacing: 20) {
            Text("残り: \(remainingSeconds) 秒")
                .font(.largeTitle)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.green)
            }
            
            HStack {
                Button(action: startCountdown) {
                    Text("開始")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isRunning || remainingSeconds <= 0)
                
                Button(action: cancelCountdown) {
                    Text("キャンセル")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isRunning)
            }
        }
        .padding()
    }
    
    func startCountdown() {
        isRunning = true
        message = ""
        
        countdownTask = Task {
            do {
                try await countDown()
                if remainingSeconds == 0 {
                    message = "カウントダウン終了！"
                }
            } catch {
                message = "キャンセルされました"
            }
            isRunning = false
        }
    }
    
    func cancelCountdown() {
        countdownTask?.cancel()
        countdownTask = nil
    }
    
    func countDown() async throws {
        while remainingSeconds > 0 {
            try Task.checkCancellation()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            remainingSeconds -= 1
        }
    }
}

#Preview {
    CountdownView()
}
