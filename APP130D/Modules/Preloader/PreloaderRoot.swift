import SwiftUI

struct PreloaderRoot: View {
    // State to animate the loading indicator
    @State private var isRotating = false
    @State private var isMoving = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient.main.ignoresSafeArea()
                
                VStack {
                    ZStack {}
                        .frame(maxHeight: .infinity)
                    
                    VStack(spacing: 20) {
                        // App logo or icon (simplified as a football emoji for placeholder)
                        // Football emoji with rotation and left-to-right movement
                        Text("⚽")
                            .font(.system(size: 80))
                            .rotationEffect(.degrees(isRotating ? 360 : 0))
                            .offset(x: isMoving ? (geo.size.width / 2 + 100) : (-geo.size.width / 2 - 100)) // Move 20 points left to right
//                            .animation(
//                                Animation.linear(duration: 2.0)
//                                    .repeatForever(autoreverses: false), // Continuous rotation
//                                value: isRotating
//                            )
//                            .animation(
//                                Animation.easeInOut(duration: 1.5)
//                                    .repeatForever(autoreverses: true), // Smooth left-to-right
//                                value: isMoving
//                            )
                        
                        // Loading message
                        Text("Warming Up...")
                            .font(.unbounded(.bold, size: 20))
                            .foregroundColor(.white)
                        
                        // Brief app tagline
                        Text("Get ready for your workout!")
                            .font(.unbounded(.regular, size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Progress indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxHeight: .infinity)
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                isRotating = true
            }
            
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false)) {
                isMoving = true
            }
        }
    }
}

struct PreloaderRoot_Previews: PreviewProvider {
    static var previews: some View {
        PreloaderRoot()
    }
}
