import UIKit

extension UIView {

    func addShadow(to side: ShadowSide) {
        var offset: CGSize {
            switch side {
            case .bottom:
                return CGSize(width: 0, height: -2)
            case .top:
                return CGSize(width: 0, height: 2)
            case .left:
                return CGSize(width: -2, height: 0)
            case .right:
                return CGSize(width: 2, height: 0)
            }
        }
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.9
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }

    func roundCorners(){
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
