import ArgonC

public final class ArFill: ArView {
    public init(color: ArColor) {
        super.init(ptr: arFill_create(color)!)
    }

    public var color: ArColor {
        set {
            arFill_setColor(self.ptr, newValue)
        }
        get {
            return arFill_getColor(self.ptr)
        }
    }
}

public final class ArContainer: ArView {
    public init(width: Int, height: Int) {
        super.init(ptr: arContainer_create(width, height))
    }

    public var width: Int {
        set {
            arContainer_setWidth(self.ptr, newValue)
        }
        get {
            arContainer_getWidth(self.ptr)
        }
    }

    public var height: Int {
        set {
            arContainer_setHeight(self.ptr, newValue)
        }
        get {
            arContainer_getHeight(self.ptr)
        }
    }

    public var margin: ArMargin {
        set {
            arContainer_setMargin(self.ptr, newValue)
        }
        get {
            arContainer_getMargin(self.ptr)
        }
    }
}

public final class ArHStack: ArView {
    public init() {
        super.init(ptr: arHStack_create())
    }

    public func setWidth(at index: Int32, _ width: Int32) {
        arHStack_setWidth(self.ptr, index, width)
    }

    public func assureMinWidthCap(_ cap: Int32) {
        arHStack_assureMinWidthCap(self.ptr, cap)
    }
}

public final class ArVStack: ArView {
    public init() {
        super.init(ptr: arVStack_create())
    }

    public func setHeight(at index: Int32, _ height: Int32) {
        arVStack_setHeight(self.ptr, index, height)
    }

    public func assureMinHeightCap(_ cap: Int32) {
        arVStack_assureMinHeightCap(self.ptr, cap)
    }
}

public final class ArText: ArView {
    private var stringStorage: String

    public init(text: String, font: ArFont, enableWrapping: Bool = false) {
        self.stringStorage = text
        let strPtr = self.stringStorage.withCString { ptr in 
            return ptr
        }
        super.init(ptr: arText_create(UnsafeMutablePointer(mutating: strPtr), font.font, false, enableWrapping))
    }
    
    public var size: Int {
        get {
            arText_getSize(self.ptr)
        }
        set {
            arText_setSize(self.ptr, newValue)
        }
    }

    public var textSize: ArSize {
        arText_getTextSize(self.ptr)
    }

    public var text: String {
        get {
            self.stringStorage
        }
        set {
            self.stringStorage = newValue
            self.stringStorage.withCString { ptr in 
                arText_setText(self.ptr, UnsafeMutablePointer(mutating: ptr))
            }
        }
    }

    public func setBitmapFont(_ font: ArBitmapFont) {
        arText_setBitmapFont(self.ptr, font)
    }

    public var color: ArColor {
        get {
            arText_getColor(self.ptr)
        }
        set {
            arText_setColor(self.ptr, newValue)
        }
    }
}

public class ArCanvas: ArView {
    public init(width: Int, height: Int) {
        super.init(ptr: arCanvas_create(width, height))
    }

    public init(data: inout [UInt32], width: Int, height: Int) {
        let ptr = data.withUnsafeMutableBufferPointer { ptr in
            ptr.baseAddress!
        }
        super.init(ptr: arCanvas_createWithData(ptr, width, height))
    }

    public init(data: UnsafeMutableBufferPointer<UInt32>, width: Int, height: Int) {
        super.init(ptr: arCanvas_createWithData(data.baseAddress!, width, height))
    }

    public init(canvas: Olivec_Canvas) {
        super.init(ptr: arCanvas_createWithCanvas(canvas))
    }

    public var data: UnsafeMutablePointer<UInt32> {
        get {
            arCanvas_getData(self.ptr)
        }
    }
}

// TODO: ArSubCanvas

