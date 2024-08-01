//
//  DetailView.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class DetailView: UIView {
    private(set) lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var weightlabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var heightlabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var favouriteButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        button.isHidden = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .semibold, scale: .large)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config)?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: config)?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onTap: ((_ data:PokemonDetailModel) -> Void)?
    var data: PokemonDetailModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(heightlabel)
        containerView.addSubview(weightlabel)
        containerView.addSubview(favouriteButton)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(data: PokemonDetailModel) {
        nameLabel.text = data.name
        heightlabel.text = "height: \(data.height) cm"
        weightlabel.text = "weight: \(data.weight) gm"
        if let url = data.sprites.frontDefault, (url != "") {
            imageView.getImage(from: URL(string: url)!)
        }
        favouriteButton.isHidden = false
        
        self.data = data
    }
    
    func updateImage(image: UIImage) {
        imageView.image = image
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightlabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            heightlabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weightlabel.topAnchor.constraint(equalTo: heightlabel.bottomAnchor, constant: 2),
            weightlabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: weightlabel.bottomAnchor, constant: 20),
            favouriteButton.centerXAnchor.constraint(equalTo: weightlabel.centerXAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func tapAction() {
        favouriteButton.isSelected.toggle()
        if let data = self.data {
            if let onTap = onTap {
                onTap(data)
            }
        }
    }
}
