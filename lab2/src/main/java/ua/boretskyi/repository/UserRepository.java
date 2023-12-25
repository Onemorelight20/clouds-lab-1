package ua.boretskyi.repository;

import ua.boretskyi.domain.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity, Long>{

	UserEntity findByEmail(String email);
}
