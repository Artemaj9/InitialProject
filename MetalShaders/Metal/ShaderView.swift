//
//  Flicker.swift
//

import SwiftUI

struct ShaderView: View {
  var effect: String = "gradientShader"
  
  var body: some View {
    ZStack {
      MetalViewRepresentable(effect: effect)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

#Preview {
  ShaderView()
}
