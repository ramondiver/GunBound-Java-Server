package br.com.gunbound.emulator.buddy.config.enums;

/**
 * Define os possíveis estados de uma sessão de jogador,
 * controlando o que ele pode fazer em cada etapa da conexão.
 */
public enum BuddySessionState {
    CONNECTED,                  // Apenas conectou, aguardando handshake
    AWAITING_CRYPTO_BLOB,       // Enviou o 1001, aguardando os 82 bytes
    HANDSHAKE_COMPLETE,         // Handshake criptográfico concluído, aguardando login
    AUTHENTICATED,              // Logado com sucesso, está no lobby de canais
    IN_LOBBY_CHANNEL,           // Entrou em um canal de lobby
    IN_GAME_ROOM,               // Entrou em uma sala de jogo
    PLAYING                     // Partida em andamento
}