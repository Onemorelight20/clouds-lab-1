package ua.boretskyi.service;

import ua.boretskyi.domain.RoleEntity;


public interface RoleService {

	RoleEntity findByTitle(String title);
}
