package br.com.effies.laboris.backend.presentation.dto.request;

import br.com.effies.laboris.backend.domain.entity.enums.JobStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateJobRequestDto {

    @NotNull(message = "O Status não pode ser nulo.")
    private JobStatus status;

    // Futuramente, outros campos para atualização poderiam ser adicionados aqui
    // private String clientName;
    // private BigDecimal budget;
}
