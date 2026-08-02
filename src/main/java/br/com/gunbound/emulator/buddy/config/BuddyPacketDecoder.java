package br.com.gunbound.emulator.buddy.config;

import java.util.List;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

/**
 * Um decoder do Netty para o BuddyServer. Ele lê o tamanho do pacote do
 * cabeçalho e garante que o pacote inteiro seja recebido antes de passá-lo para
 * o próximo handler. A estrutura esperada é [Tamanho (2 bytes)] + [Opcode (2
 * bytes)] + [Payload].
 */
public class BuddyPacketDecoder extends ByteToMessageDecoder {

	private static final int HEADER_SIZE = 4; // Tamanho (2 bytes) + Opcode (2 bytes)

	@Override
	protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) {
		// Para ler o tamanho do pacote, precisamos de pelo menos 2 bytes.
		if (in.readableBytes() < 2) {
			return; // Não há bytes suficientes para ler o campo de tamanho.
		}

		in.markReaderIndex();

		// Lê o tamanho total do pacote (os primeiros 2 bytes, little-endian).
		int packetSize = in.readUnsignedShortLE();

		// Validação de sanidade: o tamanho não pode ser menor que o cabeçalho
		if (packetSize < HEADER_SIZE) {
			// Pacote inválido, talvez fechar a conexão ou descartar bytes.
			// Por simplicidade, vamos resetar e esperar.
			in.resetReaderIndex();
			return;
		}

		// Verifica se temos o pacote completo no buffer.
		if (in.readableBytes() < packetSize - 2) { // O tamanho já foi lido, então subtraímos 2.
			in.resetReaderIndex(); // Volta para a posição marcada e espera por mais dados.
			return;
		}

		// Se chegamos aqui, temos o pacote completo. Lê o restante (Opcode + Payload).
		ByteBuf completePacket = in.readBytes(packetSize - 2);
		out.add(completePacket); // Passa o pacote para o próximo handler.
	}
}