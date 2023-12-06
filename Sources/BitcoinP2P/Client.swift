import ArgumentParser
import Networking

struct Client: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "Connect to a running server."
    )

    @Option(name: .shortAndLong, help: "The server TCP port to connect to.")
    var port = 1234

    @Argument(help: "The server TCP port to connect to.")
    var message = "Hellooo"

    mutating func run() async throws {
        try await runClient(port: port, message: message)
    }
}
