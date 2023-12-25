package ua.boretskyi.dto;

import ua.boretskyi.domain.UserEntity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class UserDto {

	private Long id;
	private String username;
	private String email;

	public UserEntity toUser() {
		UserEntity user = new UserEntity();
		user.setId(id);
		user.setEmail(email);
		user.setUsername(username);
		
		return user;
	}
	
	public static UserDto fromUser(UserEntity user) {
		UserDto userDto = new UserDto();
		userDto.setId(user.getId());
		userDto.setUsername(user.getUsername());
		userDto.setEmail(user.getEmail());
		return userDto;
	}

	
}
