package ua.boretskyi.service;

import ua.boretskyi.domain.UserEntity;

import java.util.List;
import java.util.Optional;

public interface UserService {

	UserEntity register(UserEntity user);
	
	List<UserEntity> getAll();

	UserEntity findByEmail(String email);
	
	Optional<UserEntity> findById(Long id);
	
	void delete(Long id);
}
