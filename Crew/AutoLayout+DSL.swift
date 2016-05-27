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

// MARK: - Build expression

public func ==(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return build(lhs, rhs: rhs, relation: .Equal)
}

public func <=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return build(lhs, rhs: rhs, relation: .LessThanOrEqual)
}

public func >=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return build(lhs, rhs: rhs, relation: .GreaterThanOrEqual)
}

// MARK: - Constant

public func ==(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs, constant: rhs, relation: .Equal)
}

public func <=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs, constant: rhs, relation: .LessThanOrEqual)
}

public func >=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs, constant: rhs, relation: .GreaterThanOrEqual)
}

// MARK: - Size

public func ==(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs, size: rhs, relation: .Equal)
}

public func <=(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs, size: rhs, relation: .LessThanOrEqual)
}

public func >=(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs, size: rhs, relation: .GreaterThanOrEqual)
}


// MARK: - Insets

public func ==(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.Equal, .Equal, .Equal, .Equal))
}

public func >=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.LessThanOrEqual, .LessThanOrEqual, .GreaterThanOrEqual, .GreaterThanOrEqual))
}

public func <=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.GreaterThanOrEqual, .GreaterThanOrEqual, .LessThanOrEqual, .LessThanOrEqual))
}

// MARK: - Alignment

public func ==(lhs: (view1: View, view2: View), attribute: NSLayoutAttribute) -> () -> NSLayoutConstraint {
    return build((lhs.view1, attribute), rhs: (lhs.view2, attribute, 1, 0), relation: .Equal)
}

public func ==(lhs: (view1: View, view2: View), attributes: [NSLayoutAttribute]) -> () -> [NSLayoutConstraint] {
    return {
        attributes.map { build((lhs.view1, $0), rhs: (lhs.view2, $0, 1, 0), relation: .Equal)() }
    }
}

// MARK: - Priority

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

// MARK: - Activate

public func <<=(lhs: View, rhs: () -> NSLayoutConstraint) {
    lhs.addConstraint(rhs())
}

public func <<=(lhs: View, rhs: () -> [NSLayoutConstraint]) {
    lhs.addConstraints(rhs())
}

// MARK: - private functions

private func build(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem, relation: NSLayoutRelation) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

private func build(lhs: AutoLayoutLeftItem, constant: CGFloat, relation: NSLayoutRelation) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
    }
}

private func build(lhs: View, size: CGSize, relation: NSLayoutRelation) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [NSLayoutConstraint] = []
        if size.width.isFinite {
            cons.append(build(lhs ~ .Width, constant: size.width, relation: relation)())
        }
        if size.height.isFinite {
            cons.append(build(lhs ~ .Height, constant: size.height, relation: relation)())
        }
        return cons
    }
}

private func build(lhs: View, rhs: View, insets: EdgeInsets, relations: (top: NSLayoutRelation, left: NSLayoutRelation, bottom: NSLayoutRelation, right: NSLayoutRelation)) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [NSLayoutConstraint] = []
        if insets.top.isFinite {
            cons.append(build(lhs ~ .Top, rhs: rhs ~ .Top - insets.top, relation: relations.top)())
        }
        if insets.left.isFinite {
            cons.append(build(lhs ~ .Left, rhs: rhs ~ .Left - insets.left, relation: relations.left)())
        }
        if insets.bottom.isFinite {
            cons.append(build(lhs ~ .Bottom, rhs: rhs ~ .Bottom + insets.bottom, relation: relations.bottom)())
        }
        if insets.right.isFinite {
            cons.append(build(lhs ~ .Right, rhs: rhs ~ .Right + insets.right, relation: relations.right)())
        }
        return cons
    }
}
