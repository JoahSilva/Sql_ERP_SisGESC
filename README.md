# 🎓 SisGESC - Sistema de Gestão Escolar (ERP)

> **"Construindo Arranha-Céus de Dados na Educação."**

O **SisGESC** é um ERP (Enterprise Resource Planning) projetado para centralizar e otimizar a gestão de uma universidade privada de médio porte. Este projeto atua como o "cérebro digital" da instituição, integrando as operações acadêmicas, financeiras e de recursos humanos para mitigar a evasão escolar, controlar a inadimplência e melhorar a alocação do corpo docente.

---

## 🎯 O Problema
Historicamente, a falta de integração entre os sistemas educacionais cria "ilhas de informação". Quando o módulo de faltas não conversa com o financeiro, a instituição perde a capacidade de identificar precocemente alunos em risco de evasão.

## 💡 A Solução (Modelagem em 3FN)
A fundação do SisGESC é um banco de dados transacional (OLTP) rigorosamente modelado na **3ª Forma Normal (3FN)**. Isso garante a integridade referencial dos dados, elimina redundâncias e cria uma base sólida que permitirá, no futuro, a implementação de camadas de Inteligência Artificial (IA) e Business Intelligence (BI).

---

## 🏗️ Estrutura e Integração dos Módulos

O ecossistema de dados do SisGESC foi construído em torno de três pilares fundamentais:

* **Módulo Acadêmico (Núcleo):** Gerencia o ciclo de vida do aluno, desde a matrícula em turmas e disciplinas até o controle rigoroso de notas e faltas.
* **Módulo Financeiro Educacional:** Controla a vigência de contratos, gera as mensalidades correspondentes, gerencia pagamentos e monitora ativamente a inadimplência.
* **Módulo de Recursos Humanos:** Administra o quadro de funcionários, o vínculo de professores às disciplinas e garante o respeito à carga horária docente máxima estabelecida.

---

## 🔒 Regras de Negócio e Restrições Sistêmicas

A integridade do ERP é mantida por regras de negócio implementadas diretamente na camada de banco de dados:

1.  **(Financeiro)** Toda mensalidade gerada deve derivar de um Contrato Educacional ativo.
2.  **(Integração Acadêmico/Financeiro)** O sistema bloqueia automaticamente novas matrículas caso o aluno possua inadimplência superior a 60 dias.
3.  **(Integração RH/Acadêmico)** O vínculo de um professor a uma disciplina é restrito ao limite máximo de sua carga horária contratual.

---

## 🔮 Visão Estratégica: Preparação para BI e IA

O banco de dados foi projetado para alimentar algoritmos futuros, mapeando variáveis transacionais críticas para uso analítico e preditivo:

* **`quantidade_faltas` (`tb_faltas`):** Variável principal para modelos preditivos de Evasão Escolar (Churn).
* **`dias_atraso` (`tb_inadimplencia`):** Gatilho para segmentação de devedores e previsão de inadimplência.
* **`horas` (`tb_carga_horaria_docente`):** Atributo base para otimização de custos de folha de pagamento no RH.

---
*Projeto desenvolvido para a disciplina de Projeto de Banco de Dados - Ciência da Computação (UNICID, 2026).*
