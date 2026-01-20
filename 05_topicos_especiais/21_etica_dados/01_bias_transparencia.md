---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.11.5
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# Ética em Dados e Transparência

> **"Torture os dados e eles confessarão qualquer coisa."** — Ronald Coase

Saber rodar o código é apenas metade do trabalho. A outra metade é garantir que sua análise não causa dano e não mente.

---

## 1. O Viés Escondido

O modelo aprende o que vê nos dados. Se o mundo é preconceituoso, seu modelo será também.

### Exemplos Reais:
1.  **Amazon Recruitment AI:** O modelo penalizava currículos com a palavra "women's" (ex: "captain of women's chess club") porque foi treinado em currículos de 10 anos de uma indústria dominada por homens.
2.  **Reconhecimento Facial:** Frequentemente falha mais em peles escuras porque os datasets de treinamento são majoritariamente brancos.

**Ação:** Sempre pergunte "Quem não está representado nestes dados?". Se você analisa dados de saúde baseados em smartphones, está excluindo os idosos e os pobres.

---

## 2. Transparência e Honestidade Intelectual

Como escrever um relatório ético:

1.  **Reporte o que NÃO deu certo:** Não mostre apenas o modelo que funcionou. Isso cria uma falsa imagem de facilidade.
2.  **Liste as Limitações:** "Esta análise é válida para SP, não sabemos se aplica ao NE."
3.  **Conflito de Interesse:** Você está sendo pago para achar um resultado positivo?

### Checklist Ético do Analista:
- Meus dados contêm informações pessoais (PII)? Elas foram anonimizadas?
- O algoritmo afeta vidas humanas (crédito, emprego, saúde)? Se sim, ele é explicável?
- Se eu estivesse no lugar do sujeito dos dados, eu concordaria com esse uso?

---

## 3. O Dilema do P-Hacking
Testar 50 hipóteses e publicar apenas a que deu $p < 0.05$ é fraude. É como atirar flechas na parede e pintar o alvo onde elas caíram.

**Antídoto:** Pré-registro. Decida o que vai analisar ANTES de olhar os dados.

---

### Resumo
Seja cético com seus próprios resultados. O analista ético é aquele que tenta **refutar** a própria descoberta antes de publicá-la.
