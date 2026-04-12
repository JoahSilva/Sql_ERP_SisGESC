# 🎓 SisGESC - Sistema de Gestão Escolar (ERP)

> **"Construindo Arranha-Céus de Dados na Educação."**

[cite_start]O **SisGESC** é um ERP (Enterprise Resource Planning) projetado para centralizar e otimizar a gestão de uma universidade privada de médio porte[cite: 344]. [cite_start]Este projeto atua como o "cérebro digital" da instituição, integrando as operações acadêmicas, financeiras e de recursos humanos para mitigar a evasão escolar, controlar a inadimplência e melhorar a alocação do corpo docente[cite: 344, 398, 400].

---

## 🎯 O Problema
[cite_start]Historicamente, a falta de integração entre os sistemas educacionais cria "ilhas de informação"[cite: 344, 400]. Quando o módulo de faltas não conversa com o financeiro, a instituição perde a capacidade de identificar precocemente alunos em risco de evasão.

## 💡 A Solução (Modelagem em 3FN)
[cite_start]A fundação do SisGESC é um banco de dados transacional (OLTP) rigorosamente modelado na **3ª Forma Normal (3FN)**[cite: 345, 401]. [cite_start]Isso garante a integridade referencial dos dados, elimina redundâncias e cria uma base sólida que permitirá, no futuro, a implementação de camadas de Inteligência Artificial (IA) e Business Intelligence (BI)[cite: 345, 401].

---

## 🏗️ Estrutura e Integração dos Módulos

O ecossistema de dados do SisGESC foi construído em torno de três pilares fundamentais:

* [cite_start]**Módulo Acadêmico (Núcleo):** Gerencia o ciclo de vida do aluno, desde a matrícula em turmas e disciplinas até o controle rigoroso de notas e faltas[cite: 355, 357, 359, 361, 363, 410, 412, 414, 416, 418].
* [cite_start]**Módulo Financeiro Educacional:** Controla a vigência de contratos, gera as mensalidades correspondentes, gerencia pagamentos e monitora ativamente a inadimplência[cite: 365, 367, 369, 371, 420, 422, 424, 426].
* [cite_start]**Módulo de Recursos Humanos:** Administra o quadro de funcionários, o vínculo de professores às disciplinas e garante o respeito à carga horária docente máxima estabelecida[cite: 377, 379, 381, 383, 428, 430, 432, 434].

---

## 🔒 Regras de Negócio e Restrições Sistêmicas

[cite_start]A integridade do ERP é mantida por regras de negócio implementadas diretamente na camada de banco de dados[cite: 384, 435, 436]:

1.  [cite_start]**(Financeiro)** Toda mensalidade gerada deve derivar de um Contrato Educacional ativo[cite: 385, 440].
2.  [cite_start]**(Integração Acadêmico/Financeiro)** O sistema bloqueia automaticamente novas matrículas caso o aluno possua inadimplência superior a 60 dias[cite: 385, 445].
3.  [cite_start]**(Integração RH/Acadêmico)** O vínculo de um professor a uma disciplina é restrito ao limite máximo de sua carga horária contratual[cite: 386, 446].

---

## 🔮 Visão Estratégica: Preparação para BI e IA

[cite_start]O banco de dados foi projetado para alimentar algoritmos futuros, mapeando variáveis transacionais críticas para uso analítico e preditivo[cite: 387, 448, 449, 451]:

* [cite_start]**`quantidade_faltas` (`tb_faltas`):** Variável principal para modelos preditivos de Evasão Escolar (Churn)[cite: 388, 452].
* [cite_start]**`dias_atraso` (`tb_inadimplencia`):** Gatilho para segmentação de devedores e previsão de inadimplência[cite: 388, 452, 453].
* [cite_start]**`horas` (`tb_carga_horaria_docente`):** Atributo base para otimização de custos de folha de pagamento no RH[cite: 388, 453].

---

## 📁 Entregas (Fase 1)

* `derRealizado.drawio.jpg`: Diagrama Entidade-Relacionamento integrado.
* `Clovis_trabalho_pronto.pdf`: Documento de Requisitos, DER e Dicionário de Dados.
* `script_inicial.sql`: Script DDL com a criação das tabelas e restrições.

---
*Projeto desenvolvido para a disciplina de Projeto de Banco de Dados - Ciência da Computação (UNICID, 2026).* [cite: 389, 390, 393]
