//
//  GameViewModel.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import Foundation
import SpriteKit

class GameViewModel {
    
    private var startTime: Date = Date()
    private var timer: Timer?
    
    private(set) var moves: Int = 0
    
    var onTimeUpdate: ((String) -> Void)?
    var onMovesUpdate: ((Int) -> Void)?
    
    func incrementMoves() {
        moves += 1
        onMovesUpdate?(moves)
    }
    
    func resetMoves() {
        moves = 0
        onMovesUpdate?(moves)
    }
    
    func startTimer() {
        startTime = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func updateElapsedTime() {
        let elapsed = Int(Date().timeIntervalSince(startTime))
        let minutes = elapsed / 60
        let seconds = elapsed % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        onTimeUpdate?(timeString)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func generateCardData() -> [CardData] {
        let imageNames = (1...8).map { "card\($0)" }
        let paired = (imageNames + imageNames).shuffled()
        return paired.enumerated().map { CardData(id: $0.offset, imageName: $0.element) }
    }
}

