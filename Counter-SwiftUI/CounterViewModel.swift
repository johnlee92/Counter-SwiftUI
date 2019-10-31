//
//  CounterViewModel.swift
//  Counter-SwiftUI
//
//  Created by 이재현 on 2019/10/30.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
  
  private var cancellables = Set<AnyCancellable>()
  
  enum Action {
    case increase
    case decrease
  }
  
  enum Mutation {
    case increaseValue
    case decreaseValue
    case setLoading(Bool)
  }
  
  // MARK: Input
  
  let action = PassthroughSubject<Action, Never>()
  
  // MARK: Output
  
  @Published var value: Int
  @Published var isLoading: Bool
  
  init() {
    self.value = 0
    self.isLoading = false
    bindInput()
  }
  
  private func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
    switch action {
    case .increase:
      let firstConcat = Publishers.Concatenate(
        prefix: Just(Mutation.setLoading(true)),
        suffix: Just(Mutation.increaseValue)
          .delay(for: .seconds(1), scheduler: RunLoop.main)
      )
      let secondConcat = Publishers.Concatenate(
        prefix: firstConcat,
        suffix: Just(Mutation.setLoading(false))
      )
      return secondConcat
        .eraseToAnyPublisher()
      
    case .decrease:
      let firstConcat = Publishers.Concatenate(
        prefix: Just(Mutation.setLoading(true)),
        suffix: Just(Mutation.decreaseValue)
          .delay(for: .seconds(1), scheduler: RunLoop.main)
      )
      let secondConcat = Publishers.Concatenate(
        prefix: firstConcat,
        suffix: Just(Mutation.setLoading(false))
      )
      return secondConcat
        .eraseToAnyPublisher()
    }
  }
  
  private func handle(mutation: Mutation) {
    switch mutation {
    case .increaseValue:
      self.value += 1
    case .decreaseValue:
      self.value -= 1
    case let .setLoading(isLoading):
      self.isLoading = isLoading
    }
  }
  
  private func bindInput() {
    mutationPublisher.sink { mutation in
      self.handle(mutation: mutation)
    }
    .store(in: &cancellables)
  }
  
  private var mutationPublisher: AnyPublisher<Mutation, Never> {
    action
      .flatMap { action -> AnyPublisher<Mutation, Never> in
        return self.mutate(action: action)
      }
      .eraseToAnyPublisher()
  }
}

extension Cancellable {
  func store(in collection: inout Set<AnyCancellable>) {
    guard let cancellable = self as? AnyCancellable else { return }
    collection.insert(cancellable)
  }
}
