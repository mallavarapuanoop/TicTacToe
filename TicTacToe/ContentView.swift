//
//  ContentView.swift
//  TicTacToe
//
//  Created by Anoop Mallavarapu on 5/29/22.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var moves: [Move?] = Array(repeating: nil, count: 9)
    @State var isBoardDisabled: Bool = false
    
    var gameType: GameType?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Tic Tac Toe")
                    .font(.largeTitle).foregroundColor(.red)
                    .padding(10)
                
                HStack {
                    Spacer()
                    Text("Player 1\n score:\n 10")
                        .font(.title).frame(alignment: .center)
                    Spacer()
                    Text("Player 2\n score:\n 2")
                        .font(.title).frame(alignment: .center)
                    Spacer()
                }
                
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                                .foregroundColor(.red).opacity(0.5)
                            
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            
                            //Player move
                            if isSquareOccupied(in: moves, for: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            isBoardDisabled = true
                            
                            if isWinConditionMet(for: .human, for: moves) {
                                print("Player Won")
                                return
                            }
                            
                            if checkForDrawCondition(in: moves) {
                                print("Its a Draw, Try again")
                                return
                            }
                            
                            //computer Move
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerPosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                
                                if isWinConditionMet(for: .computer, for: moves) {
                                    print("Computer Won")
                                    return
                                }
                                
                                if checkForDrawCondition(in: moves) {
                                    print("Its a Draw, Try again")
                                    return
                                }
                                
                                isBoardDisabled = false
                            }
                        }
                    }
                }
                .disabled(isBoardDisabled)
                
                Spacer()
                
                Button("Reset") {
                    resetGame()
                }
                Spacer()
            }
            .padding(5)
        }
    }
    
    
    func isSquareOccupied(in moves: [Move?], for index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerPosition(in moves: [Move?]) -> Int {
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
        
        print("\(player.rawValue): \(playerPositions)")
        
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


enum Player: String {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    let gameType: GameType? = nil
    
    
    var indicator: String {
        player == .human ? "xmark" : "circle"
    }
    
    var isMultiPlayer: Bool {
        guard let gameType = gameType else {
            return false
        }

        return gameType == .multiPlayer
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


public enum GameType: String {
    case singlePlayer, multiPlayer
}


//player 1 chances: 0 2 4 6 8
//player 2 chances: 1 3 5 7
