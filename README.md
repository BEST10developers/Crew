# Crew

Fantastic DSL for Auto Layout in Swift.

## Usage

### Square

    view <<= view1 ~ .Height == view1 ~ .Width

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .Equal, toItem: view1, attribute: .Width, multiplier: 1, constant: 0))

### Direct setting

    view <<= view1 ~ .Height == 30

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))

### Relation

    view <<= view2 ~ .Top == view1 ~ .Bottom
    view <<= view3 ~ .Top == view2 ~ .Bottom + 10

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Bottom, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0))
    // view.addConstraint(NSLayoutConstraint(item: view2, attribute: .Bottom, relatedBy: .Equal, toItem: view3, attribute: .Top, multiplier: 1, constant: 10))
    //
    // or:
    // view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view1][view2]-(10)-[view3]", options: 0, metrics: nil, views: ["view1": view1, "view2": view2, "view3": view3]))

### Inner view

    view <<= view == view1 + UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 10))
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 10))
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -10))
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -10))

### Inner view (only horizontal constraints)

    view <<= view == view1 + UIEdgeInsets(top: .NaN, left: 10, bottom: .NaN, right: 10)

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 10))
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -10))

### Inner view (centering)

    view <<= view1 ~ .CenterX == view ~ .CenterX
    view <<= view1 ~ .CenterY == view ~ .CenterY

    // same as:
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    // view.addConstraint(NSLayoutConstraint(item: view1, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))

### Others

See test code.  
[https://github.com/kzms/Crew/blob/develop/CrewTests/AutoLayoutDSLTest.swift](https://github.com/kzms/Crew/blob/develop/CrewTests/AutoLayoutDSLTest.swift)
