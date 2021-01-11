//
//  ViewController.swift
//  AVMIDIPlayerSanityCheck
//
//  Created by Haris Ali on 1/11/21.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .medium)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    /// The `AVMIDIPlayer` that will trigger the crash. This is using a
    /// multi-track MIDI file (complicated) using a open source sound
    /// font. Note that you can change this to another one of the sound
    /// fonts in this example project (sounds.sf2) and it will still crash
    /// around half-way through the whole song.
    let player: AVMIDIPlayer = {
        let bundle = Bundle.main
        let midi = bundle.url(forResource: "Complicated", withExtension: "mid")!
        let soundBankURL = bundle.url(forResource: "TimGM6mb", withExtension: "sf2")!
        let player = try! AVMIDIPlayer(contentsOf: midi, soundBankURL: soundBankURL)
        player.prepareToPlay()
        return player
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Note this will not work in the simulator. Please run on real device."
        label.textColor = .lightText
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    /// Represents the rough number of seconds before the crash starts
    /// so the UI has something to display instead of no sound in the
    /// first couple seconds.
    let secondsUntilCrash: TimeInterval = 19
    
    /// After playback begins this label displays the number of seonds
    /// until the expected crash will occur.
    let secondsUntilCrashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    /// Used to update the seconds until crash label after playback
    /// has began.
    public private(set) var secondsUntilCrashTimer: Timer?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layout constraints
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(secondsUntilCrashLabel)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250),
        ])
        
        // Setup actions
        playButton.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
    }
    
    // MARK: Methods (Private)
    
    @objc private func onPlay(_ sender: UIButton) {
        
        if player.isPlaying {
            
            // Actually stop the player
            player.stop()
            
            // Set play button title
            playButton.setTitle("Play", for: .normal)
            
        } else {
            
            // Start tracking the play date so we can show the countdown
            // until the player fails.
            secondsUntilCrashTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else {
                    return
                }
                let interval = max(self.secondsUntilCrash - self.player.currentPosition, 0)
                self.secondsUntilCrashLabel.text = String(format: "%.0f seconds until crash...", interval)
            }
            
            // Actually start the player
            player.play { [weak self] in
                guard let self = self else {
                    return
                }
                self.secondsUntilCrashTimer?.invalidate()
                self.secondsUntilCrashTimer = nil
            }
            
            // Set play button title
            playButton.setTitle("Stop", for: .normal)
            
        }
    }

}

