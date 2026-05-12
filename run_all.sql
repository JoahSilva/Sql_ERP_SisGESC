-- Sistema SisGESC
CREATE DATABASE IF NOT EXISTS cloves;
USE cloves;

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

CREATE TABLE tb_alunos (
    pk_aluno_id INT PRIMARY KEY,
    p_nome VARCHAR(60) NOT NULL,
    sobrenome VARCHAR(60) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo ENUM('Masculino', 'Feminino', 'Outro', 'Prefere não informar') NOT NULL
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
    sobrenome VARCHAR(60) NOT NULL,
    sexo ENUM('Masculino', 'Feminino', 'Outro', 'Prefere não informar') NOT NULL
);

CREATE TABLE tb_professores (
    pk_professor_id INT PRIMARY KEY,
    fk_funcionario_id INT NOT NULL UNIQUE,
    FOREIGN KEY (fk_funcionario_id) REFERENCES tb_funcionarios(pk_funcionario_id)
);

-- academico

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

-- notas e faltas

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

-- financeiro

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

-- FUncionarios
CREATE TABLE tb_carga_horaria_docente (
    pk_carga_id INT PRIMARY KEY,
    fk_professor_id INT NOT NULL,
    horas INT NOT NULL,
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id)
);

CREATE TABLE tb_vinculos_professor_disciplina (
    fk_professor_id INT NOT NULL,
    fk_disciplina_id INT NOT NULL,
    PRIMARY KEY (fk_professor_id, fk_disciplina_id),
    FOREIGN KEY (fk_professor_id) REFERENCES tb_professores(pk_professor_id),
    FOREIGN KEY (fk_disciplina_id) REFERENCES tb_disciplinas(pk_disciplina_id)
);

-- View 
CREATE VIEW vw_desempenho AS
SELECT 
    a.p_nome, 
    a.sobrenome, 
    t.semestre, 
    COUNT(f.pk_falta_id) AS total_faltas
FROM tb_matriculas m
JOIN tb_alunos a ON m.fk_aluno_id = a.pk_aluno_id
JOIN tb_turmas t ON m.fk_turma_id = t.pk_turma_id
JOIN tb_faltas f ON m.fk_aluno_id = f.fk_aluno_id AND m.fk_turma_id = f.fk_turma_id
GROUP BY a.pk_aluno_id, a.p_nome, a.sobrenome, t.pk_turma_id, t.semestre;
 
 -- inserir dados 
 
INSERT IGNORE INTO tb_alunos VALUES
(1, 'Igor', 'Lacerda', '45871236900', '2006-03-12', 'Masculino'),
(2, 'Lucas', 'Melero', '85214796322', '2005-12-12', 'Masculino'),
(3, 'Joao Vitor', 'Vieira da Silva', '74125896344', '2006-06-17', 'Masculino'),
(4, 'Mariana', 'Costa', '11122233344', '2004-05-10', 'Feminino'),
(5, 'Pedro', 'Alves', '55566677788', '2005-08-22', 'Masculino'),
(6, 'Camila', 'Rocha', '99988877766', '2003-11-30', 'Feminino');

INSERT IGNORE INTO tb_contatos (fk_aluno_id, tipo, valor) VALUES 
(1, 'Email', 'igor_freefire@gmail.com'),
(2, 'Email', 'lucasmelero@email.com'),
(3, 'Email', 'jaovbuck31@email.com'),
(4, 'WhatsApp', '11999998888'),
(5, 'Email', 'pedro.alves@email.com'),
(6, 'Telefone', '1133334444');

INSERT IGNORE INTO tb_funcionarios VALUES 
(1, 'Carlos', 'Silva', 'Masculino'),
(2, 'Ana', 'Souza', 'Feminino'),
(3, 'Roberto', 'Mendes', 'Masculino');

INSERT IGNORE INTO tb_professores VALUES (1, 1), (2, 2), (3, 3);

INSERT IGNORE INTO tb_cursos VALUES 
(1, 'Gestão de TI', 2000), 
(2, 'Análise e Desenvolvimento de Sistemas', 2400),
(3, 'Ciência da Computação', 3200);

INSERT IGNORE INTO tb_disciplinas VALUES 
(1, 'Banco de Dados Relacional', 80), 
(2, 'Engenharia de Software', 80),
(3, 'Algoritmos e Estrutura de Dados', 120);

INSERT IGNORE INTO tb_vinculos_professor_disciplina VALUES 
(1, 1), 
(2, 2), 
(3, 3); 

INSERT IGNORE INTO tb_turmas VALUES 
(1, 1, '2026.1'),
(2, 2, '2026.1'), 
(3, 3, '2026.1');


INSERT IGNORE INTO tb_matriculas (fk_aluno_id, fk_turma_id) VALUES 
(1, 1),
(2, 2), 
(3, 3),
(4, 3),
(5, 2), 
(6, 1);

INSERT IGNORE INTO tb_contratos_educacionais VALUES 
(1, 1, '2026-01-01', '2026-12-31'), (2, 2, '2026-01-01', '2026-12-31'),
(3, 3, '2026-01-01', '2026-12-31'), (4, 4, '2026-01-01', '2026-12-31'),
(5, 5, '2026-01-01', '2026-12-31'), (6, 6, '2026-01-01', '2026-12-31');

INSERT IGNORE INTO tb_mensalidades VALUES 
(1, 1, 900.00, '2026-02-10'), (2, 2, 1100.00, '2026-02-10'),
(3, 3, 1500.00, '2026-02-10'), (4, 4, 1500.00, '2026-02-10'),
(5, 5, 1100.00, '2026-02-10'), (6, 6, 900.00, '2026-02-10');

INSERT IGNORE INTO tb_pagamentos VALUES 
(1, 1, 900.00, '2026-02-08', CURRENT_DATE, CURRENT_DATE),
(2, 2, 1100.00, '2026-02-09', CURRENT_DATE, CURRENT_DATE),
(3, 3, 1500.00, '2026-02-10', CURRENT_DATE, CURRENT_DATE);

INSERT INTO tb_faltas (fk_aluno_id, fk_turma_id, data_falta) VALUES 
(1, 1, '2026-05-01'), (1, 1, '2026-05-02'), 
(2, 2, '2026-05-02'), (4, 3, '2026-04-10');
-- select para checar

-- luisvaldo
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

-- Luccas
SELECT 'OLTP Total:' as Origem, SUM(valor_pago) FROM tb_pagamentos
UNION ALL
SELECT 'DW Total:' as Origem, SUM(valor_total) FROM fato_financeiro;

CREATE INDEX idx_aluno_cpf ON tb_alunos(cpf);
CREATE INDEX idx_pagto_data ON tb_pagamentos(data_pagamento);

-- joao

EXPLAIN SELECT a.p_nome, p.valor_pago FROM tb_alunos a 
JOIN tb_contratos_educacionais c ON a.pk_aluno_id = c.fk_aluno_id
JOIN tb_mensalidades m ON c.pk_contrato_id = m.fk_contrato_id
JOIN tb_pagamentos p ON m.pk_mensalidade_id = p.fk_mensalidade_id;

-- CONSULTAS DE DEMONSTRAÇÃO 

SELECT a.p_nome AS Nome, a.sobrenome AS Sobrenome, a.sexo, c.nome_curso AS Curso, cont.valor AS Contato
FROM tb_alunos a
JOIN tb_matriculas m ON a.pk_aluno_id = m.fk_aluno_id
JOIN tb_turmas t ON m.fk_turma_id = t.pk_turma_id
JOIN tb_cursos c ON t.fk_curso_id = c.pk_curso_id
LEFT JOIN tb_contatos cont ON a.pk_aluno_id = cont.fk_aluno_id
WHERE cont.tipo = 'Email' OR cont.tipo IS NULL;



SELECT f.p_nome AS Professor, f.sobrenome AS Sobrenome, d.nome_disciplina AS Disciplina, d.carga_horaria AS Horas
FROM tb_funcionarios f
JOIN tb_professores p ON f.pk_funcionario_id = p.fk_funcionario_id
JOIN tb_vinculos_professor_disciplina vpd ON p.pk_professor_id = vpd.fk_professor_id
JOIN tb_disciplinas d ON vpd.fk_disciplina_id = d.pk_disciplina_id;



SELECT a.p_nome AS Aluno, c.nome_curso AS Curso, m.valor AS Mensalidade, m.data_vencimento AS Vencimento
FROM tb_alunos a
JOIN tb_contratos_educacionais ce ON a.pk_aluno_id = ce.fk_aluno_id
JOIN tb_mensalidades m ON ce.pk_contrato_id = m.fk_contrato_id
LEFT JOIN tb_pagamentos p ON m.pk_mensalidade_id = p.fk_mensalidade_id
JOIN tb_matriculas mat ON a.pk_aluno_id = mat.fk_aluno_id
JOIN tb_turmas t ON mat.fk_turma_id = t.pk_turma_id
JOIN tb_cursos c ON t.fk_curso_id = c.pk_curso_id
WHERE p.pk_pagamento_id IS NULL; 



	SELECT p_nome AS Nome, sobrenome AS Sobrenome, semestre, total_faltas
	FROM vw_desempenho
	WHERE total_faltas >= 2 
	ORDER BY total_faltas DESC;



SELECT dt.nome_mes AS Mes, dt.ano AS Ano, SUM(ff.valor_total) AS Faturamento_Total
FROM fato_financeiro ff
JOIN dim_tempo dt ON ff.sk_tempo = dt.sk_tempo
GROUP BY dt.ano, dt.mes, dt.nome_mes 
ORDER BY dt.ano, dt.mes;
