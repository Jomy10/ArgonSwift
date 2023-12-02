import ArgonC

public final class ArgonUI {
    private var ptr: UnsafeMutablePointer<ArgonC.ArgonUI>
    public var root: ArView?

    public init(buffer: inout [UInt32], width: Int32, height: Int32, stride: Int32) {
        self.ptr = buffer.withUnsafeMutableBufferPointer { bufptr in
            argon_create(bufptr.baseAddress!, width, height, stride)
        }
    }

    public init(buffer: inout [UInt32], width: Int32, height: Int32) {
        self.ptr = buffer.withUnsafeMutableBufferPointer { bufptr in
            argon_create(bufptr.baseAddress!, width, height, width)
        }
    }

    public init(buffer: UnsafeMutableBufferPointer<UInt32>, width: Int32, height: Int32, stride: Int32) {
        self.ptr = argon_create(buffer.baseAddress!, width, height, stride)
    }

    public init(buffer: UnsafeMutableBufferPointer<UInt32>, width: Int32, height: Int32) {
        self.ptr = argon_create(buffer.baseAddress!, width, height, width)
    }

    public func resize(buffer: inout [UInt32], width: Int32, height: Int32, stride: Int32) {
        buffer.withUnsafeMutableBufferPointer { bufptr in
            argon_resize(self.ptr, bufptr.baseAddress, width, height, stride)
        }
    }

    public func resize(buffer: UnsafeMutablePointer<UInt32>, width: Int32, height: Int32, stride: Int32) {
        argon_resize(self.ptr, buffer, width, height, stride)
    }

    public func draw() {
        argon_draw(self.ptr, self.root!.ptr)
    }

    public func handleEvents() {
        argon_handleEvents(self.ptr, self.root!.ptr)
    }

    public func dispatchEvent(_ ev: ArEvent) {
        argon_dispatchEvent(self.ptr, ev.cEvent)
    }

    /// TODO: return the class instead (store as a static variable)
    public static var currentContext: UnsafeMutablePointer<ArgonC.ArgonUI> {
        get {
            argon_getCurrentContext()
        }
        set {
            argon_setContext(newValue)
        }
    }

    public func swapBuffers(root: ArView, _ newBuffer: inout [UInt32]) {
        newBuffer.withUnsafeMutableBufferPointer { bufptr in
            argon_swapBuffers(self.ptr, root.ptr, bufptr.baseAddress!)
        }
    }

    public func swapBuffers(root: ArView, _ newBuffer: UnsafeMutableBufferPointer<UInt32>) {
        argon_swapBuffers(self.ptr, root.ptr, newBuffer.baseAddress!)
    }

    deinit {
        argon_destroy(self.ptr)
    }
}

