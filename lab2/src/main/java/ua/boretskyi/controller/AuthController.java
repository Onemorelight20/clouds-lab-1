 package ua.boretskyi.controller;

 import io.swagger.v3.oas.annotations.security.SecurityRequirements;
 import ua.boretskyi.dto.AuthenticationRequestDto;
 import ua.boretskyi.dto.AuthenticationResponseDto;
 import ua.boretskyi.dto.RegistrationRequestDto;
 import ua.boretskyi.domain.UserEntity;
 import ua.boretskyi.security.jwt.JwtTokenProvider;
 import ua.boretskyi.service.UserService;
 import lombok.RequiredArgsConstructor;
 import org.springframework.http.ResponseEntity;
 import org.springframework.security.authentication.AuthenticationManager;
 import org.springframework.security.authentication.BadCredentialsException;
 import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
 import org.springframework.security.core.AuthenticationException;
 import org.springframework.security.core.userdetails.UsernameNotFoundException;
 import org.springframework.web.bind.annotation.PostMapping;
 import org.springframework.web.bind.annotation.RequestBody;
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RestController;

 @RestController
 @RequestMapping("/auth")
 @RequiredArgsConstructor
 @SecurityRequirements(value = {})
 public class AuthController {

     private final UserService userService;
     private final AuthenticationManager authenticationManager;
     private final JwtTokenProvider jwtTokenProvider;


     @PostMapping("/login")
     public ResponseEntity login(@RequestBody AuthenticationRequestDto requestDto) {

         try {
             String email = requestDto.getEmail();
             authenticationManager
                     .authenticate(new UsernamePasswordAuthenticationToken(email, requestDto.getPassword()));
             UserEntity user = userService.findByEmail(email);

             if (user == null) {
                 throw new UsernameNotFoundException("User with email " + email + " was not found");
             }

             String token = jwtTokenProvider.createToken(email, user.getRoles());

             return ResponseEntity.ok(new AuthenticationResponseDto(email, token));
         } catch (AuthenticationException e) {
             throw new BadCredentialsException("Invalid username or password.");
         }

     }

     @PostMapping("/register")
     public ResponseEntity registration(@RequestBody RegistrationRequestDto dto) {
         try {
             if (dto.getEmail() == null || dto.getUsername() == null || dto.getPassword() == null)
                 throw new Exception();

             userService.register(dto.toUser());
             return ResponseEntity.ok("User was successfully saved");
         } catch (Exception e) {
             e.printStackTrace();
             return ResponseEntity.badRequest().body("Exception occurred");
         }
     }

     @PostMapping("/logout")
     public ResponseEntity logout() {
         return ResponseEntity.noContent().build();
     }
 }
