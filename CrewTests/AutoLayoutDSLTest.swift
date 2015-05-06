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

    func testMargins() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        var pairs: [(() -> [NSLayoutConstraint], [NSLayoutConstraint])] = []

        pairs.append(
            view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            build(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        )

        pairs.append(
            view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11),
            build(
                view1 ~ .Top == view2 ~ .Top - 8,
                view1 ~ .Left == view2 ~ .Left - 9,
                view1 ~ .Bottom == view2 ~ .Bottom + 10,
                view1 ~ .Right == view2 ~ .Right + 11
            )
        )

        pairs.append(
            view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11) ! 500,
            build(
                view1 ~ .Top == view2 ~ .Top - 8 ! 500,
                view1 ~ .Left == view2 ~ .Left - 9 ! 500,
                view1 ~ .Bottom == view2 ~ .Bottom + 10 ! 500,
                view1 ~ .Right == view2 ~ .Right + 11 ! 500
            )
        )

        pairs.append(
            view1 >= view2 + EdgeInsets(top: 12, left: 13, bottom: 14, right: 15),
            build(
                view1 ~ .Top <= view2 ~ .Top - 12,
                view1 ~ .Left <= view2 ~ .Left - 13,
                view1 ~ .Bottom >= view2 ~ .Bottom + 14,
                view1 ~ .Right >= view2 ~ .Right + 15
            )
        )

        pairs.append(
            view1 <= view2 + EdgeInsets(top: 21, left: 22, bottom: 23, right: 24),
            build(
                view1 ~ .Top >= view2 ~ .Top - 21,
                view1 ~ .Left >= view2 ~ .Left - 22,
                view1 ~ .Bottom <= view2 ~ .Bottom + 23,
                view1 ~ .Right <= view2 ~ .Right + 24
            )
        )

        // == .NaN

        pairs.append(
            view1 == view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0),
            build(
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        )

        pairs.append(
            view1 == view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0),
            build(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        )

        pairs.append(
            view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0),
            build(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Right == view2 ~ .Right
            )
        )

        pairs.append(
            view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN),
            build(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom
            )
        )

        // >= .NaN

        pairs.append(
            view1 >= view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0),
            build(
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Bottom >= view2 ~ .Bottom,
                view1 ~ .Right >= view2 ~ .Right
            )
        )

        pairs.append(
            view1 >= view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0),
            build(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Bottom >= view2 ~ .Bottom,
                view1 ~ .Right >= view2 ~ .Right
            )
        )

        pairs.append(
            view1 >= view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0),
            build(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Right >= view2 ~ .Right
            )
        )

        pairs.append(
            view1 >= view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN),
            build(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Bottom >= view2 ~ .Bottom
            )
        )

        // <= .NaN

        pairs.append(
            view1 <= view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0),
            build(
                //view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        )

        pairs.append(
            view1 <= view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0),
            build(
                view1 ~ .Top >= view2 ~ .Top,
                //view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        )

        pairs.append(
            view1 <= view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0),
            build(
                view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                //view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        )

        pairs.append(
            view1 <= view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN),
            build(
                view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom
                //view1 ~ .Right <= view2 ~ .Right
            )
        )

        for pair in pairs {
            expect(pair.0()) == pair.1
        }
    }

    func testAddingSingle() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)
        
        view1 <<= view1 ~ .Width == view2 ~ .Width * 2

#if os(iOS)
        expect(view1.constraints().count) == 1
#elseif os(OSX)
        expect(view1.constraints.count) == 1
#endif

    }

    func testAddingMultiple() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        view1 <<= view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11)

#if os(iOS)
        let cons = view1.constraints()
#elseif os(OSX)
        let cons = view1.constraints
#endif
        expect(cons.count) == 4
    }
}

