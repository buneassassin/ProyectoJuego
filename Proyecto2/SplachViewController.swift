import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imvSplach: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Inicia la imagen en un tamaño muy pequeño y centrada
        imvSplach.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        imvSplach.alpha = 1.0
        imvSplach.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animación de 3 segundos usando keyframes para simular la "bomba a punto de explotar"
        UIView.animateKeyframes(withDuration: 3.0, delay: 0, options: [.calculationModeCubic], animations: {
            
            // Primer tramo: crece rápidamente hasta 1.3 veces su tamaño original (acumulando energía)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.imvSplach.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
            
            // Segundo tramo: pulsa hasta 1.6 (como si estuviera a punto de explotar)
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                self.imvSplach.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            }
            
            // Tercer tramo: se desvanece rápidamente (la explosión)
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                self.imvSplach.alpha = 0.0
            }
            
        }, completion: { finished in
            // Al finalizar, espera un momento y realiza el segue
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
        })
    }
}
