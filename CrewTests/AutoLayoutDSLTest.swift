#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

import Crew
import XCTest
import Nimble

class AutoLayoutDSLTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDSL() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        let pairs: [(() -> NSLayoutConstraint, NSLayoutConstraint)] = [
            (
                view1 ~ .Top == view2 ~ .Top,
                NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0)
            ),
            (
                view1 ~ .Top == view2 ~ .Top ! 500,
                NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0).withPriority(500)
            ),
            (
                view1 ~ .Right == view2 ~ .Left,
                NSLayoutConstraint(item: view1, attribute: .Right, relatedBy: .Equal, toItem: view2, attribute: .Left, multiplier: 1, constant: 0)
            ),
            (
                view1 ~ .Width == view2 ~ .Width * 2,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 2, constant: 0)
            ),
            (
                view1 ~ .Width == view2 ~ .Width + 20,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 1, constant: 20)
            ),
            (
                view1 ~ .Width == view2 ~ .Width * 2 + 20,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
            ),
            (
                view1 ~ .Width <= view2 ~ .Width * 2 + 20,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
            ),
            (
                view1 ~ .Width >= view2 ~ .Width * 2 + 20,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
            ),
            (
                view1 ~ .Width == 200,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
            ),
            (
                view1 ~ .Width == 100 * 2 + 10,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 210)
            ),
            (
                view1 ~ .Width <= 200,
                NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
            ),
            (
                view1 ~ .Height >= 200,
                NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
            ),
        ]

        for pair in pairs {
            expect(pair.0) == pair.1
        }
    }

    func testAdding() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)
        
        view1 <<= view1 ~ .Width == view2 ~ .Width * 2
        
        expect(view1.constraints().count) == 1
    }
}

