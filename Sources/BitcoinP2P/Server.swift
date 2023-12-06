import ArgumentParser
import Networking

struct Server: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "Launch a server instance."
    )

    @Option(name: .shortAndLong, help: "The TCP port number to bind the server instance to.")
    var port: Int = 1234

    mutating func run() async throws {
        try await runServer(port: port)
    }
}
