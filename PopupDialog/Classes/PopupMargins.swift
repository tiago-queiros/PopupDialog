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

    public init(right: CGFloat, left: CGFloat) {
        self.left = left
        self.right = right
    }
}
