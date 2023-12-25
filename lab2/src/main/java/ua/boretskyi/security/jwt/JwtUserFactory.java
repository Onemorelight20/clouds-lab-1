package ua.boretskyi.security.jwt;

import ua.boretskyi.domain.RoleEntity;
import ua.boretskyi.domain.UserEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.List;

public final class JwtUserFactory {

	public JwtUserFactory() {
	}

	public static JwtUser create(UserEntity user) {
		return new JwtUser(
				user.getId(), 
				user.getUsername(), 
				user.getEmail(), 
				user.getPassword(), 
				mapToGrantedAuthorities(user.getRoles()));
	}
	
	private static List<? extends GrantedAuthority> mapToGrantedAuthorities(List<RoleEntity> roles){
		return roles.stream().map(RoleEntity::getTitle)
				.map(SimpleGrantedAuthority::new).toList();
	}
}
