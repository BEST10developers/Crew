#if os(iOS)
    import UIKit
    #elseif os(OSX)
    import AppKit
#endif

// workaround for 'expression was too complex to be solved in reasonable time'
func build(f: (() -> NSLayoutConstraint)...) -> [NSLayoutConstraint] {
    return f.map { $0() }
}

