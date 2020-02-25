import Foundation
import UIKit
import NVActivityIndicatorView
import FirebaseStorage

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "HasAtLeastLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasAtLeastLaunchedOnce")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

extension UIViewController: NVActivityIndicatorViewable {
    func startLoading() {
        startAnimating()
    }
    
    func stopLoading() {
        stopAnimating()
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func alert(message: String, title: String = "", handler: @escaping (UIAlertAction) -> Void = {_ in }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func alertWithActions(message: String, title: String = "", actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for alertAction in actions {
            alert.addAction(alertAction)
        }

        self.present(alert, animated: true)
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = UIImage(named: "image-loading-state")
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        if urlString.isEmpty {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.getData(maxSize:  1 * 1024 * 1024) { (data, err) in
            if err != nil {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    }
                    
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
