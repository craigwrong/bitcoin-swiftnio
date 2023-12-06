import NIOPosix
import NIOCore
import Model

public func runClient(port: Int, message: String) async throws {
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    let clientChannel = try await ClientBootstrap(group: eventLoopGroup)
        .connect(
            host: "127.0.0.1",
            port: port
        ) { channel in
            channel.pipeline.addHandler(MessageToByteHandler(MessageCoder())).flatMap {
                channel.pipeline.addHandler(ByteToMessageHandler(MessageCoder()))
            }
            .eventLoop.makeCompletedFuture {
                try NIOAsyncChannel<Message, Message>(
                    wrappingChannelSynchronously: channel
                )
            }
        }

    try await clientChannel.executeThenClose {
        try await handleIO(isClient: true, $0, $1)
    }
}
