import AppKit
import SwiftUI

enum BrandPalette {
    static let cream = Color(red: 0.996, green: 0.949, blue: 0.882)
    static let ink = Color(red: 0.161, green: 0.118, blue: 0.102)
    static let orange = Color(red: 0.929, green: 0.361, blue: 0.200)
    static let orangeSoft = Color(red: 0.976, green: 0.565, blue: 0.337)
    static let coral = Color(red: 0.969, green: 0.760, blue: 0.670)
}

struct AppIconView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [BrandPalette.orangeSoft, BrandPalette.orange, BrandPalette.ink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.white.opacity(0.14))
                .frame(width: 360, height: 360)
                .offset(x: 180, y: -150)

            BowlShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 46, lineCap: .round, lineJoin: .round))
                .frame(width: 640, height: 360)
                .offset(y: 120)

            BowlRimShape()
                .stroke(.white.opacity(0.95), style: StrokeStyle(lineWidth: 36, lineCap: .round))
                .frame(width: 560, height: 140)
                .offset(y: 12)

            NoodlesShape()
                .stroke(.white.opacity(0.88), style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
                .frame(width: 340, height: 200)
                .offset(x: -65, y: -34)

            ChopsticksShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 28, lineCap: .round))
                .frame(width: 240, height: 360)
                .offset(x: 210, y: -130)

            Circle()
                .fill(BrandPalette.cream)
                .frame(width: 120, height: 120)
                .offset(x: -260, y: -200)
        }
        .clipShape(RoundedRectangle(cornerRadius: 224, style: .continuous))
    }
}

struct LaunchBrandView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [BrandPalette.coral, BrandPalette.orangeSoft, BrandPalette.orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            BowlShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 28, lineCap: .round, lineJoin: .round))
                .frame(width: 320, height: 190)
                .offset(y: 58)

            BowlRimShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 22, lineCap: .round))
                .frame(width: 280, height: 90)
                .offset(y: 6)

            ChopsticksShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .frame(width: 130, height: 220)
                .offset(x: 90, y: -74)
        }
        .padding(28)
    }
}

struct BowlShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.04, y: rect.minY + rect.height * 0.70))
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.02),
            control1: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.maxY - rect.height * 0.02),
            control2: CGPoint(x: rect.midX - rect.width * 0.18, y: rect.maxY - rect.height * 0.04)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.04, y: rect.minY + rect.height * 0.70),
            control1: CGPoint(x: rect.midX + rect.width * 0.18, y: rect.maxY - rect.height * 0.04),
            control2: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.maxY - rect.height * 0.02)
        )
        return path
    }
}

struct BowlRimShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.02, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.02, y: rect.midY),
            control1: CGPoint(x: rect.minX + rect.width * 0.24, y: rect.midY - rect.height * 0.26),
            control2: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.midY - rect.height * 0.26)
        )
        return path
    }
}

struct NoodlesShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.12, y: rect.height * 0.18))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.34, y: rect.height * 0.84),
            control1: CGPoint(x: rect.width * 0.02, y: rect.height * 0.36),
            control2: CGPoint(x: rect.width * 0.18, y: rect.height * 0.58)
        )

        path.move(to: CGPoint(x: rect.width * 0.46, y: rect.height * 0.08))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.58, y: rect.height * 0.84),
            control1: CGPoint(x: rect.width * 0.34, y: rect.height * 0.34),
            control2: CGPoint(x: rect.width * 0.46, y: rect.height * 0.60)
        )

        path.move(to: CGPoint(x: rect.width * 0.72, y: rect.height * 0.18))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.86, y: rect.height * 0.84),
            control1: CGPoint(x: rect.width * 0.62, y: rect.height * 0.34),
            control2: CGPoint(x: rect.width * 0.76, y: rect.height * 0.58)
        )

        return path
    }
}

struct ChopsticksShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.44, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.78, y: rect.maxY))

        path.move(to: CGPoint(x: rect.width * 0.68, y: rect.height * 0.02))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

@MainActor
func pngData<Content: View>(for view: Content, size: CGFloat, opaque: Bool) throws -> Data {
    let renderer = ImageRenderer(
        content: view
            .frame(width: size, height: size)
    )
    renderer.scale = 1
    renderer.isOpaque = opaque
    renderer.proposedSize = ProposedViewSize(width: size, height: size)

    guard let image = renderer.nsImage,
          let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let pngData = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "brand-assets", code: 1)
    }

    return pngData
}

@MainActor
func writePNG<Content: View>(_ view: Content, size: CGFloat, opaque: Bool, outputURL: URL) throws {
    let data = try pngData(for: view, size: size, opaque: opaque)
    try data.write(to: outputURL)
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

try MainActor.assumeIsolated {
    for (name, size) in iconSpecs {
        try writePNG(AppIconView(), size: size, opaque: true, outputURL: appIconDir.appendingPathComponent(name))
    }

    try writePNG(LaunchBrandView(), size: 512, opaque: false, outputURL: launchDir.appendingPathComponent("launch-brand.png"))
}
