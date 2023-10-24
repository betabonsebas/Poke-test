//
//  Pokemon.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 22/10/23.
//

import Foundation

struct PokemonResults: Decodable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Result]
}

struct Result: Decodable {
  let name: String
  let url: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case url
  }
}

struct PokemonAbility: Decodable {
  let ability: Result
  
  enum CodingKeys: String, CodingKey {
    case ability
  }
}

struct PokemonType: Decodable {
  let type: Result
  
  enum CodingKeys: String, CodingKey {
    case type
  }
}

struct PokemonMove: Decodable {
  let move: Result
  
  enum CodingKeys: String, CodingKey {
    case move
  }
}

struct Pokemon: Decodable {
  let id: Int
  let name: String
  let image: String?
  let types: [PokemonType]?
  let abilities: [PokemonAbility]?
  let moves: [PokemonMove]?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case image
    case abilities
    case types
    case sprites
    case moves
  }
  
  enum TypeKeys: String, CodingKey {
    case type
  }
  
  enum SpriteKeys: String, CodingKey {
    case fronDefault = "front_default"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    
    let spritesContainer = try container.nestedContainer(keyedBy: SpriteKeys.self, forKey: CodingKeys.sprites)
    self.image = try spritesContainer.decodeIfPresent(String.self, forKey: .fronDefault)
    
    self.types = try container.decodeIfPresent([PokemonType].self, forKey: .types)
    self.abilities = try container.decodeIfPresent([PokemonAbility].self, forKey: .abilities)
    self.moves = try container.decodeIfPresent([PokemonMove].self, forKey: .moves)
  }
}
