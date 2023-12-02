import ArgonC

open class ArView {
    // destroy function -> replace with a new one from swift, calling the old function first
    // like that keep track of which classes are destroyed
    let ptr: UnsafeMutablePointer<arView>

    init(ptr: UnsafeMutablePointer<arView>) {
        self.ptr = ptr
        self.ptr.pointee.manual_children_management_data = self.toPtr()
    }

    func toPtr() -> UnsafeMutableRawPointer {
        //return UnsafeMutableRawPointer(unsafeBitCast(self, to: UnsafeMutablePointer<Self>.self))
        return UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
    }

    public convenience init() {
        //self.ptr = arView_create()!
        self.init(ptr: arView_create()!)
        self.ptr.pointee.manual_children_management_callback = { ptr in
            Unmanaged<ArView>.fromOpaque(ptr!).takeUnretainedValue()
                .release()
            // ptr!.assumingMemoryBound(to: ArView.self)
            //     .pointee
            //     .release()
        }
    }

    public var draw: @convention(c) (UnsafeMutablePointer<arView>?, ArCanvas) -> Void {
        get {
            self.ptr.pointee.draw
        }
        set {
            self.ptr.pointee.draw = newValue
        }
    }

    public func drawView(canvas: ArCanvas, at position: ArPosition) {
        arView_draw(self.ptr, canvas, position)
    }

    public func add(child: ArView) {
        arView_addChild(self.ptr, child.ptr)
        child.retain()
    }

    public func remove(child: ArView) {
        // TODO: if child not found, don't release
        arView_rmChild(self.ptr, child.ptr)
        child.release()
    }

    public func clearChildren() {
        arView_clearChildren(self.ptr)
        // TODO: release children (in destroy function?)
    }

    public func setOnClick(_ onClick: @escaping @convention(c) (UnsafeMutablePointer<arView>?) -> Void) {
        arView_setOnClick(self.ptr, onClick)
    }

    func retain() {
        _ = Unmanaged.passRetained(self)
    }

    func release() {
        Unmanaged.passUnretained(self).release()
    }

    func autorelease() {
        _ = Unmanaged.passUnretained(self).autorelease()
    }

    deinit {
        arView_destroy(self.ptr)
    }
}

