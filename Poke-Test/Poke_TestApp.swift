//
//  Poke_TestApp.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 14/06/23.
//

import SwiftUI

@main
struct Poke_TestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(PokemonModel(baseURL: "https://pokeapi.co/api/v2/pokemon"))
        }
    }
}
