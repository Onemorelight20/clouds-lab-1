package ua.boretskyi.security;

import ua.boretskyi.domain.UserEntity;
import ua.boretskyi.security.jwt.JwtUser;
import ua.boretskyi.security.jwt.JwtUserFactory;
import ua.boretskyi.service.UserService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class JwtUserDetailsService implements UserDetailsService {

	private static final Logger log = LoggerFactory.getLogger(JwtUserDetailsService.class);

	private final UserService userService;


	@Override
	public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
		UserEntity user = userService.findByEmail(email);
		if(user == null) {
			throw new UsernameNotFoundException("User with email " + email + " was not found.");
		}
		
		JwtUser jwtUser = JwtUserFactory.create(user);
		log.info("IN loadUserByUsername(String email) user with mail {} was loaded", email);
		
		return jwtUser;
	}

}
