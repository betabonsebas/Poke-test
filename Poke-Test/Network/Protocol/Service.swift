//
//  Service.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 22/10/23.
//

import Combine
import Foundation

protocol Service {
  associatedtype Entity
  associatedtype ResultEntity
  
  var baseURL: String { get }
  func getAll(with page: Int, limit: Int) -> AnyPublisher<ResultEntity, Error>?
  func getItem(_ id: String) -> AnyPublisher<Entity, Error>?
}
