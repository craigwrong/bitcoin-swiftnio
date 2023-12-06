import ArgumentParser

@main
struct BitcoinP2P: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A Bitcoin Peer-to-Peer protocol server and client for testing purposes.",
        version: "1.0.0",
        subcommands: [Server.self, Client.self],
        defaultSubcommand: Server.self)
}
