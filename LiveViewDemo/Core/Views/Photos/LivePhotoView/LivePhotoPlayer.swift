//
//  LivePhotoPlayer.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class LivePhotoPlayer: UIView, PHLivePhotoViewDelegate {
    // MARK: - Properties
    private let livePhotoView = PHLivePhotoView()
    private let playButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return button
    }()
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "play.circle")
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    private var __flag_for_live_preview = false
    private var isPlaying: Bool {
        get { __flag_for_live_preview }
        set {
            imageView.isHidden = newValue
            __flag_for_live_preview = newValue
        }
    }

    // MARK: - Initializer
    init(photo: PHLivePhoto) {
        super.init(frame: .zero)
        livePhotoView.livePhoto = photo
        livePhotoView.delegate = self
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(livePhotoView)
        addSubview(playButton)
        addSubview(imageView)

        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchDown)
        playButton.addTarget(self, action: #selector(playButtonReleased), for: [.touchUpInside, .touchUpOutside])
    }

    private func setupConstraints() {
        livePhotoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            livePhotoView.topAnchor.constraint(equalTo: topAnchor),
            livePhotoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            livePhotoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            livePhotoView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: livePhotoView.widthAnchor, multiplier: 1.0),
            playButton.heightAnchor.constraint(equalTo: livePhotoView.heightAnchor, multiplier: 1.0)
        ])
    }

    // MARK: - Actions
    @objc private func playButtonPressed() {
        isPlaying = true
        playButton.isHidden = true
        livePhotoView.startPlayback(with: .full)
    }

    @objc private func playButtonReleased() {
        if isPlaying {
            playButton.isHidden = false
            isPlaying = false
        }
    }

    // MARK: - PHLivePhotoViewDelegate
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        playButton.isHidden = false
        isPlaying = false
    }
}
