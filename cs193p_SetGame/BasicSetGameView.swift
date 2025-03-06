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

struct CardView: View {
    var card: SetGame<
        BasicSetGame.NumberOfShapes,
        BasicSetGame.CardShape,
        BasicSetGame.CardShading,
        BasicSetGame.CardColor
    >.Card
    
    private var numberOfShapes: Int {
        switch (card.numberOfShapes) {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
    
    private var cardColor: Color {
        switch (card.color) {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    @ViewBuilder
    private var cardShape: some View {
        switch (card.shape) {
        case .diamond:
            if card.shading == .open {
                Diamond().stroke(lineWidth: 2)
            } else {
                Diamond()
            }
        case .oval:
            if card.shading == .open {
                Capsule().stroke(lineWidth: 2)
            } else {
                Capsule()
            }
        case .squiggle:
            if card.shading == .open {
                Rectangle().stroke(lineWidth: 2)
            } else {
                Rectangle()
            }
        }
    }
    
    var body: some View {
        let basicRoundedRectangle = RoundedRectangle (cornerRadius: 12)
        ZStack {
            basicRoundedRectangle
                .fill(card.isSelected
                      ? (card.isMatched
                             ? .mint
                             : .accentColor)
                      : Color(UIColor.systemBackground)
                )
                .opacity(card.isSelected
                         ? 0.25
                         : 1.0
                )
                .shadow(
                    color: card.isMatched
                        ? .yellow
                        : .accentColor,
                    radius: card.isSelected
                        ? 4
                        : 0
                )
            
            basicRoundedRectangle
                .stroke(lineWidth: card.isSelected ? 3 : 1)
                .foregroundColor(card.isSelected
                                 ? (card.isMatched
                                    ? .mint
                                    : .accentColor)
                                 : Color(UIColor.label)
                )
            
            GeometryReader { geometry in
                let segmentHeight = geometry.size.height / 3
                VStack (alignment: .center) {
                    ForEach (0..<numberOfShapes, id: \.self) {_ in
                        cardShape
                            .frame(maxWidth: .infinity, maxHeight: segmentHeight)
                            .opacity(card.shading == .striped ? 0.35 : 1.0)
                    }
                }
                .frame(maxHeight: geometry.size.height)
            }
            .padding(8)
            .foregroundColor(cardColor)
            
        }
        .scaleEffect(card.isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: card.isSelected)
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
