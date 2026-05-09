import Foundation
import AVFoundation

@Observable
final class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playPop() {
        guard UserDefaults.standard.soundEnabled else { return }
        guard let url = generatePopSoundURL() else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.6
            audioPlayer?.play()
        } catch {}
    }

    func playLevelUp() {
        guard UserDefaults.standard.soundEnabled else { return }
        guard let url = generateLevelUpSoundURL() else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.8
            audioPlayer?.play()
        } catch {}
    }

    private func generatePopSoundURL() -> URL? {
        let sampleRate: Double = 44100
        let duration: Double = 0.08
        let totalSamples = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: totalSamples)
        for i in 0..<totalSamples {
            let t = Double(i) / sampleRate
            let envelope = exp(-t * 50)
            samples[i] = Float(sin(2 * .pi * 800 * t) * envelope * 0.5)
        }
        return writeWAV(samples: samples, sampleRate: sampleRate, filename: "pop.wav")
    }

    private func generateLevelUpSoundURL() -> URL? {
        let sampleRate: Double = 44100
        let duration: Double = 0.4
        let totalSamples = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: totalSamples)
        for i in 0..<totalSamples {
            let t = Double(i) / sampleRate
            let envelope = exp(-t * 5)
            let freq = 523.25 + t * 400
            samples[i] = Float(sin(2 * .pi * freq * t) * envelope * 0.4)
        }
        return writeWAV(samples: samples, sampleRate: sampleRate, filename: "levelup.wav")
    }

    private func writeWAV(samples: [Float], sampleRate: Double, filename: String) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        let totalSamples = samples.count
        let dataSize = UInt32(totalSamples * 2)
        let fileSize = UInt32(36 + dataSize)
        var header = Data()
        header.append(contentsOf: [UInt8]("RIFF".utf8))
        header.append(contentsOf: withUnsafeBytes(of: fileSize.littleEndian) { Array($0) })
        header.append(contentsOf: [UInt8]("WAVE".utf8))
        header.append(contentsOf: [UInt8]("fmt ".utf8))
        header.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate * 2).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt16(2).littleEndian) { Array($0) })
        header.append(contentsOf: withUnsafeBytes(of: UInt16(16).littleEndian) { Array($0) })
        header.append(contentsOf: [UInt8]("data".utf8))
        header.append(contentsOf: withUnsafeBytes(of: dataSize.littleEndian) { Array($0) })
        var sampleData = Data()
        for sample in samples {
            let clipped = max(-1.0, min(1.0, sample))
            let intSample = Int16(clipped * 32767)
            sampleData.append(contentsOf: withUnsafeBytes(of: intSample.littleEndian) { Array($0) })
        }
        let wavData = header + sampleData
        do {
            try wavData.write(to: url)
            return url
        } catch {
            return nil
        }
    }
}
