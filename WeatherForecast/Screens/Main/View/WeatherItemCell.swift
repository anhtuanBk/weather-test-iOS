//
//  WeatherItemCell.swift
//  WeatherForecast


import UIKit
import SnapKit
import AlamofireImage

final class WeatherItemCell: UITableViewCell {
    private let stackView = UIStackView().configure { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
    }
    private let infoStackView = UIStackView().configure { stackView in
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView().configure { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        infoStackView.addArrangedSubviews(dateLabel, temperatureLabel, pressureLabel, humidityLabel, descriptionLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(infoStackView, iconImageView)
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
    }
    
    func update(with uiModel: WeatherForecastUIModel?) {
        dateLabel.text = uiModel?.date
        temperatureLabel.text = uiModel?.temperature
        pressureLabel.text = uiModel?.pressure
        humidityLabel.text = uiModel?.humidity
        descriptionLabel.text = uiModel?.description
        if let icon = uiModel?.icon,
           let iconUrl = URL(string: icon) {
            iconImageView.af.setImage(withURL: iconUrl)
        }
    }
}
