//
//  ContentView.swift
//  TicTacToe
//
//  Created by Arif Rahman Sidik on 05/05/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let columns : [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @State private var moves: [move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem : AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { index in
                        ZStack {
                            Circle()
                                .foregroundColor(.blue).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                            Image(systemName: moves[index]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: index) { return }
                            //For moves change icon
                            moves[index] = move(player: .human, boredIndex: index)
                            
                                //check for win condition or draw
                            if checkWinCondition(for: .human, in: moves) {
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameBoardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                
                                moves[computerPosition] = move(player: .computer, boredIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                            
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: resetGame))
            })
        }

    }
    
    func isSquareOccupied(in moves: [move?], forIndex index : Int) -> Bool{
        //$0 means for each indivieal element in array
        return moves.contains(where: { $0?.boredIndex == index})
    }
    
    func determineComputerMovePosition(in move: [move?]) -> Int {
        
        //If AI can win, then win
        
        //if ai cannot win, then block
        
        // if ai cannnot block, then take middle square
        
        // if ai cannot take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
            
        while isSquareOccupied(in: move, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player : Player, in moves : [move?]) -> Bool{
        let winPattern : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boredIndex})
        
        for pattern in winPattern where pattern.isSubset(of : playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves : [move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

// Whose move
// Where move
struct move {
    let player : Player
    let boredIndex : Int
    
    var indicator : String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
