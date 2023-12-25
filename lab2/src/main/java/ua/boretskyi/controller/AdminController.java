package ua.boretskyi.controller;

import ua.boretskyi.dto.AdminUserDto;
import ua.boretskyi.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

	private final UserService userService;
		
	@GetMapping("/users")
	public Iterable<AdminUserDto> getAllUsers() {
		return userService.getAll().stream().map(AdminUserDto::fromUser).collect(Collectors.toList());
	}
	
	@GetMapping("/users/{id}")
	public ResponseEntity<AdminUserDto> getUserById(@PathVariable long id) {
		return userService.findById(id)
				.map(user -> ResponseEntity.ok(AdminUserDto.fromUser(user)))
				.orElse(ResponseEntity.noContent().build());
	}

}
