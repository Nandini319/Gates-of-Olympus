//
//  GameView.swift
//  Gates of Olympus
//
//  Created by Nandini Vithlani on 06/10/23.

import SwiftUI

struct FallingElement: Identifiable {
    var id = UUID()
    var position: CGPoint
    var isTapped = false
}

struct GameView: View {
    @State private var elements: [FallingElement] = []
    @State private var score = 0
    @State private var isGameOver = false
    @State private var isShowingGameOverSheet = false
    var timerInterval: TimeInterval = 2.0

    let elementSize: CGFloat = 50
    let maxMissedBalls = 3 // Set the maximum number of missed balls
    let maxTouchedBottomBalls = 3 // Set the maximum number of balls that can touch the bottom

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ForEach(elements) { element in
                    if !element.isTapped {
                        Circle()
                            .fill(Color.red)
                            .frame(width: elementSize, height: elementSize)
                            .position(element.position)
                            .onTapGesture {
                                withAnimation {
                                    tapElement(element)
                                }
                            }
                            .transition(.opacity)
                            .zIndex(1.0)
                            .animation(Animation.linear(duration: timerInterval))
                    }
                }

                if isGameOver {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .position(x: geometry.size.width - 100, y: 50)
                }
            }
            .onAppear {
                startGameLoop(in: geometry)
            }
        }
        .sheet(isPresented: $isShowingGameOverSheet) {
            GameOverView(score: score, restartGame: restartGame)
        }
    }

    func startGameLoop(in geometry: GeometryProxy) {
        var timer: Timer?
        var missedBallCount = 0
        var ballsTouchedBottom = 0 // Keep track of balls that touched the bottom line

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
            guard !isGameOver else {
                timer?.invalidate()
                return
            }

            if !isGameOver {
                if missedBallCount < maxMissedBalls || ballsTouchedBottom < maxTouchedBottomBalls {
                    let randomX = CGFloat.random(in: 0...(max(0, geometry.size.width - self.elementSize)))
                    let element = FallingElement(position: CGPoint(x: randomX, y: -self.elementSize / 2))
                    elements.append(element)

                    DispatchQueue.main.asyncAfter(deadline: .now() + self.timerInterval) {
                        if !self.isGameOver {
                            self.fallingAction(in: geometry, missedBallCount: &missedBallCount, ballsTouchedBottom: &ballsTouchedBottom)
                        }
                    }
                } else {
                    endGame()
                }
            }
        }
        timer?.fire()
    }


    func fallingAction(in geometry: GeometryProxy, missedBallCount: inout Int, ballsTouchedBottom: inout Int) {
        var modifiedElements: [FallingElement] = []

        elements.forEach { element in
            if !isGameOver {
                var modifiedElement = element
                withAnimation(Animation.linear(duration: timerInterval)) {
                    modifiedElement.position.y = geometry.size.height + elementSize / 2
                }
                modifiedElements.append(modifiedElement)

                // Check if element has reached the bottom
                if modifiedElement.position.y > geometry.size.height + elementSize / 2 {
                    if !modifiedElement.isTapped {
                        // Ball was missed and hasn't been counted yet
                        missedBallCount += 1
                    } else {
                        // Ball touched the bottom line and hasn't been counted yet
                        ballsTouchedBottom += 1
                    }
                }
            }
        }

        // Check if the maximum missed balls count or maximum balls touching the bottom line is reached
        if missedBallCount >= maxMissedBalls || ballsTouchedBottom >= maxTouchedBottomBalls {
            endGame()
        }

        elements = modifiedElements
    }


    func tapElement(_ element: FallingElement) {
        if let index = elements.firstIndex(where: { $0.id == element.id }) {
            elements[index].isTapped = true
            score += 1
        }
    }

    func endGame() {
        isGameOver = true
        elements.removeAll()
        isShowingGameOverSheet = true
    }

    func restartGame() {
        score = 0
        isGameOver = false
        elements.removeAll()
    }
}

struct GameOverView: View {
    var score: Int
    var restartGame: () -> Void

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Score: \(score)")
                .font(.title)
                .foregroundColor(.black)
            Button("Restart Game") {
                restartGame()
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
