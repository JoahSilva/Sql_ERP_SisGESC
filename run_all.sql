-- =========================================================================
-- ERP SisGESC - 
-- =========================================================================
SET FOREIGN_KEY_CHECKS = 0; -- Desativa checagem de chaves para poder dropar sem erro

DROP TABLE IF EXISTS tb_pagamentos, tb_mensalidades, tb_faltas, tb_notas, 
                     tb_matriculas, tb_turmas, tb_vinculos_professor_disciplina, 
                     tb_carga_horaria_docente, tb_inadimplencia, tb_contratos_educacionais, 
                     tb_professores, tb_disciplinas, tb_cursos, tb_funcionarios, tb_alunos,
                     fato_financeiro, dim_tempo, dim_aluno;

SET FOREIGN_KEY_CHECKS = 1; -- Reativa a checagem de chaves

-- =========================================================================
-- FASE 1: DDL (CRIAÇÃO DAS TABELAS TRANSACIONAIS - OLTP)
-- =========================================================================




-- =========================================================================
-- FASE 2: CARGA DE DADOS (DML) E IDEMPOTÊNCIA
-- =========================================================================



-- =========================================================================
-- FASE 3: OPERAÇÕES OLTP (CONSULTAS E TRANSAÇÕES)
-- =========================================================================
