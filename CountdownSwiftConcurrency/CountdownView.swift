//
//  CountdownView.swift
//  CountdownSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import SwiftUI

struct CountdownView: View {
    @State private var remainingSeconds: Int = 10
    @State private var isRunning: Bool = false
    @State private var message: String = ""
    
    let initialSeconds = 10  // ← カウントダウン初期値
    
    var body: some View {
        VStack(spacing: 20) {
            Text("残り: \(remainingSeconds) 秒")
                .font(.largeTitle)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.green)
            }
            
            Button(action: {
                if !isRunning {
                    startCountdown()
                }
            }) {
                Text(isRunning ? "カウント中..." : "開始")
                    .padding()
                    .background(isRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isRunning)
        }
        .padding()
    }
    
    func startCountdown() {
        isRunning = true
        message = ""
        remainingSeconds = initialSeconds  // ← ✅ 再スタート時にリセット
        Task {
            await countDown(from: initialSeconds)  // ← ✅ 初期値を渡す
        }
    }
    
    func countDown(from seconds: Int) async {
        for sec in (0..<seconds).reversed() {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            remainingSeconds = sec
        }
        isRunning = false
        message = "カウントダウン終了！"
    }
}

#Preview {
    CountdownView()
}
