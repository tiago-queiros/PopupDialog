import Foundation

final public class PopupMargins: NSObject {
    var top: CGFloat?
    var bottom: CGFloat?
    var left: CGFloat
    var right: CGFloat

    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }

    init(right: CGFloat, left: CGFloat) {
        self.left = left
        self.right = right
    }
}
