/*
  Script  - Banco de Dados
  Objetivo: Criação das tabelas base para os módulos Acadêmico, Financeiro e RH.
*/

-- ==========================================
-- MÓDULO: CADASTROS GERAIS E RH
-- ==========================================

CREATE TABLE IF NOT EXISTS tb_alunos (
    pk_aluno_id INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(150) NOT NULL,
    
    CONSTRAINT uk_aluno_cpf UNIQUE (cpf),
    CONSTRAINT uk_aluno_email UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS tb_funcionarios (
    pk_funcionario_id INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_professores (
    pk_professor_id INT PRIMARY KEY,
    fk_funcionario_id INT NOT NULL,
    
    CONSTRAINT uk_prof_func UNIQUE (fk_funcionario_id),
    CONSTRAINT fk_prof_func FOREIGN KEY (fk_funcionario_id) REFERENCES tb_funcionarios(pk_funcionario_id)
);

-- ==========================================
-- MÓDULO: ACADÊMICO
-- ==========================================

CREATE TABLE IF NOT EXISTS tb_cursos (
    pk_curso_id INT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_disciplinas (
    pk_disciplina_id INT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_turmas (
    pk_turma_id INT PRIMARY KEY,
    fk_curso_id INT,
    semestre VARCHAR(10) NOT NULL,
    
    CONSTRAINT fk_turma_curso FOREIGN KEY (fk_curso_id) REFERENCES tb_cursos(pk_curso_id)
);

CREATE TABLE IF NOT EXISTS tb_matriculas (
    pk_matricula_id INT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    fk_turma_id INT NOT NULL,
    data_matricula DATE DEFAULT CURRENT_DATE,
    
    CONSTRAINT fk_mat_aluno FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id),
    CONSTRAINT fk_mat_turma FOREIGN KEY (fk_turma_id) REFERENCES tb_turmas(pk_turma_id)
);

-- Histórico e Avaliações
CREATE TABLE IF NOT EXISTS tb_notas (
    pk_nota_id INT PRIMARY KEY,
    fk_matricula_id INT NOT NULL,
    nota DECIMAL(4,2),
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    
    CONSTRAINT chk_nota_valida CHECK (nota >= 0 AND nota <= 10),
    CONSTRAINT fk_nota_mat FOREIGN KEY (fk_matricula_id) REFERENCES tb_matriculas(pk_matricula_id)
);

CREATE TABLE IF NOT EXISTS tb_faltas (
    pk_falta_id INT PRIMARY KEY,
    fk_matricula_id INT NOT NULL,
    quantidade_faltas INT NOT NULL DEFAULT 0,
    
    CONSTRAINT fk_falta_mat FOREIGN KEY (fk_matricula_id) REFERENCES tb_matriculas(pk_matricula_id)
);

-- ==========================================
-- MÓDULO: FINANCEIRO
-- ==========================================

CREATE TABLE IF NOT EXISTS tb_contratos_educacionais (
    pk_contrato_id INT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    
    CONSTRAINT fk_contrato_aluno FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

CREATE TABLE IF NOT EXISTS tb_mensalidades (
    pk_mensalidade_id INT PRIMARY KEY,
    fk_contrato_id INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    
    CONSTRAINT fk_mensalidade_contrato FOREIGN KEY (fk_contrato_id) REFERENCES tb_contratos_educacionais(pk_contrato_id)
);

CREATE TABLE IF NOT EXISTS tb_pagamentos (
    pk_pagamento_id INT PRIMARY KEY,
    fk_mensalidade_id INT NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATE NOT NULL,
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    
    CONSTRAINT fk_pag_mensalidade FOREIGN KEY (fk_mensalidade_id) REFERENCES tb_mensalidades(pk_mensalidade_id)
);

CREATE TABLE IF NOT EXISTS tb_inadimplencia (
    pk_inadimplencia_id INT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    dias_atraso INT NOT NULL DEFAULT 0,
    
    CONSTRAINT fk_inad_aluno FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

-- ==========================================
-- TABELAS ASSOCIATIVAS (Integrações)
-- ==========================================

CREATE TABLE IF NOT EXISTS tb_carga_horaria_docente (
    pk_carga_id INT PRIMARY KEY,
    fk_professor_id INT NOT NULL,
    horas INT NOT NULL,
    
    CONSTRAINT fk_carga_prof FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id)
);

CREATE TABLE IF NOT EXISTS tb_vinculos_professor_disciplina (
    pk_vinculo_id INT PRIMARY KEY,
    fk_professor_id INT NOT NULL,
    fk_disciplina_id INT NOT NULL,
    
    CONSTRAINT fk_vinc_prof FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id),
    CONSTRAINT fk_vinc_disc FOREIGN KEY (fk_disciplina_id) REFERENCES tb_disciplinas(pk_disciplina_id)
);
