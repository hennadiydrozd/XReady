import SwiftUI

protocol Fontable {
    var rawValue: String { get }
}

extension Fontable {
    var name: String {
        return String(describing: Self.self) + "-" + rawValue.capitalized
    }
}

extension Font {
    enum Inter: String, Fontable {
        case semiBold
    }
    
    static func inter(_ family: Inter, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}

extension Font {
    enum Montserrat: String, Fontable {
        case medium
    }
    
    static func montserrat(_ family: Montserrat, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}

extension Font {
    enum Poppins: String, Fontable {
        case bold
        case medium
        case regular
    }
    
    static func poppins(_ family: Poppins, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}

extension Font {
    enum Unbounded: String, Fontable {
        case bold
        case regular
        case semiBold
    }
    
    static func unbounded(_ family: Unbounded, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}
