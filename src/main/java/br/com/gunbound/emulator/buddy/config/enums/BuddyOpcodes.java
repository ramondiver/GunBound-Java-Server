package br.com.gunbound.emulator.buddy.config.enums;

import java.util.HashMap;
import java.util.Map;

/**
 * Enumeração para os OpCodes utilizados no sistema GunBound.
 */
public enum BuddyOpcodes {
    // --- Handshake & Sessão ---
    BUDDY_AUTHTOKEN_REQ(0x1000),
    BUDDY_AUTHTOKEN_RESPONSE(0x1001), // Opcode que o servidor ENVIA
    BUDDY_SESSION_AUTHENTICATION(0x1010), // SVC_LOGIN
    BUDDY_SESSION_AUTHENTICATION_REPLY(0x1011), // SVC_LOGIN
    BUDDY_UDP_ACK(0x101F),           // ADICIONADO: Confirmação do registro UDP
    
    // --- Amigos ---
    BUDDY_ADD_GETINFO_REQUEST(0x3000),      // SVC_RESP_ADD_BUDDY
    BUDDY_ADD_GETINFO_RESP(0x3001),      // SVC_RESP_ADD_BUDDY
    SVC_USER_STATE(0x3010),      // SVC_USER_STATE
    
    BUDDY_REMOVE_REQUEST(0x3002),   // SVC_REMOVE_BUDDY
    BUDDY_GROUP_REQUEST(0x3004),    // SVC_GROUP_BUDDY
    BUDDY_RENAME_GROUP_REQUEST(0x3006), // SVC_RENAME_GROUP

    // --- Status e Busca ---
    BUDDY_SEARCH_REQUEST(0x4000),     // SVC_SEARCH
    //BUDDY_USER_STATE_CHANGE(0x3010), // SVC_USER_STATE

    // --- Correio / Pacotes Offline ---
    BUDDY_SAVE_PACKET(0x2000),
    BUDDY_DELETE_PACKET(0x2011),
    
    // --- Outros ---
    BUDDY_TUNNEL_PACKET(0x2020),
    BUDDY_TUNNEL_PACKET_RESP(0x2021),
    
    BUDDY_STATUS_SYNC(0x3FFF),      // Resposta de Sincronização de Status
	
	BUDDY_KEEPALIVE(0x00),      // KeepAlive
	
	UNKNOWN(0xFF); // Usado para comando desconhecido não listado acima

    private final int id;

    // Mapa para busca rápida do opcode pelo ID
    private static final Map<Integer, BuddyOpcodes> BY_ID = new HashMap<>();

    // Bloco estático para preencher o mapa quando a classe for carregada
    static {
        for (BuddyOpcodes opcode : values()) {
            BY_ID.put(opcode.id, opcode);
        }
    }

    // Construtor para associar o valor do id a cada opcode
    BuddyOpcodes(int id) {
        this.id = id;
    }

    // Método para acessar o valor do id de cada opcode
    public int getId() {
        return id;
    }

    /**
     * Obtém um Opcode a partir de seu ID numérico.
     *
     * @param id O ID do opcode.
     * @return O Opcode correspondente, ou null se o ID não for encontrado.
     */
    public static BuddyOpcodes fromId(int id) {
        return BY_ID.getOrDefault(id, UNKNOWN);  // Retorna null se não encontrar o opcode correspondente
    }
}

