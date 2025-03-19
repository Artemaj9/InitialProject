//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      ShaderView()
        .ignoresSafeArea()
      ShaderView(effect: "gradShader")
        .ignoresSafeArea()
        .blendMode(.hardLight)
      
      Button {
        
      } label: {
        RoundedRectangle(cornerRadius: 20)
          .fill(.gray)
          .frame(width: 200, height: 50)
          .overlayMask {
            ShaderView()
              .opacity(0.5)
          }
          .overlay {
            Text("Hello")
              .font(.largeTitle)
              .foregroundStyle(.white)
              .padding()
          }
      }
    }
  }
}

extension View {
  func overlayMask(@ViewBuilder content: () -> some View) -> some View {
    self
      .overlay(content())
      .mask(self)
  }
}

#Preview {
  ContentView()
}
