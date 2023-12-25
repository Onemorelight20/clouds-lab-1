package ua.boretskyi.service.impl;

import lombok.RequiredArgsConstructor;
import ua.boretskyi.domain.RoleEntity;
import ua.boretskyi.domain.UserEntity;
import ua.boretskyi.repository.RoleRepository;
import ua.boretskyi.repository.UserRepository;
import ua.boretskyi.service.UserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);
	private final UserRepository userRepo;
	private final RoleRepository roleRepo;
	private final BCryptPasswordEncoder passwordEncoder;

	
	@Override
	public UserEntity register(UserEntity user) {
		RoleEntity roleUser = roleRepo.findByTitle("USER");

		user.setRoles(List.of(roleUser));
		user.setPassword(passwordEncoder.encode(user.getPassword()));


		UserEntity registeredUSer = userRepo.save(user);

		log.info("IN register(User user) {} was successfully registered", registeredUSer);

		return registeredUSer;
	}

	@Override
	public List<UserEntity> getAll() {
		List<UserEntity> result = userRepo.findAll();
		log.info("IN getAll() {} users were found", result.size());
		return result;
	}

	@Override
	public UserEntity findByEmail(String email) {
		UserEntity result = userRepo.findByEmail(email);
		log.info("IN findByEmail(String email) user {} was found with email {}", result, email);
		return result;
	}

	@Override
	public Optional<UserEntity> findById(Long id) {
		return userRepo.findById(id);
	}

	@Override
	public void delete(Long id) {
		userRepo.deleteById(id);
		log.info("IN delete(Long id) user was deleted with id {}", id);
	}

}
