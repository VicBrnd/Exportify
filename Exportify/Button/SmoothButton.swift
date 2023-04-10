//
//  SmoothButton.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import SwiftUI

class SmoothButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color
    
    init(backgroundColor: Color, textColor: Color) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
            .foregroundColor(textColor)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring())
    }
}
