//
//  BasicSetGame.swift
//  cs193p_SetGame
//
//  Created by LGiki on 2025/3/1.
//

import SwiftUI

class BasicSetGame: ObservableObject {
    enum NumberOfShapes: CaseIterable {
        case one
        case two
        case three
    }

    enum CardShape: CaseIterable {
        case diamond
        case oval
        case squiggle
    }

    enum CardShading: CaseIterable {
        case solid
        case striped
        case open
    }

    enum CardColor: CaseIterable {
        case red
        case green
        case purple
    }
    
    @Published private var setGame: SetGame<NumberOfShapes, CardShape, CardShading, CardColor>
    
    init() {
        self.setGame = SetGame()
    }
    
    var cards: Array<SetGame<NumberOfShapes, CardShape, CardShading, CardColor>.Card> {
        setGame.dealedCards
    }
    
    var remainCards: Int {
        setGame.remainCardCount
    }
    
    // MARK: - Intents
    func dealThreeMoreCards() {
        setGame.dealThreeMoreCard()
    }
    
    func newGame() {
        setGame = SetGame()
    }
    
    func choose(_ card: SetGame<NumberOfShapes, CardShape, CardShading, CardColor>.Card) {
        setGame.chooseCard(card)
    }
}
