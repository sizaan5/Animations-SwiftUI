//
//  ContentView.swift
//  Animations
//
//  Created by Izaan Saleem on 02/02/2024.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount ), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var animationAmountPulse = 1.0
    @State private var animationAmount = 1.0
    @State private var animationAmount3D = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    @State private var isShowingRedAny = false
    
    let letters = Array("Hello SwiftUI")
    
    var body: some View {
        /*VStack {
            Button("") {
                //animationAmount += 1
            }
            .frame(width: 20, height: 20)
            //.padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            //.scaleEffect(animationAmount)
            //.blur(radius: (animationAmount - 1) * 3)
            //.animation(.spring(duration: 1, bounce: 0.9), value: animationAmount)
            .overlay(content: {
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmountPulse)
                    .opacity(2 - animationAmountPulse)
                    .animation(
                        .easeOut(duration: 1)
                        .delay(0.03)
                        .repeatForever(autoreverses: false),
                        //.repeatCount(3, autoreverses: true),
                        value: animationAmountPulse
                    )
            })
            .onAppear {
                animationAmountPulse = 2
            }
            Spacer()
            
            Stepper("Scale amount", value: $animationAmount.animation(
                .linear(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            .padding()
            
            Spacer()
            
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.indigo.gradient)
            .foregroundStyle(.white)
            .clipShape(.ellipse)
            .scaleEffect(animationAmount)
            
            
            Button("Rotate Me") {
                withAnimation(.spring(duration: 1, bounce: 0.5)) {
                    animationAmount3D += 360
                }
            }
            .padding(50)
            .background(.cyan.gradient)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(
                .degrees(animationAmount3D),
                                      axis: (x: 0.0, y: 1.0, z: 0.0)
            )
        }
        .background(.blue.gradient)*/
        Button("Tap me") {
            enabled.toggle()
        }
        .frame(width: 300, height: 60)
        .background(enabled ? .blue : .red)
        .foregroundStyle(.white)
        .animation(.default, value: enabled)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 10))
        .animation(.spring(duration: 1, bounce: 0.9), value: enabled)
        
        VStack {
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(.rect(cornerRadius: 10))
                .offset(dragAmount).gesture(
                    DragGesture()
                        .onChanged({ dragAmount = $0.translation })
                        .onEnded({ _ in 
                            withAnimation(.bouncy) {
                                dragAmount = .zero
                            }
                        })
                )
            HStack(spacing: 0) {
                ForEach(0..<letters.count, id: \.self) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(enabled ? .yellow : .red)
                        .offset(dragAmount)
                        .animation(.linear.delay((Double(num) / 20)), value: dragAmount)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ dragAmount = $0.translation })
                    .onEnded(
                        { _ in
                            withAnimation(.bouncy) {
                                dragAmount = .zero
                                enabled.toggle()
                            }
                        }
                    )
            )
            Button("Tap me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(.green.gradient)
                    .frame(width: 300, height: 200)
                    //.transition(.scale)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            ZStack {
                Rectangle()
                    .fill(.yellow)
                    .frame(width: 300, height: 200)
                if isShowingRedAny {
                    Rectangle()
                        .fill(.orange.gradient)
                        .frame(width: 300, height: 200)
                        //.transition(.scale)
                        .transition(.pivot)
                }
            }
            .onTapGesture {
                withAnimation {
                    isShowingRedAny.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
