package ua.boretskyi.configuration;

import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import ua.boretskyi.security.jwt.JwtConfigurer;
import ua.boretskyi.security.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;

import java.util.List;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	private final JwtTokenProvider jwtTokenProvider;
	
	private static final String ADMIN_ENDPOINT = "/admin/**";
	private static final String API_ENDPOINT = "/api/**";
	private static final String AUTH_ENDPOINT = "/auth/**";
	private static final String HEALTH_ENDPOINT = "/health/**";
	private static final String[] AUTH_WHITELIST = {
			"/swagger-ui/**",
			"/swagger-resources/**",
			"/swagger-ui.html",
			"/v3/api-docs/**",
			"/v3/api-docs/swagger-config",
			"/api-docs/**",
			"/webjars/**"
	};

	@Bean
	@Override
	public AuthenticationManager authenticationManagerBean() throws Exception {
		return super.authenticationManagerBean();
	}

	@Bean
	CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration configuration = new CorsConfiguration();
		configuration.setAllowedOrigins(List.of("*"));
		configuration.setAllowedMethods(List.of("*"));
		configuration.setAllowedHeaders(List.of("*"));
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", configuration);
		return source;
	}
	
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
			.httpBasic().disable()
			.csrf().disable()
			.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
				.and()
			.authorizeRequests()
			.antMatchers(AUTH_ENDPOINT, HEALTH_ENDPOINT).permitAll()
			.antMatchers(AUTH_WHITELIST).permitAll()
			.antMatchers(ADMIN_ENDPOINT).hasAuthority("ADMIN")
			.antMatchers(API_ENDPOINT).hasAnyAuthority("USER", "ADMIN")
			.anyRequest().authenticated()
				.and()
			.apply(new JwtConfigurer(jwtTokenProvider));
		
	}
}
