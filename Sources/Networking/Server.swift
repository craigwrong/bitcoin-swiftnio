import NIOPosix
import NIOCore
import Model

public func runServer(port: Int) async throws {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

    let serverChannel = try await ServerBootstrap(group: eventLoopGroup)
        .bind(
            host: "127.0.0.1",
            port: port
        ) { channel in
            // This closure is called for every inbound connection
            channel.pipeline.addHandlers([ByteToMessageHandler(MessageCoder()), MessageToByteHandler(MessageCoder())])
            .eventLoop.makeCompletedFuture {
                try NIOAsyncChannel<Message, Message>(
                    wrappingChannelSynchronously: channel
                )
            }
        }


    try await withThrowingDiscardingTaskGroup { group in

        try await serverChannel.executeThenClose { serverChannelInbound in

            for try await connectionChannel in serverChannelInbound {

                print("(1) Received connection from: \(connectionChannel.channel.remoteAddress?.description ?? "<Unknown Address>")")

                group.addTask {
                    do {
                        try await connectionChannel.executeThenClose {
                            try await handleIO($0, $1)
                        }
                    } catch {
                        // Handle errors
                    }
                }
            }
        }
    }
}
