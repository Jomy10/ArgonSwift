import Argon
import SDL
import Foundation
import Darwin.C

let size: (w: Int32, h: Int32) = (w: 800, h: 400)
var window: OpaquePointer = SDL_CreateWindow(
    "Emulator window",
    Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
    size.w, size.h,
    SDL_WINDOW_SHOWN.rawValue
)
var event: SDL_Event = SDL_Event()
var surface: UnsafeMutablePointer<SDL_Surface> = SDL_GetWindowSurface(window)!
var buffer: UnsafeMutableBufferPointer<UInt32> = UnsafeMutableBufferPointer<UInt32>(
    start: surface.pointee.pixels.assumingMemoryBound(to: UInt32.self),
    count: Int(size.w * size.h)
)
var ui: ArgonUI = ArgonUI(buffer: buffer.baseAddress!, width: size.w, height: size.h, stride: size.w)
var quit = false

func main() {
    print("Running")
    let v = ArView()
    let fill = ArFill(color: 0xFFFF0000)
    v.add(child: fill)

    ui.root = v

    while !quit {
        while (SDL_PollEvent(&event) > 0) {
            switch (event.type) {
            case SDL_KEYDOWN.rawValue:
                if event.key.keysym.sym == SDLK_ESCAPE.rawValue {
                    fallthrough
                }
            case SDL_QUIT.rawValue:
                quit = true
            default:
                break
            }
        }

        ui.draw()
        SDL_UpdateWindowSurface(window)
    }

    ui.root = nil
    fflush(stdout)

    print(CFGetRetainCount(fill))
    fflush(stdout)
    print(CFGetRetainCount(fill))
    fflush(stdout)
    print("end")
}

main()

