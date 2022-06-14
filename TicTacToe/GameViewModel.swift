//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Anoop Mallavarapu on 6/14/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    @Published var level: GameLevel = .easy
    
    func processMove(for i: Int) {
        
        //Player move
        if isSquareOccupied(in: moves, for: i) { return }
        moves[i] = Move(player: .human, boardIndex: i)
        isBoardDisabled = true
        
        if isWinConditionMet(for: .human, for: moves) {
            alertItem = AlertContext.playerWin
            return
        }
        
        if checkForDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        //computer Move
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let computerPosition = determineComputerPosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            if isWinConditionMet(for: .computer, for: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
            
            isBoardDisabled = false
        }
    }
    
    func isSquareOccupied(in moves: [Move?], for index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    //If AI can win, then win
    //If AI cant win, then block
    //If AI cant block, then take middle square
    //If AI cant take middle square, take random available square
    
    func determineComputerPosition(in moves: [Move?]) -> Int {
        //If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, for: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        
        //If AI cant win, then block
        if level == .medium || level == .hard {
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
            let humanPositions = Set(humanMoves.map { $0.boardIndex })
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(humanPositions)
                
                if winPositions.count == 1 {
                    let isAvailable = !isSquareOccupied(in: moves, for: winPositions.first!)
                    if isAvailable { return winPositions.first!}
                }
            }
        }
        
        //If AI cant block, then take middle square
        
        if level == .hard {
            let centerSquare = 4
            if !isSquareOccupied(in: moves, for: centerSquare) {
                return centerSquare
            }
        }
        
        //If AI cant take middle square, take random available square
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, for: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func isWinConditionMet(for player: Player, for moves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkForDrawCondition(in moves: [Move?]) -> Bool {
        moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isBoardDisabled = false
    }
}
