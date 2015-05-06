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

        expect(view1 ~ .Top == view2 ~ .Top) {
            NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0)
        }
        expect(view1 ~ .Right == view2 ~ .Left) {
            NSLayoutConstraint(item: view1, attribute: .Right, relatedBy: .Equal, toItem: view2, attribute: .Left, multiplier: 1, constant: 0)
        }
        expect(view1 ~ .Width == view2 ~ .Width * 2) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 2, constant: 0)
        }
        expect(view1 ~ .Width == view2 ~ .Width + 20) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 1, constant: 20)
        }
        expect(view1 ~ .Width == view2 ~ .Width * 2 + 20) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
        }
        expect(view1 ~ .Width <= view2 ~ .Width * 2 + 20) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
        }
        expect(view1 ~ .Width >= view2 ~ .Width * 2 + 20) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: view2, attribute: .Width, multiplier: 2, constant: 20)
        }
        expect(view1 ~ .Width == 200) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        }
        expect(view1 ~ .Width == 100 * 2 + 10) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 210)
        }
        expect(view1 ~ .Width <= 200) {
            NSLayoutConstraint(item: view1, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        }
        expect(view1 ~ .Height >= 200) {
            NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        }
    }

    func testMargins() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        expect(view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        }

        expect(view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        }

        expect(view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top - 8,
                view1 ~ .Left == view2 ~ .Left - 9,
                view1 ~ .Bottom == view2 ~ .Bottom + 10,
                view1 ~ .Right == view2 ~ .Right + 11
            )
        }

        expect(view1 >= view2 + EdgeInsets(top: 12, left: 13, bottom: 14, right: 15)) {
            flatten(
                view1 ~ .Top <= view2 ~ .Top - 12,
                view1 ~ .Left <= view2 ~ .Left - 13,
                view1 ~ .Bottom >= view2 ~ .Bottom + 14,
                view1 ~ .Right >= view2 ~ .Right + 15
            )
        }

        expect(view1 <= view2 + EdgeInsets(top: 21, left: 22, bottom: 23, right: 24)) {
            flatten(
                view1 ~ .Top >= view2 ~ .Top - 21,
                view1 ~ .Left >= view2 ~ .Left - 22,
                view1 ~ .Bottom <= view2 ~ .Bottom + 23,
                view1 ~ .Right <= view2 ~ .Right + 24
            )
        }

        // == .NaN

        expect(view1 == view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        }

        expect(view1 == view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Bottom == view2 ~ .Bottom,
                view1 ~ .Right == view2 ~ .Right
            )
        }

        expect(view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Right == view2 ~ .Right
            )
        }

        expect(view1 == view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN)) {
            flatten(
                view1 ~ .Top == view2 ~ .Top,
                view1 ~ .Left == view2 ~ .Left,
                view1 ~ .Bottom == view2 ~ .Bottom
            )
        }

        // >= .NaN

        expect(view1 >= view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Bottom >= view2 ~ .Bottom,
                view1 ~ .Right >= view2 ~ .Right
            )
        }

        expect(view1 >= view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Bottom >= view2 ~ .Bottom,
                view1 ~ .Right >= view2 ~ .Right
            )
        }

        expect(view1 >= view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0)) {
            flatten(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Right >= view2 ~ .Right
            )
        }

        expect(view1 >= view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN)) {
            flatten(
                view1 ~ .Top <= view2 ~ .Top,
                view1 ~ .Left <= view2 ~ .Left,
                view1 ~ .Bottom >= view2 ~ .Bottom
            )
        }

        // <= .NaN

        expect(view1 <= view2 + EdgeInsets(top: .NaN, left: 0, bottom: 0, right: 0)) {
            flatten(
                //view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        }

        expect(view1 <= view2 + EdgeInsets(top: 0, left: .NaN, bottom: 0, right: 0)) {
            flatten(
                view1 ~ .Top >= view2 ~ .Top,
                //view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        }

        expect(view1 <= view2 + EdgeInsets(top: 0, left: 0, bottom: .NaN, right: 0)) {
            flatten(
                view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                //view1 ~ .Bottom <= view2 ~ .Bottom,
                view1 ~ .Right <= view2 ~ .Right
            )
        }

        expect(view1 <= view2 + EdgeInsets(top: 0, left: 0, bottom: 0, right: .NaN)) {
            flatten(
                view1 ~ .Top >= view2 ~ .Top,
                view1 ~ .Left >= view2 ~ .Left,
                view1 ~ .Bottom <= view2 ~ .Bottom
                //view1 ~ .Right <= view2 ~ .Right
            )
        }
    }

    func testPriority() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        expect(view1 ~ .Top == view2 ~ .Top ! 500) {
            NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0).withPriority(500)
        }
        expect(view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11) ! 500) {
            flatten(
                view1 ~ .Top == view2 ~ .Top - 8 ! 500,
                view1 ~ .Left == view2 ~ .Left - 9 ! 500,
                view1 ~ .Bottom == view2 ~ .Bottom + 10 ! 500,
                view1 ~ .Right == view2 ~ .Right + 11 ! 500
            )
        }
    }

    func testAddingSingle() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)
        
        view1 <<= view1 ~ .Width == view2 ~ .Width * 2
        expect(constraints(view1).count) == 1
    }

    func testAddingMultiple() {
        let view1 = View(frame: CGRect.zeroRect)
        let view2 = View(frame: CGRect.zeroRect)

        view1 <<= view1 == view2 + EdgeInsets(top: 8, left: 9, bottom: 10, right: 11)
        expect(constraints(view1).count) == 4
    }
}

