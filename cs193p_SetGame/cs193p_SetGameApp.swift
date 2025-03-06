//
//  cs193p_SetGameApp.swift
//  cs193p_SetGame
//
//  Created by LGiki on 2025/2/28.
//

import SwiftUI

@main
struct cs193p_SetGameApp: App {
    @StateObject var basicSetGameModel: BasicSetGame  = BasicSetGame()
    
    var body: some Scene {
        WindowGroup {
            BasicSetGameView(basicSetGameModel: basicSetGameModel)
        }
    }
}
