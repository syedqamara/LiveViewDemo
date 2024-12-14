//
//  CircularProgressView.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import SwiftUI

public struct CircularProgressViewDesign {
    public let background: Color
    public let text: TextualDesign
    public let circleEmpty: TextualDesign
    public let circleFill: TextualDesign
    
    public static var normal: CircularProgressViewDesign {
        CircularProgressViewDesign(
            background: .yellow.opacity(0.3),
            text: TextualDesign(
                color: .orange,
                font: .title3.bold()
            ),
            circleEmpty: TextualDesign(
                color: .yellow,
                font: .body
            ),
            circleFill: TextualDesign(
                color: .orange,
                font: .body
            )
        )
    }
    
}

struct CircularProgressView: View {
    let message: String
    var design: CircularProgressViewDesign
    @Binding var conversion: LivePhotoConversions?
    init(conversion: Binding<LivePhotoConversions?>, message: String, design: CircularProgressViewDesign = .normal) {
        self.message = message
        _conversion = conversion
        self.design = design
    }

    var body: some View {
        ZStack {
            // Background Circle
            if let progress = conversion?.progress {
                Circle()
                    .stroke(design.background, lineWidth: design.circleEmpty.font.lineWidth)

                // Progress Circle
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress) / 100)
                    .stroke(
                        design.circleFill.color,
                        style: StrokeStyle(
                            lineWidth: design.circleFill.font.lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90)) // Start progress from the top
                    .animation(.easeInOut, value: progress)

                // Percentage Label
                Text("\(progress)% \(message)")
                    .font(design.text.font)
                    .foregroundStyle(design.text.color)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Preview
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(conversion: .constant(nil), message: "Converting")
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
    }
}
