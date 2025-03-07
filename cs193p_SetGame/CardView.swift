//
//  CardView.swift
//  cs193p_SetGame
//
//  Created by LGiki on 2025/3/7.
//

import SwiftUI

struct CardView: View {
    typealias Card = SetGame<
        BasicSetGame.NumberOfShapes,
        BasicSetGame.CardShape,
        BasicSetGame.CardShading,
        BasicSetGame.CardColor
    >.Card
    
    var card: Card
    
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

struct CardView_Previews: PreviewProvider {
    typealias Card = SetGame<
        BasicSetGame.NumberOfShapes,
        BasicSetGame.CardShape,
        BasicSetGame.CardShading,
        BasicSetGame.CardColor
    >.Card
    
    static var previews: some View {
        CardView(card: Card(
            numberOfShapes: .three,
            shape: .diamond,
            shading: .striped,
            color: .purple,
            id: UUID()
        ))
        .padding()
    }
}
