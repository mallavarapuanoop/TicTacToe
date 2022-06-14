//
//  HomeScreenView.swift
//  TicTacToe
//
//  Created by Anoop Mallavarapu on 5/31/22.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Spacer()
                Text("Hello Welcome To \nTicTacToe")
                    .font(.largeTitle)
                
                Text("\nNumber of Players")
                
                HStack {
                    Spacer()
                    NavigationLink(destination: GameView()) {
                        Text("Single Player")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: GameView()) {
                        Text("Multi Players")
                    }
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            .padding()
        }
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
