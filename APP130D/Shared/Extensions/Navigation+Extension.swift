import SwiftUI

extension View {
    func hideSystemNavBar() -> some View {
        self
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
}

extension EnvironmentValues {
    var goBack: () -> Void {
        if #available(iOS 17.0, *) {
            { dismiss() }
        } else {
            { presentationMode.wrappedValue.dismiss() }
        }
    }
}
