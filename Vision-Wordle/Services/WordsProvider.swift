import Foundation

enum WordsProviderError: Error {
    case fileNotFound
    case errorReadingFile
}

struct WordsProvider {
    func getWord() throws -> String {
        let filemanager = FileManager.default
        let path = Bundle.main.path(forResource: "", ofType: "txt")

        if filemanager.fileExists(atPath: path!) {
            do {
                let fullText = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                let readings = fullText.components(separatedBy: "\n")
                let randomIndex = Int(arc4random_uniform(UInt32(readings.count)))
                return readings[randomIndex].uppercased()
            } catch {
                print("Error reading file")
            }
        } else {
            print("File not found")
            throw WordsProviderError.fileNotFound
        }

        throw WordsProviderError.errorReadingFile
    }
}
