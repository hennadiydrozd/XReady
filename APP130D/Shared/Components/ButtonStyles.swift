import SwiftUI

struct CustomFillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.unbounded(.bold, size: 17))
            .foregroundStyle(.white)
            .frame(height: 58)
            .frame(maxWidth: 302)
            .background {
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .mask {
                            GeometryReader { geo in
                                VStack(spacing: 0) {
                                    Color.black
                                        .frame(height: geo.size.height * 0.8)
                                    Color.clear
                                }
                            }
                        }
    
                    Capsule()
                        .fill(LinearGradient(colors: [Color("0055E7"), Color("002F81")], startPoint: .top, endPoint: .bottom))
                        .offset(y: 2)
                        .blur(radius: 1)
                }
                .clipShape(Capsule())
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct CustomStrokeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.unbounded(.bold, size: 17))
            .foregroundStyle(.white)
            .frame(height: 58)
            .frame(maxWidth: 302)
            .background {
                Capsule()
                    .strokeBorder(Color("FFF4F4"), lineWidth: 1)
                
            }
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

extension ButtonStyle where Self == CustomFillButtonStyle {
    static var customFill: Self { .init() }
}

extension ButtonStyle where Self == CustomStrokeButtonStyle  {
    static var customStroke: Self { .init() }
}

#Preview {
    ZStack {
        LinearGradient.main.ignoresSafeArea()
        
        VStack {
            Button("Title", action: {})
                .buttonStyle(.customFill)
            
            Button("Title", action: {})
                .buttonStyle(.customStroke)
        }
    }
}
