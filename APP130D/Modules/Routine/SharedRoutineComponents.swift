import SwiftUI

struct DurationPickerView: View {
    @Binding var duration: Int
    @Environment(\.dismiss) private var dismiss
    
    @State private var minutes: Int = 0
    @State private var seconds: Int = 30
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.close)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("Select Duration")
                        .font(.unbounded(.semiBold, size: 20))
                        .foreground("02003A")
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        duration = minutes * 60 + seconds
                        dismiss()
                    } label: {
                        Image(.done)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Duration Picker
                HStack {
                    VStack(spacing: 16) {
                        Text("Minutes")
                            .font(.unbounded(.regular, size: 14))
                            .foregroundColor(.black.opacity(0.8))
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0...60, id: \.self) { minute in
                                Text("\(minute)")
                                    .foregroundColor(.black)
                                    .tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 16) {
                        Text("Seconds")
                            .font(.unbounded(.regular, size: 14))
                            .foregroundColor(.black.opacity(0.8))

                        Picker("Seconds", selection: $seconds) {
                            ForEach(0...59, id: \.self) { second in
                                Text("\(second)")
                                    .foregroundColor(.black)
                                    .tag(second)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // Initialize picker values from duration
            minutes = duration / 60
            seconds = duration % 60
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.inter(.semiBold, size: 14))
            .foregroundStyle(.black)
            .padding(.horizontal, 24)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("F2F2F2"))
            }
    }
}