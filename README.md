# Argon UI library

Bindings for the [Argon UI library](https://github.com/jomy10/Argon).

This binding works by wrapping the view objects in classes and making sure their reference counts
represent the references in C.

To use the library, add the dependency to your Package's dependencies:
```swift
.package(url: "https://github.com/Jomy10/ArgonSwift", branch: "master"),
```

Add this to your target's dependencies:
```swift
.product(name: "Argon", package: "ArgonSwift"),
```

## Compiling

Unfortunately, to compile your project with SPM, you will need to add the flags `-Xcc -Ipath/to/olive.c`

steps:
1. Clone the olive.c repo:
```sh
git clone https://github.com/tsoding/olive.c
```
2. Add the flags when building or running your project:
```sh
swift build -Xcc -Iolive.c
```

## Running tests

```sh
ARGON_TEST=1 swift test
```

## Cloning the repo
```sh
git clone --recurse-submodules https://github.com/Jomy10/ArgonSwift
```

