package ua.boretskyi.dto;

import ua.boretskyi.domain.UserEntity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AdminUserDto {

	private Long id;
	private String username;
	private String email;
	private String password;

	
	public UserEntity toUser() {
		UserEntity user = new UserEntity();
		user.setId(id);
		user.setEmail(email);
		user.setUsername(username);
		user.setPassword(password);
		
		return user;
	}
	
	public static AdminUserDto fromUser(UserEntity user) {
		AdminUserDto userDto = new AdminUserDto();
		userDto.setId(user.getId());
		userDto.setUsername(user.getUsername());
		userDto.setEmail(user.getEmail());
		userDto.setPassword(user.getPassword());
		
		return userDto;
	}

}

