import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let assets = root.appendingPathComponent("assets", isDirectory: true)
try FileManager.default.createDirectory(at: assets, withIntermediateDirectories: true)

func drawIcon(size: Int, destination: URL) throws {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let bounds = NSRect(x: 0, y: 0, width: size, height: size)
    let radius = CGFloat(size) * 0.222
    let path = NSBezierPath(roundedRect: bounds, xRadius: radius, yRadius: radius)
    path.addClip()

    let gradient = NSGradient(colorsAndLocations:
        (NSColor(red: 0.216, green: 0.722, blue: 0.514, alpha: 1), 0),
        (NSColor(red: 0.137, green: 0.525, blue: 0.416, alpha: 1), 0.58),
        (NSColor(red: 0.082, green: 0.353, blue: 0.310, alpha: 1), 1)
    )!
    gradient.draw(in: bounds, angle: -45)

    let shine = NSBezierPath()
    shine.move(to: NSPoint(x: CGFloat(size) * 0.2, y: CGFloat(size) * 0.81))
    shine.curve(to: NSPoint(x: CGFloat(size) * 0.83, y: CGFloat(size) * 0.81),
                controlPoint1: NSPoint(x: CGFloat(size) * 0.4, y: CGFloat(size) * 0.93),
                controlPoint2: NSPoint(x: CGFloat(size) * 0.64, y: CGFloat(size) * 0.93))
    shine.curve(to: NSPoint(x: CGFloat(size) * 0.92, y: CGFloat(size) * 0.59),
                controlPoint1: NSPoint(x: CGFloat(size) * 0.94, y: CGFloat(size) * 0.74),
                controlPoint2: NSPoint(x: CGFloat(size) * 0.96, y: CGFloat(size) * 0.65))
    shine.curve(to: NSPoint(x: CGFloat(size) * 0.2, y: CGFloat(size) * 0.81),
                controlPoint1: NSPoint(x: CGFloat(size) * 0.69, y: CGFloat(size) * 0.73),
                controlPoint2: NSPoint(x: CGFloat(size) * 0.42, y: CGFloat(size) * 0.69))
    NSColor.white.withAlphaComponent(0.22).setFill()
    shine.fill()

    NSGraphicsContext.current?.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowOffset = NSSize(width: 0, height: -CGFloat(size) * 0.04)
    shadow.shadowBlurRadius = CGFloat(size) * 0.035
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.24)
    shadow.set()

    let white = NSColor(red: 0.973, green: 1, blue: 0.976, alpha: 1)
    white.setFill()
    func roundedRect(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, r: CGFloat) {
        NSBezierPath(roundedRect: NSRect(x: x, y: y, width: w, height: h), xRadius: r, yRadius: r).fill()
    }
    let s = CGFloat(size)
    roundedRect(x: s * 0.206, y: s * 0.317, w: s * 0.094, h: s * 0.261, r: s * 0.039)
    roundedRect(x: s * 0.317, y: s * 0.261, w: s * 0.1, h: s * 0.372, r: s * 0.044)
    roundedRect(x: s * 0.417, y: s * 0.361, w: s * 0.166, h: s * 0.172, r: s * 0.05)
    roundedRect(x: s * 0.583, y: s * 0.261, w: s * 0.1, h: s * 0.372, r: s * 0.044)
    roundedRect(x: s * 0.7, y: s * 0.317, w: s * 0.094, h: s * 0.261, r: s * 0.039)
    NSGraphicsContext.current?.restoreGraphicsState()

    NSColor(red: 1, green: 0.82, blue: 0.4, alpha: 1).setStroke()
    let underline = NSBezierPath()
    underline.lineWidth = s * 0.056
    underline.lineCapStyle = .round
    underline.move(to: NSPoint(x: s * 0.311, y: s * 0.211))
    underline.line(to: NSPoint(x: s * 0.689, y: s * 0.211))
    underline.stroke()

    image.unlockFocus()

    guard
        let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        throw NSError(domain: "IconGeneration", code: 1)
    }

    try png.write(to: destination)
}

try drawIcon(size: 180, destination: assets.appendingPathComponent("apple-touch-icon.png"))
try drawIcon(size: 32, destination: assets.appendingPathComponent("favicon-32.png"))
