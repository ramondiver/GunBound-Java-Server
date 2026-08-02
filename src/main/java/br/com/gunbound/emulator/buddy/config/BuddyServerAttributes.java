package br.com.gunbound.emulator.buddy.config;

import br.com.gunbound.emulator.buddy.entities.BuddyPlayerSession;
import io.netty.util.AttributeKey;

public final class BuddyServerAttributes {
	// A chave para associar um objeto PlayerSession a um Channel.
	public static final AttributeKey<BuddyPlayerSession> BUDDY_PLAYER_SESSION_KEY = AttributeKey.valueOf("BuddyPlayerSession");
}
