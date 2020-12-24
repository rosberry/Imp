# Imp
<p align="center">
    <a href="https://github.com/rosberry/Imp/actions">
      <img src="https://github.com/rosberry/Imp/workflows/Build/badge.svg" />
    </a>
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/swift-5.0-orange.svg" alt="Swift Version" />
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-green.svg" alt="Carthage Compatible" />
    </a>
    <a href="https://github.com/apple/swift-package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

Imp is a lightweight framework aimed to abstract UIImage usage and provide out-of-box caching, `Codable`, `Equatable` & `Hashable` support. 

Currently it supports: 
* working with fetching images from a specified bundle
* fetcing from an URL
* managing already existing `CGImage`
* in-place drawing via `CGContext`

## Requirements

- iOS 11.0+
- Xcode 11.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Imp into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "rosberry/Imp"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Once you have your Swift package set up, adding Imp as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/rosberry/Imp.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

The most basic use case is to create a `ImageProvider` object that manages fetching and storage of an image and initialize an instance of `Image` with it:
```
let provider = NamedImageProvider(name: "example")
let image = Image(provider: provider)

// fetch UIImage
let uiImage = image()
```

At the moment there're 4 built-in providers: 
* `NamedImageProvider` which uses `UIImage(named:)` to fetch an image.
* `URLImageProvider` which fetches the contents of an URL and uses `UIImage(data:)` to initialized the image. While it _can_ fetch data from remote URL, it's not really intended to be use that way. It's not a replacement for something like [Kingfisher](https://github.com/onevcat/Kingfisher) in any shape or form.
* `CoreGraphicsImageProvider` which acts as a wrapper around an existing `CGImage`.
* `BitmapContextImageProvider` which can be used for on-demand generation of an `UIImage` by executing given actions on a `CGContext`.

`Image` object provides convenience initalizers for each use case so you don't need to create providers directly.

In some cases, mainly while using `BitmapContextImageProvider` or `URLImageProvider` you might want to fetch an `UIImage` asynscronosuly, it can be done so:
```
let url: URL = ...
let image = Image(url: url)
image.fetch { (image: UIImage?) in
    // do whatever
}
```

Finally, `Image` object does under-the-hood caching for fetched `UIImage` instances using `NSCache`, which means that cache will be automatically cleared in case 
of memory pressure event or app going to background. You can clear cache manually by calling `dropCache()` on corresponding `Image` instance.

## Templates

In `Template` directory of this repo you can find [swiftgen](https://github.com/SwiftGen/SwiftGen) template that uses Imp as a base image class instead of default `ImageAsset`.

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by [Rosberry](http://rosberry.com). We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/rosberry), read [our blog](https://medium.com/@Rosberry) or give us a high-five on 🐦 [@rosberryapps](http://twitter.com/RosberryApps).

## License

This project is available under the MIT license. See the LICENSE file for more info.
