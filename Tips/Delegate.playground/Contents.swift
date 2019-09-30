import UIKit

protocol ButtonDelegate {
    func audio()
    func background()
}

class Button {
    var delegate: ButtonDelegate? = nil //デリゲートを保持
    func click() {
        if let dg = self.delegate {
            dg.audio()
            dg.background()
        }
    }
}

extension Button: ButtonDelegate {
    func audio() {
        print("sound")
    }
    func background() {
        print("show background")
    }
}

let button = Button()
button.delegate = button
button.click()
