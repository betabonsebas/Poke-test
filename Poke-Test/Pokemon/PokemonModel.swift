//
//  PokemonAggregator.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 22/10/23.
//

import Combine
import Foundation

@MainActor
class PokemonModel: ObservableObject {
  
  private var subscriptions: Set<AnyCancellable> = []
  
  @Published var results: [PokemonDetail] = []
  @Published var searchText: String = String()
  private let service: PokemonService
  
  init(baseURL: String) {
    self.service = PokemonService(baseURL: baseURL)
    fetchListPokemons()
    $searchText
      .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
      .removeDuplicates()
      .compactMap { $0 }
      .sink { (_) in } receiveValue: { [weak self] searchField in
        if searchField.isEmpty {
          self?.fetchListPokemons()
          return
        }
        self?.fetchPokemonDetails(from: [Result(name: searchField.lowercased(), url: "")])
      }
      .store(in: &subscriptions)
  }
  
  private func fetchListPokemons() {
    service.getAll(with: 1, limit: 50)?
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        break
      case .failure(let failure):
        debugPrint(failure)
      }
    }, receiveValue: { [weak self] result in
      self?.fetchPokemonDetails(from: result.results)
    })
    .store(in: &subscriptions)
  }
  
  private func fetchPokemonDetails(from results: [Result]) {
    let pokemonPublishers = results.compactMap { service.getItem($0.name) }
    Publishers.MergeMany(pokemonPublishers).collect()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let failure):
          debugPrint(failure)
        }
      }, receiveValue: { value in
        self.results = value.compactMap{ PokemonDetail(pokemon: $0) }
      })
      .store(in: &subscriptions)
  }
}
