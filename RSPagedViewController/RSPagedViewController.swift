//
//  RSPagedViewController.swift
//  RSPagedViewController
//
//  Created by Rodrigo Soldi on 12/07/18.
//  Copyright © 2018 Soldi Inc. All rights reserved.
//

import Foundation

public protocol RSPagedViewControllerDelegate: class {
    func viewControllersForDisplay(pagedViewController: RSPagedViewController) -> [UIViewController]
    func titlesForDisplay(pagedViewController: RSPagedViewController) -> [String]
}

public class RSPagedViewController: UIViewController {
    
    public weak var delegate: RSPagedViewControllerDelegate?
    
    public var viewControllers: [UIViewController]? {
        didSet {
            self.countOfItems = viewControllers?.count ?? 0
            setupViewControllers()
        }
    }
    
    public var titles: [String]?
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewflowLayout = UICollectionViewFlowLayout()
        collectionViewflowLayout.scrollDirection = .horizontal
        collectionViewflowLayout.minimumInteritemSpacing = 0
        collectionViewflowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewflowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var segmentedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private lazy var animatedSegmentedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var bottomLineSegmentedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.viewControllers = self.delegate?.viewControllersForDisplay(pagedViewController: self)
        self.titles = self.delegate?.titlesForDisplay(pagedViewController: self)
        
        addSubviews()
        setupConstraints()
        setupStackViews()
        registerCells()
    }
    
    @objc private func didTapButton(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.leadingConstraintAnimatedSegmentedView.constant = scrollView.contentOffset.x / CGFloat(countOfItems)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.segmentedView.layoutIfNeeded()
        }, completion: nil)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func addSubviews() {
        self.view.addSubview(self.segmentedView)
        self.segmentedView.addSubview(self.bottomLineSegmentedView)
        self.segmentedView.addSubview(self.animatedSegmentedView)
        self.segmentedView.addSubview(self.segmentedStackView)
        self.view.addSubview(self.collectionView)
    }
    
    func setupStackViews() {
        for index in 0..<self.countOfItems {
            
            let button = UIButton()
            button.tag = index
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            button.setTitle(self.titles?[index] ?? "", for: .normal)
            button.addTarget(self, action: #selector(RSPagedViewController.didTapButton(sender:)), for: .touchUpInside)
            self.segmentedStackView.addArrangedSubview(button)
            
            if index != 0 {
                let lineView = UIView()
                lineView.backgroundColor = .lightGray
                lineView.translatesAutoresizingMaskIntoConstraints = false
                lineView.alpha = 0.5
                view.addSubview(lineView)

                lineView.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
                lineView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8).isActive = true
                lineView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8).isActive = true
                lineView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
            }
        }
    }
    
    private func setupConstraints() {
        
        self.segmentedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.segmentedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.segmentedView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        self.segmentedView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.bottomLineSegmentedView.leadingAnchor.constraint(equalTo: self.segmentedView.leadingAnchor).isActive = true
        self.bottomLineSegmentedView.trailingAnchor.constraint(equalTo: self.segmentedView.trailingAnchor).isActive = true
        self.bottomLineSegmentedView.bottomAnchor.constraint(equalTo: self.segmentedView.bottomAnchor).isActive = true
        self.bottomLineSegmentedView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        self.leadingConstraintAnimatedSegmentedView = self.animatedSegmentedView.leadingAnchor.constraint(equalTo: self.segmentedView.leadingAnchor)
        self.leadingConstraintAnimatedSegmentedView.isActive = true
        self.animatedSegmentedView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        self.animatedSegmentedView.bottomAnchor.constraint(equalTo: self.segmentedView.bottomAnchor).isActive = true
        self.animatedSegmentedView.widthAnchor.constraint(equalTo: self.segmentedView.widthAnchor, multiplier: CGFloat(1.0/CGFloat(countOfItems))).isActive = true
            
        self.segmentedStackView.leadingAnchor.constraint(equalTo: self.segmentedView.leadingAnchor).isActive = true
        self.segmentedStackView.trailingAnchor.constraint(equalTo: self.segmentedView.trailingAnchor).isActive = true
        self.segmentedStackView.topAnchor.constraint(equalTo: self.segmentedView.topAnchor).isActive = true
        self.segmentedStackView.bottomAnchor.constraint(equalTo: self.segmentedView.bottomAnchor).isActive = true
        
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.segmentedView.bottomAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    private func setupViewControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                self.addChildViewController(viewController)
                viewController.didMove(toParentViewController: self)
            }
        }
    }
    
    private func registerCells() {
        self.collectionView.register(RSPagedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.reloadData()
        if let indexPath = self.lastIndexPath {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private var countOfItems = 0
    private var leadingConstraintAnimatedSegmentedView: NSLayoutConstraint!
    private var lastIndexPath: IndexPath?
    
}

extension RSPagedViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.countOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RSPagedCollectionViewCell else {
            fatalError("Cell must be exists")
        }
        
        if let viewControllers = self.viewControllers {
            let viewController = viewControllers[indexPath.item]
            
            if !cell.subviews.contains(viewController.view) {
                cell.addSubview(viewController.view)
                viewController.view.translatesAutoresizingMaskIntoConstraints = false
                viewController.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
                viewController.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
                viewController.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
                viewController.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.lastIndexPath = indexPath
    }
    
}

extension RSPagedViewController: UICollectionViewDelegate {
    
}

extension RSPagedViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
}


