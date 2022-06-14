//
//  ContentView.swift
//  TicTacToe
//
//  Created by Anoop Mallavarapu on 5/29/22.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel = GameViewModel()
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Tic Tac Toe")
                    .font(.largeTitle).foregroundColor(.red)
                    .padding(10)
                Spacer()
                Text("level : \(String(viewModel.level.rawValue).firstUppercased)")
                HStack(spacing: 15) {
                    Button("Easy") {
                        viewModel.level = .easy
                    }
                    Button("Medium") {
                        viewModel.level = .medium
                    }
                    Button("Hard") {
                        viewModel.level = .hard
                    }
                }
                
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                                .foregroundColor(.red).opacity(0.5)
                            
                            
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.processMove(for: i)
                        }
                    }
                }
                .disabled(viewModel.isBoardDisabled)
                
                Spacer()
                
                Button("Reset") {
                    viewModel.resetGame()
                }
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonText, action: {
                    viewModel.resetGame()
                }))
            })
        }
    }
}

enum GameLevel: String {
    case easy, medium, hard
}

enum Player: String {
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
        GameView()
    }
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
