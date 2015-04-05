#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif
import Nimble
import Crew


func equal(c2: NSLayoutConstraint) -> MatcherFunc<NSLayoutConstraint> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(c2)>"
        if let c1 = actualExpression.evaluate() {
            return c1.firstItem === c2.firstItem && c1.firstAttribute == c2.firstAttribute &&
                c1.secondItem === c2.secondItem && c1.secondAttribute == c2.secondAttribute &&
                c1.relation == c2.relation && c1.multiplier == c2.multiplier && c1.constant == c2.constant && c1.priority == c2.priority
        }
        else {
            return false
        }
    }
}

func ==(lhs: Expectation<NSLayoutConstraint>, rhs: NSLayoutConstraint) {
    lhs.to(equal(rhs))
}
