import XCTest
import SDL
@testable import Argon
import Darwin.C

final class ArgonTests: XCTestCase {
    lazy var ui: ArgonUI = ArgonUI(buffer: self.buffer, width: self.size.w, height: self.size.h, stride: self.size.w)
    lazy var window: OpaquePointer = {
        SDL_CreateWindow(
            "Emulator window",
            Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
            size.w, size.h,
            SDL_WINDOW_SHOWN.rawValue
        )
    }()
    var event: SDL_Event = SDL_Event()
    lazy var surface: UnsafeMutablePointer<SDL_Surface> = {
        SDL_GetWindowSurface(self.window)!
    }()
    lazy var buffer: UnsafeMutableBufferPointer<UInt32> = {
        UnsafeMutableBufferPointer<UInt32>(
            start: self.surface.pointee.pixels.assumingMemoryBound(to: UInt32.self),
            count: Int(size.w * size.h)
        )

    }()
    let size: (w: Int32, h: Int32) = (w: 800, h: 400)
    var nextTest = false

    func handleEvents() {
        while (SDL_PollEvent(&self.event) > 0) {
            switch (self.event.type) {
            case SDL_KEYDOWN.rawValue:
                if event.key.keysym.sym == SDLK_ESCAPE.rawValue {
                    fallthrough
                }
            case SDL_QUIT.rawValue:
                self.nextTest = true
            default:
                break
            }
        }
    }

    /// Check that child is properly released after being removed from their parent
    func testMemLeakRmChild() {
        let v = ArView()
        let fill = ArFill(color: 0xFF00FF00)
        v.add(child: fill)

        self.ui.root = v

        self.runEnd()

        v.remove(child: fill)

        addTeardownBlock { [weak fill] in
            XCTAssertNil(fill, "Object should be deallocated. Detected memory leak")
        }
    }

    /// Check that child is properly released when parent is destroyed
    func testMemLeakDeinit() {
        let v = ArView()
        let fill = ArFill(color: 0xFFFF0000)
        v.add(child: fill)

        self.ui.root = v

        self.runEnd()

        self.ui.root = nil
        
        addTeardownBlock { [weak fill] in
            XCTAssertNil(fill, "Object should be deallocated. Detected memory leak")
        }
    }

    func testText() {
        let v = ArView()
        let fill = ArFill(color: 0xFF0000FF)
        v.add(child: fill)
        let text = ArText(text: "hello world, how are you?", font: ArFont.newBitmap(ArFont.defaultBitmap, size: 8, color: 0xFFFFFF00), enableWrapping: true)
        v.add(child: text)

        self.ui.root = v

        self.runEnd()
    }

    func runEnd() {
        self.nextTest = false
        while !self.nextTest {
            self.handleEvents()
            self.ui.draw()
            SDL_UpdateWindowSurface(self.window)
        }
    }

    deinit {
        SDL_DestroyWindow(self.window)
        SDL_Quit()
    }
}

