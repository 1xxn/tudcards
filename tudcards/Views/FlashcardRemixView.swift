//
//  FlashcardRemixView.swift
//  tudcards
//
//  Created by Leon on 17.07.23.
//

import Foundation
import SwiftUI
import CoreHaptics

struct FlashcardRemixView: View {
    @State var flashcards: [Flashcard]
    @State private var currentIndex = 0
    @State private var translation: CGSize = .zero
    @State private var swipeDirection: SwipeDirection = .none
    @State private var isRemixMode = false
    @State private var isLoopEnabled = false
    @State private var hapticEngine: CHHapticEngine?
    @State var categoryViewModel: CategoryViewModel
    
    private enum SwipeDirection {
        case left, right, none
    }

    var body: some View {
        VStack {
            if currentIndex < flashcards.count {
                FlashcardDetailView(flashcard: flashcards[currentIndex], isLoopEnabled: isLoopEnabled)
                    .offset(x: translation.width, y: translation.height)
                    .rotationEffect(rotationAngle(for: translation))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                translation = value.translation
                                swipeDirection = swipeDirection(for: translation)
                            }
                            .onEnded { value in
                                if abs(translation.width) > 100 {
                                    handleSwipe()
                                } else {
                                    resetCardPosition()
                                }
                            }
                    )
                    .animation(.spring())
                    .overlay(swipeOverlay(for: swipeDirection))
            } else {
                Text("No more flashcards")
            }
            
            Toggle(isOn: $isLoopEnabled) {
                Text("Enable Loop")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(2)
        }
        .onChange(of: isLoopEnabled) { enabled in
            if enabled && currentIndex >= flashcards.count {
                currentIndex = 0
                resetCardPosition()
            }
        }
        .onAppear {
            prepareHaptics()
        }
        .onDisappear {
            stopHaptics()
        }
    }
    
    private func handleSwipe() {
        if swipeDirection == .left {
            print("Marked as wrong")
            giveFeedbackForSwipe(left: true)
            categoryViewModel.markFlashcard(flashcards[currentIndex], as: false)
        } else if swipeDirection == .right {
            print("Marked as right")
            giveFeedbackForSwipe(left: true)
            categoryViewModel.markFlashcard(flashcards[currentIndex], as: true)
        }
        currentIndex += 1
        
        if currentIndex >= flashcards.count {
                if isLoopEnabled {
                    currentIndex = 0
                    flashcards.shuffle() // Shuffle the flashcards when reaching the end
                } else {
                    currentIndex = flashcards.count // Set the currentIndex to prevent swiping beyond the end
                }
            }
            
        resetCardPosition()
    }
    
    private func resetCardPosition() {
        withAnimation {
            translation = .zero
            swipeDirection = .none
        }
    }
    
    private func rotationAngle(for translation: CGSize) -> Angle {
        let rotationAngle: Double = Double(translation.width / 20)
        return Angle(degrees: rotationAngle)
    }
    
    private func swipeDirection(for translation: CGSize) -> SwipeDirection {
        if translation.width < 0 {
            return .left
        } else if translation.width > 0 {
            return .right
        } else {
            return .none
        }
    }
    
    private func swipeOverlay(for direction: SwipeDirection) -> some View {
        var color: Color
        var imageName: String
        switch direction {
        case .left:
            color = .red
            imageName = "xmark"
        case .right:
            color = .green
            imageName = "checkmark"
        case .none:
            return AnyView(EmptyView())
        }
        
        return AnyView(
            Image(systemName: imageName)
                .font(.system(size: 100))
                .foregroundColor(color)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .padding(10)
                )
                .padding()
        )
    }


    
    private func giveFeedbackForSwipe(left: Bool) {
        guard let hapticEngine = hapticEngine else { return }
        
        let intensity = left ? CHHapticEventParameter(parameterID: .hapticIntensity, value: 1) : CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Haptic feedback failed: \(error)")
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic feedback failed to start: \(error)")
        }
    }
    
    private func stopHaptics() {
        hapticEngine?.stop(completionHandler: { _ in
            hapticEngine = nil
        })
    }
}
