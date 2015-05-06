#if os(iOS)
    import UIKit
    public typealias View = UIView
    public typealias LayoutPriority = UILayoutPriority
    public typealias EdgeInsets = UIEdgeInsets
#elseif os(OSX)
    import AppKit
    public typealias View = NSView
    public typealias LayoutPriority = NSLayoutPriority
    public typealias EdgeInsets = NSEdgeInsets
#endif


infix operator ~ { associativity none precedence 160 }
infix operator ! { associativity left precedence 100 }

public typealias AutoLayoutLeftItem = (item: AnyObject, attribute: NSLayoutAttribute)
public typealias AutoLayoutRightItem = (item: AnyObject, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat)


public func ~(item: View, rhs: NSLayoutAttribute) -> AutoLayoutLeftItem {
    return (item, rhs)
}

public func ~(item: View, rhs: NSLayoutAttribute) -> AutoLayoutRightItem {
    return (item, rhs, 1, 0)
}

#if os(iOS)

public func ~(item: UILayoutSupport, rhs: NSLayoutAttribute) -> AutoLayoutLeftItem {
    return (item, rhs)
}

public func ~(item: UILayoutSupport, rhs: NSLayoutAttribute) -> AutoLayoutRightItem {
    return (item, rhs, 1, 0)
}

#endif

public func *(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier * rhs, lhs.constant)
}

public func /(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier / rhs, lhs.constant)
}

public func +(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return (lhs.item, lhs.attribute, lhs.multiplier, lhs.constant + rhs)
}

public func -(lhs: AutoLayoutRightItem, rhs: CGFloat) -> AutoLayoutRightItem {
    return lhs + -rhs
}

public func +(lhs: View, rhs: EdgeInsets) -> (View, EdgeInsets) {
    return (lhs, rhs)
}

// build NSLayoutConstraint


public func ==(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .Equal, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

public func <=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .LessThanOrEqual, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

public func >=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .GreaterThanOrEqual, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

// Constant

public func ==(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: rhs)
    }
}

public func <=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: rhs)
    }
}

public func >=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: rhs)
    }
}

// EdgeInsets

public func ==(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [() -> NSLayoutConstraint] = []
        if rhs.1.top.isFinite {
            cons.append(lhs ~ .Top == rhs.0 ~ .Top - rhs.1.top)
        }
        if rhs.1.left.isFinite {
            cons.append(lhs ~ .Left == rhs.0 ~ .Left - rhs.1.left)
        }
        if rhs.1.bottom.isFinite {
            cons.append(lhs ~ .Bottom == rhs.0 ~ .Bottom + rhs.1.bottom)
        }
        if rhs.1.right.isFinite {
            cons.append(lhs ~ .Right == rhs.0 ~ .Right + rhs.1.right)
        }
        return cons.map { $0() }
    }
}

public func >=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [() -> NSLayoutConstraint] = []
        if rhs.1.top.isFinite {
            cons.append(lhs ~ .Top <= rhs.0 ~ .Top - rhs.1.top)
        }
        if rhs.1.left.isFinite {
            cons.append(lhs ~ .Left <= rhs.0 ~ .Left - rhs.1.left)
        }
        if rhs.1.bottom.isFinite {
            cons.append(lhs ~ .Bottom >= rhs.0 ~ .Bottom + rhs.1.bottom)
        }
        if rhs.1.right.isFinite {
            cons.append(lhs ~ .Right >= rhs.0 ~ .Right + rhs.1.right)
        }
        return cons.map { $0() }
    }
}

public func <=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [() -> NSLayoutConstraint] = []
        if rhs.1.top.isFinite {
            cons.append(lhs ~ .Top >= rhs.0 ~ .Top - rhs.1.top)
        }
        if rhs.1.left.isFinite {
            cons.append(lhs ~ .Left >= rhs.0 ~ .Left - rhs.1.left)
        }
        if rhs.1.bottom.isFinite {
            cons.append(lhs ~ .Bottom <= rhs.0 ~ .Bottom + rhs.1.bottom)
        }
        if rhs.1.right.isFinite {
            cons.append(lhs ~ .Right <= rhs.0 ~ .Right + rhs.1.right)
        }
        return cons.map { $0() }
    }
}

// set priority

public func !(lhs: () -> NSLayoutConstraint, priority: LayoutPriority) -> () -> NSLayoutConstraint {
    return {
        let c = lhs()
        c.priority = priority
        return c
    }
}

public func !(lhs: () -> [NSLayoutConstraint], priority: LayoutPriority) -> () -> [NSLayoutConstraint] {
    return {
        return lhs().map { c in
            c.priority = priority
            return c
        }
    }
}

// add constrains

public func <<=(lhs: View, rhs: () -> NSLayoutConstraint) {
    lhs.addConstraint(rhs())
}

public func <<=(lhs: View, rhs: () -> [NSLayoutConstraint]) {
    lhs.addConstraints(rhs())
}
