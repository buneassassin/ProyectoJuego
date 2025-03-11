import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imvSplach: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imvSplach.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        imvSplach.alpha = 1.0
        imvSplach.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let finalScale: CGFloat = 1.5
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        
            self.imvSplach.transform = CGAffineTransform(scaleX: finalScale, y: finalScale)

            self.imvSplach.alpha = 0.0
        }) { (finished) in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
        }
    }
}
