package ua.boretskyi.service.impl;

import ua.boretskyi.domain.RoleEntity;
import ua.boretskyi.repository.RoleRepository;
import ua.boretskyi.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;

    @Override
    public RoleEntity findByTitle(String title) {
        return roleRepository.findByTitle(title);
    }
}
