package ua.boretskyi.controller;

import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "health")
@SecurityRequirements(value = {})
public class AppHealthController {

    @GetMapping
    public ResponseEntity getAppStatus() {
        return new ResponseEntity(HttpStatus.OK);
    }
}
