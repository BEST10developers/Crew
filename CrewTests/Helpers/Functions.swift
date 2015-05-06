#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

// workaround for 'expression was too complex to be solved in reasonable time'
func flatten(f: (() -> NSLayoutConstraint)...) -> [NSLayoutConstraint] {
    return f.map { $0() }
}

#if os(iOS)

func constraints(view: UIView) -> [NSLayoutConstraint] {
    return view.constraints() as! [NSLayoutConstraint]
}

#elseif os(OSX)

func constraints(view: NSView) -> [NSLayoutConstraint] {
    return view.constraints as! [NSLayoutConstraint]
}

#endif

#if os(iOS)
#elseif os(OSC)
#endif

#if os(iOS)
#elseif os(OSX)
#endif
