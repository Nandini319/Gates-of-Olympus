//
//  ContentView.swift
//  Gates of Olympus
//
//  Created by Nandini Vithlani on 06/10/23.
//
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var showGameView = false
    @State private var showGameRules = false
    @State private var isMusicPlaying = false // Track whether music is playing
    
    // Define an AVPlayer to stream the music from a remote URL
    private let audioPlayer: AVPlayer? = {
        if let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3") {
            return AVPlayer(url: url)
        }
        return nil
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainscreen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    NavigationLink(
                        destination: GameView(),
                        isActive: $showGameView
                    ) {
                        DiamondButton(label: "Start Game")
                    }
                    
                    Button(action: {
                        showGameRules.toggle()
                    }) {
                        DiamondButton(label: "Game Rules")
                    }
                    .sheet(isPresented: $showGameRules) {
                        BackgroundView()
                    }
                }
            }
            .navigationBarTitle("") // Hide the default navigation bar title
            .navigationBarItems(trailing: speakerButton) // Place the custom speaker button in the top-right corner
        }
        .onAppear {
            // Start playing music when the view appears
            playMusic()
        }
    }
    
    var speakerButton: some View {
        Button(action: {
            toggleMusic()
        }) {
            Image(systemName: isMusicPlaying ? "speaker.fill" : "speaker.slash.fill")
                .font(.title)
                .foregroundColor(.gold)
        }
    }
    
    func toggleMusic() {
        if isMusicPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isMusicPlaying.toggle()
    }
    
    // Function to start playing music
    func playMusic() {
        if !isMusicPlaying {
            audioPlayer?.seek(to: .zero)
            audioPlayer?.play()
            isMusicPlaying = true
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.audioPlayer?.pause()
                self.audioPlayer?.seek(to: .zero)
                self.audioPlayer?.play()
            }
        }
    }
}

struct DiamondButton: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.title)
            .foregroundColor(.gold)
            .padding(EdgeInsets(top: 20, leading: 70, bottom: 20, trailing: 70))
            .background(
                DiamondShape()
                    .fill(Color.darkBlue)
            )
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.closeSubpath()
        
        return path
    }
}

extension Color {
    static let gold = Color(red: 255 / 255, green: 215 / 255, blue: 0 / 255)
    static let darkBlue = Color(red: 0 / 255, green: 0 / 255, blue: 139 / 255)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
