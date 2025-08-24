-- Usamos ENUM para garantir a integridade dos dados em campos com valores fixos
CREATE TYPE user_role AS ENUM ('SAAS_OWNER', 'MANAGER', 'EMPLOYEE');
CREATE TYPE job_status AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED');
CREATE TYPE time_entry_type AS ENUM ('CLOCK_IN', 'START_BREAK', 'END_BREAK', 'CLOCK_OUT');

-- Tabela para os clientes do SaaS
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Active', -- Ativo/Inativo
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabela de usuários do sistema (Dono, Gestores, Funcionários)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id), -- NULL para o Dono do SaaS
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role user_role NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabela para o histórico de salários, permitindo aumentos com data de vigência
CREATE TABLE salary_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    hourly_rate NUMERIC(10, 2) NOT NULL,
    effective_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Criando um índice para otimizar a busca por salário em uma data específica
CREATE INDEX idx_salary_history_user_date ON salary_history (user_id, effective_date DESC);

-- Tabela para os trabalhos/projetos dos clientes
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    client_name VARCHAR(255), -- Nome do contratante do serviço
    budget NUMERIC(10, 2),
    billing_rate NUMERIC(10, 2) NOT NULL, -- Valor/hora de venda
    status job_status NOT NULL DEFAULT 'PENDING',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabela de ligação (muitos-para-muitos) entre funcionários e trabalhos
CREATE TABLE job_assignments (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, job_id) -- Garante que um usuário só pode ser designado uma vez para o mesmo trabalho
);

-- Tabela para armazenar todas as batidas de ponto
CREATE TABLE time_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    entry_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    entry_type time_entry_type NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    is_manual BOOLEAN NOT NULL DEFAULT FALSE,
    justification TEXT -- Justificativa para entradas manuais
);