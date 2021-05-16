//
//  Alerts.swift
//  TicTacToe
//
//  Created by Arif Rahman Sidik on 06/05/21.
//

import Foundation
import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    var title : Text
    var message : Text
    var buttonTitle : Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win"), message: Text ("You are so smarth, you beat your own AI"), buttonTitle: Text("Hell Yeah"))
    
    static let computerWin = AlertItem(title: Text("You lost"), message: Text ("You programmed awesome AI"), buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"), message: Text ("You program good AI"), buttonTitle: Text("Try Again"))
    
}
