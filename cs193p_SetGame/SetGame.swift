//
//  SetGame.swift
//  cs193p_SetGame
//
//  Created by LGiki on 2025/3/1.
//

import Foundation

struct SetGame<NumberOfShapes, Shape, Shading, Color> where NumberOfShapes: CaseIterable & Hashable, Shape: CaseIterable & Hashable, Shading: CaseIterable & Hashable, Color: CaseIterable & Hashable {
    private var allCards: Array<Card>
    private(set) var dealedCards: Array<Card>
    
    init() {
        allCards = []
        dealedCards = []
        for number in NumberOfShapes.allCases {
            for shape in Shape.allCases {
                for shading in Shading.allCases {
                    for color in Color.allCases {
                        allCards.append(
                            Card(
                                numberOfShapes: number,
                                shape: shape,
                                shading: shading,
                                color: color,
                                id: UUID()
                            )
                        )
                    }
                }
            }
        }
        allCards.shuffle()
        
        // Deal 12 cards on game start
        dealedCards = Array(allCards.prefix(12))
        allCards.removeFirst(12)
    }
    
    var remainCardCount: Int {
        allCards.count
    }
    
    private mutating func replaceMatchedCards(_ selectedCards: Array<Card>) {
        for selectedCard in selectedCards {
            if let index = dealedCards.firstIndex(where: { $0.id == selectedCard.id }) {
                if remainCardCount == 0 {
                    dealedCards.remove(at: index)
                } else {
                    dealedCards[index] = allCards.removeFirst()
                }
            }
        }
    }
    
    mutating func dealThreeMoreCard() {
        if remainCardCount == 0 {
            return
        }
        
        let selectedCards = dealedCards.filter { $0.isSelected }
        
        if selectedCards.count == 3 && isCardsMatch(selectedCards) {
            // repleace the selected cards if the selected cards make a Set
            replaceMatchedCards(selectedCards)
        } else {
            for _ in 0..<3 {
                if remainCardCount != 0 {
                    dealedCards.append(allCards.removeFirst())
                }
            }
        }
    }
    
    private mutating func unselectAllCards(_ cards: [Card]) {
        for card in cards {
            if let index = dealedCards.firstIndex(where: { $0.id == card.id }) {
                dealedCards[index].isSelected = false
            }
        }
    }

    
    mutating func chooseCard(_ card: Card) {
        guard let chosenCardIndex = dealedCards.firstIndex(where: { $0.id == card.id }) else { return }

        // selected cards without new selected card
        let selectedCards = dealedCards.filter { $0.isSelected }
    
        let isNewCardAlreadySelected = dealedCards[chosenCardIndex].isSelected
        
        if selectedCards.count == 3 {
            if isCardsMatch(selectedCards) {
                replaceMatchedCards(selectedCards)
                if !isNewCardAlreadySelected {
                    dealedCards[chosenCardIndex].isSelected = !dealedCards[chosenCardIndex].isSelected
                }
            } else {
                // unselect all selected card
                unselectAllCards(selectedCards)
                dealedCards[chosenCardIndex].isSelected = true
            }
        } else if selectedCards.count == 2 && !isNewCardAlreadySelected {
            dealedCards[chosenCardIndex].isSelected.toggle()
            
            let newSelectedCards = dealedCards.filter { $0.isSelected }
            if isCardsMatch(newSelectedCards) {
                for selectedCard in newSelectedCards {
                    if let selectedCardIndex = dealedCards.firstIndex(where: { $0.id == selectedCard.id }) {
                        dealedCards[selectedCardIndex].isMatched = true
                    }
                }
            }
        } else {
            dealedCards[chosenCardIndex].isSelected.toggle()
        }
    }
    
    private func isCardsMatch(_ cards: Array<Card>) -> Bool {
        guard cards.count == 3 else { return false }
            
        func isValidSet<T: Hashable>(_ keyPath: KeyPath<Card, T>) -> Bool {
            let values = Set(cards.map { $0[keyPath: keyPath] })
            return values.count == 1 || values.count == 3
        }
        
        return isValidSet(\.numberOfShapes) && isValidSet(\.shape) && isValidSet(\.shading) && isValidSet(\.color)
    }
    
    struct Card: Equatable, Identifiable {
        var isSelected: Bool = false
        var isMatched: Bool = false
        
        var numberOfShapes: NumberOfShapes
        var shape: Shape
        var shading: Shading
        var color: Color
        
        var id: UUID
    }
}
