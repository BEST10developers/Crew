#if os(iOS)
    import UIKit
    public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
    import AppKit
    public typealias LayoutPriority = NSLayoutPriority
#endif

extension NSLayoutConstraint {
    
    func withPriority(priority: LayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

}