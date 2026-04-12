-- =========================================================================
-- ERP - SisGESC: Script DDL Inicial (Fase 1)
-- Banco de Dados Transacional (OLTP)
-- =========================================================================

-- 1. TABELAS INDEPENDENTES

CREATE TABLE tb_alunos (
    pk_aluno_id INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE tb_cursos (
    pk_curso_id INT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL
);

CREATE TABLE tb_disciplinas (
    pk_disciplina_id INT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL
);

CREATE TABLE tb_funcionarios (
    pk_funcionario_id INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL
);

-- =========================================================================
-- 2. TABELAS DEPENDENTES - NÍVEL 1

CREATE TABLE tb_turmas (
    pk_turma_id INT PRIMARY KEY,
    fk_curso_id INT,
    semestre VARCHAR(10) NOT NULL,
    FOREIGN KEY (fk_curso_id) REFERENCES tb_cursos(pk_curso_id)
);

CREATE TABLE tb_contratos_educacionais (
    pk_contrato_id INT PRIMARY KEY,
    fk_aluno_id INT,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

CREATE TABLE tb_inadimplencia (
    pk_inadimplencia_id INT PRIMARY KEY,
    fk_aluno_id INT,
    dias_atraso INT NOT NULL,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

CREATE TABLE tb_professores (
    pk_professor_id INT PRIMARY KEY,
    fk_funcionario_id INT UNIQUE,
    FOREIGN KEY (fk_funcionario_id) REFERENCES tb_funcionarios(pk_funcionario_id)
);

-- =========================================================================
-- 3. TABELAS DEPENDENTES - NÍVEL 2

CREATE TABLE tb_matriculas (
    pk_matricula_id INT PRIMARY KEY,
    fk_aluno_id INT,
    fk_turma_id INT,
    data_matricula DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id),
    FOREIGN KEY (fk_turma_id) REFERENCES tb_turmas(pk_turma_id)
);

CREATE TABLE tb_mensalidades (
    pk_mensalidade_id INT PRIMARY KEY,
    fk_contrato_id INT,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    FOREIGN KEY (fk_contrato_id) REFERENCES tb_contratos_educacionais(pk_contrato_id)
);

CREATE TABLE tb_carga_horaria_docente (
    pk_carga_id INT PRIMARY KEY,
    fk_professor_id INT,
    horas INT NOT NULL,
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id)
);

CREATE TABLE tb_vinculos_professor_disciplina (
    pk_vinculo_id INT PRIMARY KEY,
    fk_professor_id INT,
    fk_disciplina_id INT,
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id),
    FOREIGN KEY (fk_disciplina_id) REFERENCES tb_disciplinas(pk_disciplina_id)
);

-- =========================================================================
-- 4. TABELAS DEPENDENTES - NÍVEL 3

CREATE TABLE tb_notas (
    pk_nota_id INT PRIMARY KEY,
    fk_matricula_id INT,
    nota DECIMAL(4,2) CHECK (nota >= 0 AND nota <= 10),
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    FOREIGN KEY (fk_matricula_id) REFERENCES tb_matriculas(pk_matricula_id)
);

CREATE TABLE tb_faltas (
    pk_falta_id INT PRIMARY KEY,
    fk_matricula_id INT,
    quantidade_faltas INT NOT NULL,
    FOREIGN KEY (fk_matricula_id) REFERENCES tb_matriculas(pk_matricula_id)
);

CREATE TABLE tb_pagamentos (
    pk_pagamento_id INT PRIMARY KEY,
    fk_mensalidade_id INT,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATE NOT NULL,
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    FOREIGN KEY (fk_mensalidade_id) REFERENCES tb_mensalidades(pk_mensalidade_id)
);
