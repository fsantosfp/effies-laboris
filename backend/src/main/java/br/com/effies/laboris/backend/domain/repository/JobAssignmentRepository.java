package br.com.effies.laboris.backend.domain.repository;

import br.com.effies.laboris.backend.domain.entity.JobAssignment;
import br.com.effies.laboris.backend.domain.entity.JobAssignmentId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface JobAssignmentRepository extends JpaRepository<JobAssignment, JobAssignmentId> {

    @Query("SELECT ja FROM JobAssignment ja WHERE ja.id.jobId = :jobId")
    List<JobAssignment> findAllByJob(UUID jobId);
}
