package ua.boretskyi.repository;

import ua.boretskyi.domain.RoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<RoleEntity, Long>{

	RoleEntity findByTitle(String title);
}
