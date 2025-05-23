//
//  SkeletonLoadable.swift
//  Bankey
//
//  Created by Arunkumar on 22/05/25.
//

import UIKit

/*
 Functional programming inheritance.
 */

protocol SkeletonLoadable {}

extension SkeletonLoadable {
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animationDuration: CFTimeInterval = 1.5

        // First phase: light to dark
        let fadeToDark = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        fadeToDark.fromValue = UIColor.gradientLightGrey.cgColor
        fadeToDark.toValue = UIColor.gradientDarkGrey.cgColor
        fadeToDark.duration = animationDuration
        fadeToDark.beginTime = 0.0

        // Second phase: dark back to light
        let fadeToLight = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        fadeToLight.fromValue = UIColor.gradientDarkGrey.cgColor
        fadeToLight.toValue = UIColor.gradientLightGrey.cgColor
        fadeToLight.duration = animationDuration
        fadeToLight.beginTime = fadeToDark.beginTime + fadeToDark.duration

        // Grouping both animations
        let group = CAAnimationGroup()
        group.animations = [fadeToDark, fadeToLight]
        group.duration = fadeToLight.beginTime + fadeToLight.duration
        group.repeatCount = .greatestFiniteMagnitude
        group.isRemovedOnCompletion = false

        // Optional staggered start time
        if let previous = previousGroup {
            group.beginTime = previous.beginTime + 0.33
        }

        return group
    }
    
    

}

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}


extension UIView {
    func startShimmering() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.lightGray.withAlphaComponent(0.6).cgColor,
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.lightGray.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.name = "shimmerLayer"

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .greatestFiniteMagnitude

        gradientLayer.add(animation, forKey: "shimmerAnimation")
        self.layer.addSublayer(gradientLayer)
    }

    func stopShimmering() {
        self.layer.sublayers?.removeAll(where: { $0.name == "shimmerLayer" })
    }
}
