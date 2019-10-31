//
//  ContentView.swift
//  Counter-SwiftUI
//
//  Created by 이재현 on 2019/10/30.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import SwiftUI

struct CounterView: View {
  @ObservedObject var viewModel: CounterViewModel
  
  var body: some View {
    VStack {
      ActivityIndicatorView(isAnimating: $viewModel.isLoading,
                            hidesWhenStopped: true,
                            style: .large)
      
      HStack(spacing: CGFloat(24.0)) {
        Button(action: {
          self.viewModel.action.send(.decrease)
        }) {
          Text("-")
            .font(.system(.largeTitle))
        }
        
        Text("\(viewModel.value)")
          .font(.system(.largeTitle))
          .multilineTextAlignment(.center)
        
        Button(action: {
          self.viewModel.action.send(.increase)
        }) {
          Text("+")
            .font(.system(.largeTitle))
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CounterView(viewModel: .init())
  }
}
