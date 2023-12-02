import ArgonC

public final class ArFill: ArView {
    public init(color: ArColor) {
        super.init(ptr: arFill_create(color)!)
        self.ptr.pointee.manual_children_management_callback = { ptr in
            Unmanaged<ArView>.fromOpaque(ptr!).takeUnretainedValue()
                .release()
        }
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

public final class ArText: ArView {
    // TODO: override -> in init -> set those functions as callbacks
    
}

