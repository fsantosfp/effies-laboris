package br.com.effies.laboris.backend.domain.service;


import br.com.effies.laboris.backend.domain.entity.User;
import br.com.effies.laboris.backend.presentation.dto.request.LoginRequestDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private TokenService tokenService;

    public String login(LoginRequestDto loginRequest){
        var usernamePassword = new UsernamePasswordAuthenticationToken(
            loginRequest.getEmail(),
            loginRequest.getPassword());

        var auth = this.authenticationManager.authenticate(usernamePassword);

        User authenticatedUser = (User) auth.getPrincipal();

        return tokenService.generateToken(authenticatedUser);
    }
}
