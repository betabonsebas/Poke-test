//
//  PokemonDetail.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 23/10/23.
//

import Combine
import Foundation

class PokemonDetail: ObservableObject {
  private let pokemon: Pokemon
  
  var id: Int {
    pokemon.id
  }
  
  var name: String {
    pokemon.name.capitalized
  }
  
  var image: URL? {
    guard let image = pokemon.image else { return nil }
    return URL(string: image)
  }
  
  var types: [PokemonType]? {
    pokemon.types
  }
  
  init(pokemon: Pokemon) {
    self.pokemon = pokemon
  }
  
  var abilitiesString: String {
    pokemon.abilities?.reduce("", {$0 + "," + $1.ability.name}).trimmingCharacters(in: .punctuationCharacters) ?? ""
  }
  
  var typesString: String {
    pokemon.types?.reduce("", {$0 + "," + $1.type.name}).trimmingCharacters(in: .punctuationCharacters) ?? ""
  }
  
  var movesString: String {
    pokemon.moves?.reduce("", {$0 + "\n" + "* \($1.move.name)"}).trimmingCharacters(in: .newlines) ?? ""
  }
}


extension PokemonDetail: Hashable {
  static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
  }
}

extension PokemonType: Hashable {
  static func == (lhs: PokemonType, rhs: PokemonType) -> Bool {
    lhs.type.name == rhs.type.name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(type.name)
    hasher.combine(type.url)
  }
}

