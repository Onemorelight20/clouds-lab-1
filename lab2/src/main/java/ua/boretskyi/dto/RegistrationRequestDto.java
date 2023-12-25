package ua.boretskyi.dto;

import ua.boretskyi.domain.UserEntity;
import lombok.Data;

@Data
public class RegistrationRequestDto {

    private final String email;
    private final String username;
    private final String password;

    public UserEntity toUser() {
        UserEntity user = new UserEntity();
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(password);
        return user;
    }

}
