//
//  AnimatedLoading.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import SwiftUI

struct AnimatedLoadingDesign {
    let background: Color
    let circleOnColor: Color
    let circleOffColor: Color
    let textDown: TextualDesign
    let textUp: TextualDesign
    
    static var normal: AnimatedLoadingDesign {
        AnimatedLoadingDesign(
            background: .black.opacity(0.8),
            circleOnColor: .yellow,
            circleOffColor: .orange,
            textDown: TextualDesign(
                color: .yellow,
                font: .title.bold()
            ),
            textUp: TextualDesign(
                color: .orange,
                font: .title.bold()
            ))
    }
}

struct AnimatedLoadingView: View {
    @State var isAnimating: Bool = false
    let design: AnimatedLoadingDesign
    let message: String
    @State var shrinkAnimation: Bool = false
    init(message: String, design: AnimatedLoadingDesign = .normal) {
        self.message = message
        self.design = design
    }
    
    
    
    var body: some View {
        ZStack {
            if isAnimating {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(
                                shrinkAnimation ? design.circleOnColor : design.circleOffColor
                            )
                            .frame(
                                width: shrinkAnimation ? 50 : 150,
                                height: shrinkAnimation ? 50 : 150
                            )

                        ForEach(0..<8) { index in
                            Circle()
                                .foregroundColor(
                                    shrinkAnimation ? design.circleOnColor : design.circleOffColor
                                )
                                .frame(
                                    width: shrinkAnimation ? 10 : 20,
                                    height: shrinkAnimation ? 10 : 20
                                )
                                .offset(y: shrinkAnimation ? -40 : -60)
                                .rotationEffect(.degrees(Double(index) * 45))
                                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                .animation(nil, value: isAnimating)
                        }
                    }
                    .frame(
                        width: shrinkAnimation ? 80 : 180,
                        height: shrinkAnimation ? 80 : 180
                    )
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true)
                        ) {
                            shrinkAnimation.toggle()
                        }
                    }

                    Text("Loading...")
                        .font(
                            shrinkAnimation ? design.textDown.font : design.textUp.font
                        )
                        .foregroundColor(
                            shrinkAnimation ? design.textDown.color : design.textUp.color
                        )
                        .padding(.top, 16)
                }
            }
        }
        .onAppear() {
            withAnimation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview
struct AnimatedLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedLoadingView(
            message: "Hello"
        )
    }
}
