//
//  OnboardViewController.swift
//  Bankey
//
//  Created by Arunkumar on 15/05/25.
//

import UIKit

protocol OnboardContainerViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

class OnboardingContainerViewController: UIViewController {
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Close", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
        btn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let BackBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
        btn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    
    weak var delegate: OnboardContainerViewControllerDelegate?
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    //Notify whenever currentVC gets updated.
    var currentVC: UIViewController {
        didSet {
            guard let currentControllerIndex = pages.firstIndex(of: currentVC) else { return }
            BackBtn.isHidden = currentControllerIndex == 0 ? true : false
            nextBtn.setTitle(currentControllerIndex == pages.count - 1 ? "Done" : "Next", for: .normal)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardViewController(labelText: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in the 80s.", imageName: "delorean")
        let page2 = OnboardViewController(labelText: "Move your money around the world quickly and securely.", imageName: "thumbs")
        let page3 = OnboardViewController(labelText: "Learn more at www.bankey.com.", imageName: "world")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
}

extension OnboardingContainerViewController {
    
    private func style() {
        
        view.backgroundColor = .systemPurple
                
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView.addArrangedSubViews([BackBtn, UIView(), nextBtn])
        
        BackBtn.isHidden = true
    }
    
    private func layout() {
        //Embed child to the Parent
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(closeBtn)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            closeBtn.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            closeBtn.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }
}


    // MARK: - UIPageViewControllerDataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }
    
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}

//MARK:- Actions
extension OnboardingContainerViewController {
    
    @objc func closeBtnTapped() {
        delegate?.onboardingDidFinish()
    }
    
    @objc func nextBtnTapped() {
        if pages.last == currentVC {
            delegate?.onboardingDidFinish()
        }
        guard let currentViewController = getNextViewController(from: currentVC) else { return }
        pageViewController.setViewControllers([currentViewController], direction: .forward, animated: false, completion: nil)
    }
    
    @objc func backBtnTapped() {
        guard let currentViewController = getPreviousViewController(from: currentVC) else { return }
        pageViewController.setViewControllers([currentViewController], direction: .reverse, animated: false, completion: nil)
    }
}


extension UIStackView {
    
    func addArrangedSubViews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
