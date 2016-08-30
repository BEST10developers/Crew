# Crew

Fantastic DSL for Auto Layout in Swift.

## Installing

### [Carthage](https://github.com/Carthage/Carthage)

    github "kzms/Crew"


## Usage

### Square

    activate(view1 ~ .Height == view1 ~ .Width)

    // same as:
    // NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .Equal, toItem: view1, attribute: .Width, multiplier: 1, constant: 0).active = true

### Direct setting

    activate(view1 ~ .Height == 30)

    // same as:
    // NSLayoutConstraint(item: view1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30).active = true

### With CGSize

    activate(view1 == CGSize(width: 100, height: 200))

    // same as:
    // activate(view1 ~ .Width == 100)
    // activate(view1 ~ .Height == 200)

### Alignment

    activate((view1, view2) == .Top)

    // same as
    // activate(view1 ~ .Top == view2 ~ .Top)

    activate((view1, view2) == [.CenterX, .CenterY])

    // same as
    // activate(view1 ~ .CenterX == view2 ~ .CenterX)
    // activate(view1 ~ .CenterY == view2 ~ .CenterY)

### Relation

    activate(view2 ~ .Top == view1 ~ .Bottom)
    activate(view3 ~ .Top == view2 ~ .Bottom + 10)

    // same as:
    // NSLayoutConstraint(item: view2, attribute: .Bottom, relatedBy: .Equal, toItem: view1, attribute: .Top, multiplier: 1, constant: 0).active = true
    // NSLayoutConstraint(item: view3, attribute: .Bottom, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 10).active = true
    //
    // or:
    // NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view1][view2]-(10)-[view3]", options: 0, metrics: nil, views: ["view1": view1, "view2": view2, "view3": view3]))

### Inner view

    activate(view == view1 + UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

    // same as:
    // NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view1, attribute: .Top, multiplier: 1, constant: -10).active = true
    // NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: view1, attribute: .Left, multiplier: 1, constant: -10).active = true
    // NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: view1, attribute: .Bottom, multiplier: 1, constant: 10).active = true
    // NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: view1, attribute: .Right, multiplier: 1, constant: 10).active = true

### Inner view (only horizontal constraints)

    activate(view == view1 + UIEdgeInsets(top: .NaN, left: 10, bottom: .NaN, right: 10))

    // same as:
    // NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: view1, attribute: .Left, multiplier: 1, constant: -10).active = true
    // NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: view1, attribute: .Right, multiplier: 1, constant: 10).active = true

### Inner view (centering)

    activate((view1, view2) == [.CenterX, .CenterY])

    // same as:
    // NSLayoutConstraint(item: view2, attribute: .CenterX, relatedBy: .Equal, toItem: view1, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    // NSLayoutConstraint(item: view2, attribute: .CenterY, relatedBy: .Equal, toItem: view1, attribute: .CenterY, multiplier: 1, constant: 0).actie = true

### Priority
    view1 ~ .Top == view2 ~ .Top ! 500
    view == CGSize(width: 100, height: 200) ! 250

### Others

See test code.  
[https://github.com/kzms/Crew/blob/develop/CrewTests/AutoLayoutDSLTest.swift](https://github.com/kzms/Crew/blob/develop/CrewTests/AutoLayoutDSLTest.swift)
