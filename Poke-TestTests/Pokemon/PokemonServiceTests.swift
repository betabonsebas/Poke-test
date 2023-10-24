//
//  PokemonService.swift
//  Poke-TestTests
//
//  Created by Sebastian Bonilla on 23/10/23.
//

import Combine
import XCTest
@testable import Poke_Test

final class PokemonServiceTests: XCTestCase {
  
  private var subscriptions: Set<AnyCancellable> = []
  var service: PokemonService?
  var errorService: PokemonService?
  
  override func setUpWithError() throws {
    service = PokemonService(baseURL: "https://pokeapi.co/api/v2/pokemon")
    errorService = PokemonService(baseURL: "https://www.google.com")
  }
  
  override func tearDownWithError() throws {
    service = nil
    errorService = nil
  }
  
  func testInit() throws {
    XCTAssertNotNil(service)
    XCTAssertEqual(service?.baseURL, "https://pokeapi.co/api/v2/pokemon")
  }
  
  func testGetAll() throws {
    let expectation = XCTestExpectation(description: "get all completion expectation")
    let limit = 5
    service?.getAll(with: 1, limit: limit)?
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let failure):
          XCTAssert(false, failure.localizedDescription)
        }
        
      }, receiveValue: { results in
        expectation.fulfill()
        XCTAssertEqual(results.results.count, limit)
      })
      .store(in: &subscriptions)
    
    wait(for: [expectation])
  }
  
  func testGetAllWithWrongURL() throws {
    let expectation = XCTestExpectation(description: "get all error completion expectation")
    let limit = 5
    errorService?.getAll(with: 1, limit: limit)?
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        
        switch completion {
        case .finished:
          XCTAssert(false, "Service finish successfully")
        case .failure(let failure):
          XCTAssert(true, failure.localizedDescription)
          expectation.fulfill()
        }
        
      }, receiveValue: { results in
        XCTAssert(false, "Service get pokemons")
      })
      .store(in: &subscriptions)
    
    wait(for: [expectation])
  }
  
  func testGetItem() throws {
    let expectation = XCTestExpectation(description: "get Item completion expectation")
    let pokemonName = "pikachu"
    service?.getItem(pokemonName)?
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let failure):
          XCTAssert(false, failure.localizedDescription)
        }
        
      }, receiveValue: { pokemon in
        XCTAssertEqual(pokemon.name, pokemonName)
        expectation.fulfill()
      })
      .store(in: &subscriptions)
    
    wait(for: [expectation])
  }
  
  func testGetItemWithWrongURL() throws {
    let expectation = XCTestExpectation(description: "get Item completion error expectation")
    let pokemonName = "pikachu"
    errorService?.getItem(pokemonName)?
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          XCTAssert(false, "service finish successfully")
        case .failure(let failure):
          XCTAssert(true, failure.localizedDescription)
          expectation.fulfill()
        }
      }, receiveValue: { pokemon in
        XCTAssert(false, "service get pokemon successfully")
      })
      .store(in: &subscriptions)
    
    wait(for: [expectation])
  }
}
