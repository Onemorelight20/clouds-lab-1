package ua.boretskyi.dto;

import lombok.Data;
@Data
public class AuthenticationRequestDto {

	private final String email;
	private final String password;

}
