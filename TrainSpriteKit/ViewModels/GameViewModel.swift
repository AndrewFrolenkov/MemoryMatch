//
//  GameViewModel.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import Foundation
import SpriteKit

class GameViewModel {
    
    var cards: [CardModel] = []
    var firstFlippedCardIndex: Int? = nil
    
    private var startTime: Date = Date()
    private var timer: Timer?
    private var isPaused: Bool = false
    private var accumulatedTime: TimeInterval = 0
    
    private(set) var moves = 0 {
            didSet {
                onMovesUpdate?(moves)
            }
        }
    
    var onTimeUpdate: ((String) -> Void)?
    var onMovesUpdate: ((Int) -> Void)?
    
    var onMatch: ((Int, Int) -> Void)?
    var onMismatch: ((Int, Int) -> Void)?
    var onGameCompleted: (() -> Void)?
    var onFlipCard: ((Int) -> Void)?

    
    func handleCardTap(at index: Int) {
        guard !cards[index].isFlipped, !cards[index].isMatched else { return }
        
        cards[index].isFlipped = true
        onFlipCard?(index)
        
        if let firstIndex = firstFlippedCardIndex {
            moves += 1
            let secondIndex = index
            let firstImage = cards[firstIndex].imageName
            let secondImage = cards[secondIndex].imageName
            
            if firstImage == secondImage {
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
                firstFlippedCardIndex = nil
                onMatch?(firstIndex, secondIndex)
                
                if cards.allSatisfy({ $0.isMatched }) {
                    onGameCompleted?()
                }
            } else {
                firstFlippedCardIndex = nil
                onMismatch?(firstIndex, secondIndex)
            }
        } else {
            firstFlippedCardIndex = index
        }
    }
    
    
    func incrementMoves() {
        moves += 1
        onMovesUpdate?(moves)
    }
    
    func resetMoves() {
        moves = 0
        onMovesUpdate?(moves)
    }
    
    func startNewGame() {
        startTime = Date()
        accumulatedTime = 0
        startTimer()
    }

    func setPause(_ pause: Bool) {
        if pause {
            isPaused = true
            stopTimer()
            accumulatedTime += Date().timeIntervalSince(startTime)
        } else {
            isPaused = false
            startTime = Date()
            startTimer()
        }
    }

    func startTimer() {
        timer?.invalidate()
        updateElapsedTime()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    private func updateElapsedTime() {
        let elapsed = accumulatedTime + Date().timeIntervalSince(startTime)
        let totalSeconds = Int(elapsed)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
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

