//
//  ActivityIndicatorView.swift
//  Counter-SwiftUI
//
//  Created by 이재현 on 2019/10/30.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
  
  @Binding var isAnimating: Bool
  
  let hidesWhenStopped: Bool
  
  let style: UIActivityIndicatorView.Style
  
  func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: style)
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    
    if hidesWhenStopped && !isAnimating {
      uiView.isHidden = true
    } else {
      uiView.isHidden = false
    }
  }
}
