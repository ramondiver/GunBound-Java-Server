package br.com.gunbound.emulator.buddy.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufUtil;
import io.netty.channel.ChannelDuplexHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelPromise;

public class BuddyPacketLoggerHandler extends ChannelDuplexHandler {

	private static final Logger logger = LoggerFactory.getLogger(BuddyPacketLoggerHandler.class);

	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
		if (msg instanceof ByteBuf) {
			logPacket(ctx, "RECV", (ByteBuf) msg);
		}
		// Passa a mensagem para o próximo handler no pipeline
		ctx.fireChannelRead(msg);
	}

	@Override
	public void write(ChannelHandlerContext ctx, Object msg, ChannelPromise promise) throws Exception {
		if (msg instanceof ByteBuf) {
			logPacket(ctx, "SEND", (ByteBuf) msg);
		}
		// Passa a mensagem para o próximo handler no pipeline
		ctx.write(msg, promise);
	}

	private void logPacket(ChannelHandlerContext ctx, String direction, ByteBuf buf) {
		String remoteAddress = ctx.channel().remoteAddress().toString();
		int length = buf.readableBytes();
		// Usamos duplicate() para não alterar o readerIndex do buffer original
		String hexdump = ByteBufUtil.prettyHexDump(buf.duplicate());

		StringBuilder logMessage = new StringBuilder();
		logMessage.append("\n--- Packet ").append(direction).append(" ---\n");
		logMessage.append("From/To: ").append(remoteAddress).append("\n");
		logMessage.append("Length: ").append(length).append(" bytes\n");
		logMessage.append(hexdump);
		logMessage.append("\n--------------------");

		logger.info(logMessage.toString());
	}
}