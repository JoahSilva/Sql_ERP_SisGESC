-- =========================================================================
-- ERP SisGESC
-- =========================================================================
SET FOREIGN_KEY_CHECKS = 0; -- desliga as FKs pra conseguir dropar tudo sem erro

DROP TABLE IF EXISTS tb_pagamentos, tb_mensalidades, tb_faltas, tb_notas, 
                     tb_matriculas, tb_turmas, tb_vinculos_professor_disciplina, 
                     tb_carga_horaria_docente, tb_inadimplencia, tb_contratos_educacionais, 
                     tb_professores, tb_disciplinas, tb_cursos, tb_funcionarios, tb_alunos,
                     fato_financeiro, dim_tempo, dim_aluno;

SET FOREIGN_KEY_CHECKS = 1; -- liga de volta

-- =========================================================================
-- criação das tabelas principais
-- =========================================================================

-- parte de cadastro (aluno, funcionário, professor)

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

-- parte acadêmica

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

-- notas e faltas

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

-- financeiro

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

-- tabelas de apoio

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


-- =========================================================================
-- inserindo alguns dados pra teste
-- =========================================================================

-- alunos
INSERT IGNORE INTO tb_alunos (pk_aluno_id, nome, cpf, data_nascimento, email) VALUES
(1, 'Ana Clara Silva', '11122233344', '2001-05-14', 'ana.silva@email.com'),
(2, 'Bruno Gomes', '55566677788', '1999-08-22', 'bruno.gomes@email.com'),
(3, 'Carla Mendes', '99988877766', '2002-11-30', 'carla.mendes@email.com');

-- cursos e turmas
INSERT IGNORE INTO tb_cursos (pk_curso_id, nome_curso, carga_horaria) VALUES
(1, 'Ciência da Computação', 3200),
(2, 'Administração', 2800);

INSERT IGNORE INTO tb_turmas (pk_turma_id, fk_curso_id, semestre) VALUES
(1, 1, '2026.1'),
(2, 2, '2026.1');

-- contratos e mensalidades
INSERT IGNORE INTO tb_contratos_educacionais (pk_contrato_id, fk_aluno_id, data_inicio, data_fim) VALUES
(1, 1, '2026-01-01', '2026-12-31'),
(2, 2, '2026-01-01', '2026-12-31');

INSERT IGNORE INTO tb_mensalidades (pk_mensalidade_id, fk_contrato_id, valor, data_vencimento) VALUES
(1, 1, 1500.00, '2026-02-10'),
(2, 1, 1500.00, '2026-03-10'),
(3, 2, 1200.00, '2026-02-10');

-- pagamento inicial
INSERT IGNORE INTO tb_pagamentos (pk_pagamento_id, fk_mensalidade_id, valor_pago, data_pagamento, data_criacao, ultima_atualizacao) VALUES
(1, 1, 1500.00, '2026-02-08', CURRENT_DATE, CURRENT_DATE);

-- só pra conferir se inseriu tudo
SELECT 'Contagem de Alunos após carga:' AS Validacao, COUNT(*) FROM tb_alunos;


-- =========================================================================
-- algumas consultas e testes
-- =========================================================================

-- listando alunos
SELECT nome, email FROM tb_alunos ORDER BY nome;

-- alunos que já pagaram mais de 1000 no total
SELECT nome 
FROM tb_alunos 
WHERE pk_aluno_id IN (
    SELECT c.fk_aluno_id 
    FROM tb_contratos_educacionais c
    JOIN tb_mensalidades m ON c.pk_contrato_id = m.fk_contrato_id
    JOIN tb_pagamentos p ON m.pk_mensalidade_id = p.fk_mensalidade_id
    GROUP BY c.fk_aluno_id
    HAVING SUM(p.valor_pago) > 1000
);

-- testando rollback (simula erro)
START TRANSACTION;
    INSERT INTO tb_pagamentos (pk_pagamento_id, fk_mensalidade_id, valor_pago, data_pagamento, data_criacao, ultima_atualizacao) 
    VALUES (999, 2, 1500.00, '2026-03-09', CURRENT_DATE, CURRENT_DATE);
ROLLBACK;

-- aqui não pode ter inserido
SELECT 'Validacao Rollback (deve ser 0):' AS Teste, COUNT(*) FROM tb_pagamentos WHERE pk_pagamento_id = 999;


-- agora testando commit
START TRANSACTION;
    INSERT INTO tb_pagamentos (pk_pagamento_id, fk_mensalidade_id, valor_pago, data_pagamento, data_criacao, ultima_atualizacao) 
    VALUES (2, 3, 1200.00, '2026-02-09', CURRENT_DATE, CURRENT_DATE);
COMMIT;

-- aqui tem que existir
SELECT 'Validacao Commit (deve ser 1):' AS Teste, COUNT(*) FROM tb_pagamentos WHERE pk_pagamento_id = 2;
