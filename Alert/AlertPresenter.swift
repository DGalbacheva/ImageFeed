//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 18.06.2024.
//

import UIKit

final class AlertPresenter {
    func presentAlert(on vc: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        vc.present(alert, animated: true, completion: nil)
    }
}
