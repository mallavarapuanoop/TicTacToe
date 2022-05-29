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
                            
                            
                            //computer Move
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerPosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                            }
                            
                        }
                    }
                }
                
                Spacer()
                
            }.padding(5)
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
    
    func isWinConditionMet(for moves: [Move?]) -> Bool {
        let winProbabilities = [[0,1,2], [1,2,3], [2,3,4], [3,4,5], [4,5,6], [5,6,7], [6,7,8], [0,4,8], [2,4,6]]
        
        
        return true
    }
}


enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    
    var indicator: String {
        player == .human ? "xmark" : "circle"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

