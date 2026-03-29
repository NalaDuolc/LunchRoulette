import AppKit

struct Palette {
    static let cream = NSColor(calibratedRed: 0.996, green: 0.949, blue: 0.882, alpha: 1)
    static let ink = NSColor(calibratedRed: 0.161, green: 0.118, blue: 0.102, alpha: 1)
    static let orange = NSColor(calibratedRed: 0.929, green: 0.361, blue: 0.200, alpha: 1)
    static let orangeSoft = NSColor(calibratedRed: 0.976, green: 0.565, blue: 0.337, alpha: 1)
    static let coral = NSColor(calibratedRed: 0.969, green: 0.760, blue: 0.670, alpha: 1)
}

func makeRoundedRectPath(in rect: CGRect, radius: CGFloat) -> NSBezierPath {
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
}

func renderPNG(size: CGFloat, hasAlpha: Bool, drawing: () -> Void, outputURL: URL) throws {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size),
        pixelsHigh: Int(size),
        bitsPerSample: 8,
        samplesPerPixel: hasAlpha ? 4 : 3,
        hasAlpha: hasAlpha,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw NSError(domain: "assetgen", code: 1)
    }

    bitmap.size = NSSize(width: size, height: size)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    drawing()
    NSGraphicsContext.restoreGraphicsState()

    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "assetgen", code: 2)
    }

    try data.write(to: outputURL)
}

func drawIcon(size: CGFloat, outputURL: URL) throws {
    try renderPNG(size: size, hasAlpha: false, drawing: {
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    let gradient = NSGradient(colors: [Palette.orangeSoft, Palette.orange, Palette.ink])!
    gradient.draw(in: rect, angle: -35)

    let glow = NSBezierPath(ovalIn: CGRect(x: size * 0.54, y: size * 0.53, width: size * 0.42, height: size * 0.42))
    NSColor.white.withAlphaComponent(0.14).setFill()
    glow.fill()

    let bowlRect = CGRect(x: size * 0.19, y: size * 0.20, width: size * 0.62, height: size * 0.34)
    let bowl = NSBezierPath()
    bowl.move(to: CGPoint(x: bowlRect.minX, y: bowlRect.maxY))
    bowl.curve(to: CGPoint(x: bowlRect.midX, y: bowlRect.minY),
               controlPoint1: CGPoint(x: bowlRect.minX, y: bowlRect.minY + size * 0.02),
               controlPoint2: CGPoint(x: bowlRect.midX - size * 0.08, y: bowlRect.minY))
    bowl.curve(to: CGPoint(x: bowlRect.maxX, y: bowlRect.maxY),
               controlPoint1: CGPoint(x: bowlRect.midX + size * 0.08, y: bowlRect.minY),
               controlPoint2: CGPoint(x: bowlRect.maxX, y: bowlRect.minY + size * 0.02))
    bowl.lineWidth = size * 0.045
    NSColor.white.setStroke()
    bowl.stroke()

    let rim = NSBezierPath()
    rim.move(to: CGPoint(x: size * 0.22, y: size * 0.44))
    rim.curve(to: CGPoint(x: size * 0.78, y: size * 0.44),
              controlPoint1: CGPoint(x: size * 0.36, y: size * 0.41),
              controlPoint2: CGPoint(x: size * 0.64, y: size * 0.41))
    rim.lineWidth = size * 0.035
    rim.lineCapStyle = .round
    NSColor.white.withAlphaComponent(0.95).setStroke()
    rim.stroke()

    let noodle = NSBezierPath()
    noodle.move(to: CGPoint(x: size * 0.34, y: size * 0.58))
    noodle.curve(to: CGPoint(x: size * 0.42, y: size * 0.46),
                 controlPoint1: CGPoint(x: size * 0.31, y: size * 0.54),
                 controlPoint2: CGPoint(x: size * 0.36, y: size * 0.49))
    noodle.move(to: CGPoint(x: size * 0.46, y: size * 0.60))
    noodle.curve(to: CGPoint(x: size * 0.52, y: size * 0.46),
                 controlPoint1: CGPoint(x: size * 0.44, y: size * 0.55),
                 controlPoint2: CGPoint(x: size * 0.48, y: size * 0.50))
    noodle.move(to: CGPoint(x: size * 0.58, y: size * 0.58))
    noodle.curve(to: CGPoint(x: size * 0.62, y: size * 0.46),
                 controlPoint1: CGPoint(x: size * 0.56, y: size * 0.54),
                 controlPoint2: CGPoint(x: size * 0.59, y: size * 0.49))
    noodle.lineWidth = size * 0.018
    noodle.lineCapStyle = .round
    NSColor.white.withAlphaComponent(0.85).setStroke()
    noodle.stroke()

    let chopsticks = NSBezierPath()
    chopsticks.move(to: CGPoint(x: size * 0.67, y: size * 0.78))
    chopsticks.line(to: CGPoint(x: size * 0.78, y: size * 0.48))
    chopsticks.move(to: CGPoint(x: size * 0.74, y: size * 0.79))
    chopsticks.line(to: CGPoint(x: size * 0.84, y: size * 0.50))
    chopsticks.lineWidth = size * 0.026
    chopsticks.lineCapStyle = .round
    NSColor.white.setStroke()
    chopsticks.stroke()

    let dot = NSBezierPath(ovalIn: CGRect(x: size * 0.18, y: size * 0.66, width: size * 0.12, height: size * 0.12))
    Palette.cream.setFill()
    dot.fill()
    }, outputURL: outputURL)
}

func drawLaunchBrand(size: CGFloat, outputURL: URL) throws {
    try renderPNG(size: size, hasAlpha: true, drawing: {
    NSColor.clear.setFill()
    CGRect(x: 0, y: 0, width: size, height: size).fill()

    let badgeRect = CGRect(x: size * 0.09, y: size * 0.09, width: size * 0.82, height: size * 0.82)
    let badge = NSBezierPath(ovalIn: badgeRect)
    let gradient = NSGradient(colors: [Palette.coral, Palette.orangeSoft, Palette.orange])!
    gradient.draw(in: badge, relativeCenterPosition: .zero)

    let bowl = NSBezierPath()
    bowl.move(to: CGPoint(x: size * 0.24, y: size * 0.36))
    bowl.curve(to: CGPoint(x: size * 0.50, y: size * 0.22),
               controlPoint1: CGPoint(x: size * 0.25, y: size * 0.23),
               controlPoint2: CGPoint(x: size * 0.40, y: size * 0.17))
    bowl.curve(to: CGPoint(x: size * 0.76, y: size * 0.36),
               controlPoint1: CGPoint(x: size * 0.60, y: size * 0.17),
               controlPoint2: CGPoint(x: size * 0.75, y: size * 0.23))
    bowl.lineWidth = size * 0.055
    bowl.lineCapStyle = .round
    NSColor.white.setStroke()
    bowl.stroke()

    let rim = NSBezierPath()
    rim.move(to: CGPoint(x: size * 0.26, y: size * 0.41))
    rim.curve(to: CGPoint(x: size * 0.74, y: size * 0.41),
              controlPoint1: CGPoint(x: size * 0.38, y: size * 0.37),
              controlPoint2: CGPoint(x: size * 0.62, y: size * 0.37))
    rim.lineWidth = size * 0.043
    rim.lineCapStyle = .round
    NSColor.white.setStroke()
    rim.stroke()

    let chopsticks = NSBezierPath()
    chopsticks.move(to: CGPoint(x: size * 0.59, y: size * 0.79))
    chopsticks.line(to: CGPoint(x: size * 0.70, y: size * 0.49))
    chopsticks.move(to: CGPoint(x: size * 0.67, y: size * 0.80))
    chopsticks.line(to: CGPoint(x: size * 0.78, y: size * 0.50))
    chopsticks.lineWidth = size * 0.03
    chopsticks.lineCapStyle = .round
    NSColor.white.setStroke()
    chopsticks.stroke()
    }, outputURL: outputURL)
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let appIconDir = root.appendingPathComponent("LunchRouletteApp/Resources/Assets.xcassets/AppIcon.appiconset")
let launchDir = root.appendingPathComponent("LunchRouletteApp/Resources/Assets.xcassets/LaunchBrand.imageset")

let iconSpecs: [(String, CGFloat)] = [
    ("icon-20@2x.png", 40),
    ("icon-20@3x.png", 60),
    ("icon-29@2x.png", 58),
    ("icon-29@3x.png", 87),
    ("icon-40@2x.png", 80),
    ("icon-40@3x.png", 120),
    ("icon-60@2x.png", 120),
    ("icon-60@3x.png", 180),
    ("icon-20-ipad@1x.png", 20),
    ("icon-20-ipad@2x.png", 40),
    ("icon-29-ipad@1x.png", 29),
    ("icon-29-ipad@2x.png", 58),
    ("icon-40-ipad@1x.png", 40),
    ("icon-40-ipad@2x.png", 80),
    ("icon-76-ipad@1x.png", 76),
    ("icon-76-ipad@2x.png", 152),
    ("icon-83.5-ipad@2x.png", 167),
    ("icon-1024.png", 1024)
]

for (name, size) in iconSpecs {
    try drawIcon(size: size, outputURL: appIconDir.appendingPathComponent(name))
}

try drawLaunchBrand(size: 512, outputURL: launchDir.appendingPathComponent("launch-brand.png"))
