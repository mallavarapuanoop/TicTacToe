//
//  AlertView.swift
//  TicTacToe
//
//  Created by Anoop Mallavarapu on 5/31/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonText: Text
}


struct AlertContext {
    static let playerWin   = AlertItem(title: Text("You Win!!!"), message: Text("you are smart!!!!"), buttonText: Text("Try Again"))
    
    static let computerWin   = AlertItem(title: Text("You Lost!!!"), message: Text("Super computer won this time"), buttonText: Text("Try Again"))
    
    static let draw   = AlertItem(title: Text("Its a Draw"), message: Text("Play Smart and try to win"), buttonText: Text("Try Again"))
}
