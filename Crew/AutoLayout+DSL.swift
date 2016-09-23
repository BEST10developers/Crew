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

precedencegroup AutoLayoutPriorityPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
}
precedencegroup AutoLayoutCreationPrecedence {
    associativity: left
    higherThan: AutoLayoutPriorityPrecedence
}
infix operator ~ : AutoLayoutCreationPrecedence
infix operator ! : AutoLayoutPriorityPrecedence

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
    return build(lhs: lhs, rhs: rhs, relation: .equal)
}

public func <=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return build(lhs: lhs, rhs: rhs, relation: .lessThanOrEqual)
}

public func >=(lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem) -> () -> NSLayoutConstraint {
    return build(lhs: lhs, rhs: rhs, relation: .greaterThanOrEqual)
}

// MARK: - Constant

public func ==(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs: lhs, constant: rhs, relation: .equal)
}

public func <=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs: lhs, constant: rhs, relation: .lessThanOrEqual)
}

public func >=(lhs: AutoLayoutLeftItem, rhs: CGFloat) -> () -> NSLayoutConstraint {
    return build(lhs: lhs, constant: rhs, relation: .greaterThanOrEqual)
}

// MARK: - Size

public func ==(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs: lhs, size: rhs, relation: .equal)
}

public func <=(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs: lhs, size: rhs, relation: .lessThanOrEqual)
}

public func >=(lhs: View, rhs: CGSize) -> () -> [NSLayoutConstraint] {
    return build(lhs: lhs, size: rhs, relation: .greaterThanOrEqual)
}


// MARK: - Insets

public func ==(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.equal, .equal, .equal, .equal))
}

public func >=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.lessThanOrEqual, .lessThanOrEqual, .greaterThanOrEqual, .greaterThanOrEqual))
}

public func <=(lhs: View, rhs: (View, EdgeInsets)) -> () -> [NSLayoutConstraint] {
    return build(lhs, rhs: rhs.0, insets: rhs.1, relations: (.greaterThanOrEqual, .greaterThanOrEqual, .lessThanOrEqual, .lessThanOrEqual))
}

// MARK: - Alignment

public func ==(lhs: (view1: View, view2: View), attribute: NSLayoutAttribute) -> () -> NSLayoutConstraint {
    return build(lhs: (lhs.view1, attribute), rhs: (lhs.view2, attribute, 1, 0), relation: .equal)
}

public func ==(lhs: (view1: View, view2: View), attributes: [NSLayoutAttribute]) -> () -> [NSLayoutConstraint] {
    return {
        attributes.map { build(lhs: (lhs.view1, $0), rhs: (lhs.view2, $0, 1, 0), relation: .equal)() }
    }
}

// MARK: - Priority

public func !(lhs: @escaping () -> NSLayoutConstraint, priority: LayoutPriority) -> () -> NSLayoutConstraint {
    return {
        let c = lhs()
        c.priority = priority
        return c
    }
}

public func !(lhs: @escaping () -> [NSLayoutConstraint], priority: LayoutPriority) -> () -> [NSLayoutConstraint] {
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

public func activate(_ constraint: () -> NSLayoutConstraint) {
    constraint().isActive = true
}

public func activate(_ constraints: () -> [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints())
}

public func deactivate(_ constraint: () -> NSLayoutConstraint) {
    constraint().isActive = false
}

public func deactivate(_ constraints: () -> [NSLayoutConstraint]) {
    NSLayoutConstraint.deactivate(constraints())
}

// MARK: - private functions

private func build(_ lhs: AutoLayoutLeftItem, rhs: AutoLayoutRightItem, relation: NSLayoutRelation) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

private func build(_ lhs: AutoLayoutLeftItem, constant: CGFloat, relation: NSLayoutRelation) -> () -> NSLayoutConstraint {
    return {
        NSLayoutConstraint(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
    }
}

private func build(_ lhs: View, size: CGSize, relation: NSLayoutRelation) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [NSLayoutConstraint] = []
        if size.width.isFinite {
            cons.append(build(lhs: lhs ~ .width, constant: size.width, relation: relation)())
        }
        if size.height.isFinite {
            cons.append(build(lhs: lhs ~ .height, constant: size.height, relation: relation)())
        }
        return cons
    }
}

private func build(_ lhs: View, rhs: View, insets: EdgeInsets, relations: (top: NSLayoutRelation, left: NSLayoutRelation, bottom: NSLayoutRelation, right: NSLayoutRelation)) -> () -> [NSLayoutConstraint] {
    return {
        var cons: [NSLayoutConstraint] = []
        if insets.top.isFinite {
            cons.append(build(lhs: lhs ~ .top, rhs: rhs ~ .top - insets.top, relation: relations.top)())
        }
        if insets.left.isFinite {
            cons.append(build(lhs: lhs ~ .left, rhs: rhs ~ .left - insets.left, relation: relations.left)())
        }
        if insets.bottom.isFinite {
            cons.append(build(lhs: lhs ~ .bottom, rhs: rhs ~ .bottom + insets.bottom, relation: relations.bottom)())
        }
        if insets.right.isFinite {
            cons.append(build(lhs: lhs ~ .right, rhs: rhs ~ .right + insets.right, relation: relations.right)())
        }
        return cons
    }
}
