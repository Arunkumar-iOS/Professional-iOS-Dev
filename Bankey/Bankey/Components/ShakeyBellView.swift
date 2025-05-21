//
//  ShakeyBellView.swift
//  Bankey
//
//  Created by Arunkumar on 21/05/25.
//

import UIKit


class ShakeyBellView: UIView {
    
    
    let bellImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bell.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let size: CGFloat = UIScaler.scaled(40)
    
    override var intrinsicContentSize: CGSize {
        .init(width: size, height: size)
    }
}

extension ShakeyBellView {
    
    private func style() {
        addGesture()
    }
    
    private func addGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bellIconTapped(_:)))
        
        bellImageView.isUserInteractionEnabled = true
        bellImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func layout() {
        addSubview(bellImageView)
        
        NSLayoutConstraint.activate([
            bellImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bellImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bellImageView.heightAnchor.constraint(equalToConstant: UIScaler.scaled(24)),
            bellImageView.widthAnchor.constraint(equalTo: bellImageView.heightAnchor)
        ])
    }
}


// MARK: - Actions
extension ShakeyBellView {
    @objc func bellIconTapped(_ recognizer: UITapGestureRecognizer) {
        shakeWith(duration: 1.0, angle: .pi/8, yOffset: 0.0)
    }

    private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
        let numberOfFrames: Double = 6
        let frameDuration = Double(1/numberOfFrames)
        
        bellImageView.setAnchorPoint(CGPoint(x: 0.5, y: yOffset))

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [],
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*2,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*3,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*4,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*5,
                               relativeDuration: frameDuration) {
                self.bellImageView.transform = CGAffineTransform.identity
            }
          },
          completion: nil
        )
    }
}

// https://www.hackingwithswift.com/example-code/calayer/how-to-change-a-views-anchor-point-without-moving-it
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
