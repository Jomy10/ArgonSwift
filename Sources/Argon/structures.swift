import ArgonC

public typealias ArPosition = arPosition
extension ArPosition {
    static func +(lhs: ArPosition, rhs: ArPosition) {
        arPosition_add(lhs, rhs)
    }
}

public typealias ArSize = arSize

public typealias ArColor = arColor

public typealias ArMargin = arMargin

public enum ArEvent {
    case pointerPress(ArPosition)
    case pointerRelease(ArPosition)
   
    internal var cEvent: ArgonC.arEvent {
        switch (self) {
        case .pointerPress(let pos):
            return arEvent(type: AR_EV_POINTER_PRESS, data: arEventData(pointer_pos: pos))
        case .pointerRelease(let pos):
            return arEvent(type: AR_EV_POINTER_RELEASE, data: arEventData(pointer_pos: pos))
        }
    }
}

public typealias ArBitmapFont = arBitmapFont

public struct ArFont {
    var font: ArgonC.arFont

    // has to be kept up to date with the C implementation!
    public enum FontType: UInt32 {
        case bitmap
    }

    public static func newBitmap(_ font: ArBitmapFont, size: Int, color: ArColor) -> Self {
        Self(font: arFont_newBitmap(font, size, color))
    }

    public var type: Self.FontType {
        get {
            Self.FontType(rawValue: self.font.type.rawValue)!
        }
    }

    public var size: Int {
        get {
            self.font.size
        }
        set {
            self.font.size = newValue
        }
    }

    public var color: ArColor {
        get {
            self.font.color
        }
        set {
            self.font.color = newValue
        }
    }

    // TODO
    static let defaultBitmap: ArBitmapFont = {
        return olivec_default_font
    }()
}

