-- Sistema SisGESC

CREATE DATABASE IF NOT EXISTS sisgesc;
USE sisgesc;

-- apagar pra rodar do zero
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tb_pagamentos, tb_mensalidades, tb_faltas, tb_notas, 
                     tb_matriculas, tb_turmas, tb_vinculos_professor_disciplina, 
                     tb_carga_horaria_docente, tb_inadimplencia, tb_contratos_educacionais, 
                     tb_professores, tb_disciplinas, tb_cursos, tb_funcionarios, tb_alunos,
                     tb_contatos, fato_financeiro, dim_tempo, dim_aluno;
DROP VIEW IF EXISTS vw_desempenho;
SET FOREIGN_KEY_CHECKS = 1;

-- tabelas principais

-- cadastros base
CREATE TABLE tb_alunos (
    pk_aluno_id INT PRIMARY KEY,
    p_nome VARCHAR(60) NOT NULL,    
    sobrenome VARCHAR(60) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL
);


CREATE TABLE tb_contatos (
    pk_contato_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    tipo ENUM('Email', 'Telefone', 'WhatsApp') NOT NULL,
    valor VARCHAR(150) NOT NULL,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

CREATE TABLE tb_funcionarios (
    pk_funcionario_id INT PRIMARY KEY,
    p_nome VARCHAR(60) NOT NULL,
    sobrenome VARCHAR(60) NOT NULL
);

CREATE TABLE tb_professores (
    pk_professor_id INT PRIMARY KEY,
    fk_funcionario_id INT NOT NULL UNIQUE,
    FOREIGN KEY (fk_funcionario_id) REFERENCES tb_funcionarios(pk_funcionario_id)
);

-- modulo academico

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

CREATE TABLE tb_turmas (
    pk_turma_id INT PRIMARY KEY,
    fk_curso_id INT,
    semestre VARCHAR(10) NOT NULL,
    FOREIGN KEY (fk_curso_id) REFERENCES tb_cursos(pk_curso_id)
);

CREATE TABLE tb_matriculas (
    fk_aluno_id INT NOT NULL,
    fk_turma_id INT NOT NULL,
    data_matricula DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (fk_aluno_id, fk_turma_id), 
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id),
    FOREIGN KEY (fk_turma_id) REFERENCES tb_turmas(pk_turma_id)
);

-- notas e controle de faltas

CREATE TABLE tb_notas (
    pk_nota_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    fk_turma_id INT NOT NULL,
    nota DECIMAL(4,2) CHECK (nota >= 0 AND nota <= 10),
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    FOREIGN KEY (fk_aluno_id, fk_turma_id) REFERENCES tb_matriculas(fk_aluno_id, fk_turma_id)
);

CREATE TABLE tb_faltas (
    pk_falta_id INT AUTO_INCREMENT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    fk_turma_id INT NOT NULL,
    data_falta DATE NOT NULL, 
    FOREIGN KEY (fk_aluno_id, fk_turma_id) REFERENCES tb_matriculas(fk_aluno_id, fk_turma_id)
);

-- modulo financeiro
CREATE TABLE tb_contratos_educacionais (
    pk_contrato_id INT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

CREATE TABLE tb_mensalidades (
    pk_mensalidade_id INT PRIMARY KEY,
    fk_contrato_id INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    FOREIGN KEY (fk_contrato_id) REFERENCES tb_contratos_educacionais(pk_contrato_id)
);

CREATE TABLE tb_pagamentos (
    pk_pagamento_id INT PRIMARY KEY,
    fk_mensalidade_id INT NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATE NOT NULL,
    data_criacao DATE NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    FOREIGN KEY (fk_mensalidade_id) REFERENCES tb_mensalidades(pk_mensalidade_id)
);

CREATE TABLE tb_inadimplencia (
    pk_inadimplencia_id INT PRIMARY KEY,
    fk_aluno_id INT NOT NULL,
    dias_atraso INT NOT NULL DEFAULT 0,
    FOREIGN KEY (fk_aluno_id) REFERENCES tb_alunos(pk_aluno_id)
);

-- tabelas de RH
CREATE TABLE tb_carga_horaria_docente (
    pk_carga_id INT PRIMARY KEY,
    fk_professor_id INT NOT NULL,
    horas INT NOT NULL,
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id)
);

CREATE TABLE tb_vinculos_professor_disciplina (
    fk_professor_id INT NOT NULL,
    fk_disciplina_id INT NOT NULL,
    PRIMARY KEY (fk_professor_id, fk_disciplina_id), -- Ajuste: CHAVE COMPOSTA
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id),
    FOREIGN KEY (fk_disciplina_id) REFERENCES tb_disciplinas(pk_disciplina_id)
);

-- View 
CREATE VIEW vw_desempenho AS
SELECT fk_aluno_id, fk_turma_id, COUNT(*) as total_faltas
FROM tb_faltas GROUP BY fk_aluno_id, fk_turma_id;
 

INSERT IGNORE INTO tb_alunos VALUES
(1, 'Igor', 'Lacerda', '45871236900', '2006-03-12'),
(2, 'lucas', 'Melero', '85214796322', '2005-12-12'),
(3, 'Joao Vitor', 'Vieira da Silva', '74125896344', '2006-06-17');

INSERT IGNORE INTO tb_contatos (fk_aluno_id, tipo, valor) VALUES 
(1, 'Email', 'igor_freefire@gmail.com'),
(2, 'Email', 'lucasmelero@email.com'),
(3, 'Email', 'jaovbuck31@email.com');

INSERT IGNORE INTO tb_cursos VALUES (1, 'Analise de Sistemas', 2800), (2, 'Direito', 3600);
INSERT IGNORE INTO tb_turmas VALUES (1, 1, '2026.1'), (2, 2, '2026.1');

INSERT IGNORE INTO tb_matriculas (fk_aluno_id, fk_turma_id) VALUES (1, 1), (2, 2);

INSERT IGNORE INTO tb_contratos_educacionais VALUES (1, 1, '2026-01-01', '2026-12-31'), (2, 2, '2026-01-01', '2026-12-31');

-- mensalidades 
INSERT IGNORE INTO tb_mensalidades VALUES (1, 1, 1100.00, '2026-02-10'), (2, 1, 1100.00, '2026-03-10');
INSERT IGNORE INTO tb_pagamentos VALUES (1, 1, 1100.00, '2026-02-08', CURRENT_DATE, CURRENT_DATE);

-- insert de faltas

INSERT INTO tb_faltas (fk_aluno_id, fk_turma_id, data_falta) VALUES 
(1, 1, '2026-05-01'), -- Falta do Igor
(1, 1, '2026-05-02'), -- Outra falta do Igor
(2, 2, '2026-05-02'); -- Falta do Lucas

-- select para checar
SELECT 'Total Alunos:' as Info, COUNT(*) FROM tb_alunos;


CREATE TABLE dim_aluno (
    sk_aluno INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno_oltp INT,
    nome_aluno VARCHAR(150)
);

CREATE TABLE dim_tempo (
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data_completa DATE,
    ano INT,
    mes INT,
    nome_mes VARCHAR(20)
);

CREATE TABLE fato_financeiro (
    sk_aluno INT,
    sk_tempo INT,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (sk_aluno) REFERENCES dim_aluno(sk_aluno),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

-- padronização 

INSERT INTO dim_aluno (id_aluno_oltp, nome_aluno) 
SELECT pk_aluno_id, CONCAT(p_nome, ' ', sobrenome) FROM tb_alunos;

INSERT INTO dim_tempo (data_completa, ano, mes, nome_mes)
SELECT DISTINCT data_pagamento, YEAR(data_pagamento), MONTH(data_pagamento), MONTHNAME(data_pagamento) FROM tb_pagamentos;

INSERT INTO fato_financeiro (sk_aluno, sk_tempo, valor_total)
SELECT a.sk_aluno, t.sk_tempo, SUM(p.valor_pago)
FROM tb_pagamentos p
JOIN tb_mensalidades m ON p.fk_mensalidade_id = m.pk_mensalidade_id
JOIN tb_contratos_educacionais c ON m.fk_contrato_id = c.pk_contrato_id
JOIN dim_aluno a ON c.fk_aluno_id = a.id_aluno_oltp
JOIN dim_tempo t ON p.data_pagamento = t.data_completa
GROUP BY a.sk_aluno, t.sk_tempo;

-- select para validar o oltp e dw
SELECT 'OLTP Total:' as Origem, SUM(valor_pago) FROM tb_pagamentos
UNION ALL
SELECT 'DW Total:' as Origem, SUM(valor_total) FROM fato_financeiro;


CREATE INDEX idx_aluno_cpf ON tb_alunos(cpf);
CREATE INDEX idx_pagto_data ON tb_pagamentos(data_pagamento);

EXPLAIN SELECT a.p_nome, p.valor_pago FROM tb_alunos a 
JOIN tb_contratos_educacionais c ON a.pk_aluno_id = c.fk_aluno_id
JOIN tb_mensalidades m ON c.pk_contrato_id = m.fk_contrato_id
JOIN tb_pagamentos p ON m.pk_mensalidade_id = p.fk_mensalidade_id;
