package ua.boretskyi.dto;

import lombok.Data;

@Data
public class AuthenticationResponseDto {

    private final String email;
    private final String token;
}
