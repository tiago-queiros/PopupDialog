import Foundation

final public class PopupMargins: NSObject {
    var top: CGFloat?
    var bottom: CGFloat?
    var left: CGFloat
    var right: CGFloat

    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}

func == (lhs: PopupMargins, rhs: PopupMargins) -> Bool {
    return lhs.bottom == rhs.bottom && lhs.top == rhs.top && lhs.left == rhs.left && lhs.right == rhs.right
}
