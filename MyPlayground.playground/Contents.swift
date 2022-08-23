import UIKit

class ButtonBuilder {
    private var button: Button
    init () {
        button = Button(props: Button.Props(style: .ghost))
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    func title(with title: String) -> Button {
        button.setTitle(title, for: .normal)
        return button
    }

    func addTarget(function: Selector) -> Button {
        button.addTarget(self, action: #selector(@objc function), for: .touchUpInside)
        return button
    }

    func build() -> Button {
        return button
    }
}

bar
