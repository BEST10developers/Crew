#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif
import Nimble
import Crew

private func ==(c1: NSLayoutConstraint, c2: NSLayoutConstraint) -> Bool {
    let b = c1.firstItem === c2.firstItem && c1.firstAttribute == c2.firstAttribute &&
        c1.secondItem === c2.secondItem && c1.secondAttribute == c2.secondAttribute &&
        c1.relation == c2.relation && c1.multiplier == c2.multiplier && c1.constant == c2.constant && c1.priority == c2.priority
    return b
}

private func ==(cs1: [NSLayoutConstraint], cs2: [NSLayoutConstraint]) -> Bool {
    if cs1.count == cs2.count {
        return cs1.reduce(true) { (acc, c1) in
            return acc && cs2.reduce(false) { (acc, c2) in acc || c1 == c2 }
        }
    }
    return false
}

func equal(c2: NSLayoutConstraint) -> MatcherFunc<NSLayoutConstraint> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(c2)>"
        if let c1 = actualExpression.evaluate() {
            return c1 == c2
        }
        else {
            return false
        }
    }
}

func equal(cs2: [NSLayoutConstraint]) -> MatcherFunc<[NSLayoutConstraint]> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(cs2)>"
        if let cs1 = actualExpression.evaluate() where cs1 == cs2 {
            return true
        }
        else {
            return false
        }
    }
}

func ==(lhs: Expectation<NSLayoutConstraint>, rhs: NSLayoutConstraint) {
    lhs.to(equal(rhs))
}

func ==(lhs: Expectation<[NSLayoutConstraint]>, rhs: [NSLayoutConstraint]) {
    lhs.to(equal(rhs))
}
