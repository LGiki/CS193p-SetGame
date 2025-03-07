//
//  ContentView.swift
//  cs193p_SetGame
//
//  Created by LGiki on 2025/2/28.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var diamond = Path()
        diamond.move(to: CGPoint(x: rect.midX, y: 0))
        diamond.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        diamond.addLine(to: CGPoint(x: 0, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: 0))
        return diamond
    }
}

struct BasicSetGameView: View {
    @ObservedObject var basicSetGameModel: BasicSetGame
    @State private var isNewGameConfirmDialogVisible: Bool = false
    
    var body: some View {
        VStack {
            AspectVGrid (basicSetGameModel.cards, aspectRatio: 3/4) { card in
                CardView(card: card)
                    .padding(basicSetGameModel.cards.count > 30 ? 4 : 8)
                    .onTapGesture {
                        basicSetGameModel.choose(card)
                    }
            }
            .animation(.easeInOut, value: basicSetGameModel.cards)
            .frame(maxHeight: .infinity)
            
            HStack {
                Button(action: {
                    basicSetGameModel.dealThreeMoreCards()
                }) {
                    Label("Deal 3 More Cards", systemImage: "rectangle.stack.badge.plus")
                }
                .disabled(basicSetGameModel.remainCards == 0)
                
                Spacer()
                
                Button(action: {
                    isNewGameConfirmDialogVisible = true
                }) {
                    Label("New Game", systemImage: "arrow.clockwise")
                }
                .confirmationDialog("Start a new game", isPresented: $isNewGameConfirmDialogVisible) {
                    Button("Confirm", role: .destructive) {
                        basicSetGameModel.newGame()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Start a new game?")
                }
            }
            .padding()
            
        }
        .padding()
    }
}

struct BasicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let basicSetGameModel: BasicSetGame = BasicSetGame()
        BasicSetGameView(basicSetGameModel: basicSetGameModel)
    }
}
