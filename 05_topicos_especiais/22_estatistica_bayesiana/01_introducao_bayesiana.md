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

# Introdução à Estatística Bayesiana

> **"Quando os fatos mudam, eu mudo minha opinião. E o senhor, o que faz?"** — John Maynard Keynes

A abordagem Bayesiana é diferente. Em vez de perguntar "o que os dados dizem assumindo que H0 é verdade" (Frequentista), nós perguntamos "qual a probabilidade da Hipótese ser verdade, dados os dados" (Bayesiana).

---

## 1. O Teorema de Bayes (A Intuição)
$$ P(Hipótese|Dados) = \frac{P(Dados|Hipótese) \times P(Hipótese)}{P(Dados)} $$

*   **Prior (P(H)):** O que eu sabia antes? (Minha crença inicial).
*   **Likelihood (P(D|H)):** O que os dados dizem?
*   **Posterior (P(H|D)):** O que sei agora? (Minha crença atualizada).

### Exemplo: Teste de Doença Rara
*   Doença afeta 0.1% da população (Prior baixo).
*   Teste positivo detecta 99% dos doentes (Likelihood alta).
*   Se você testar positivo, sua chance de ter a doença é alta? **NÃO.** Talvez seja apenas 9%.
*   Por quê? Porque a doença é tão rara que os falsos positivos superam os verdadeiros doentes. O Bayesiano "pesa" o resultado do teste pela raridade da doença.

---

## 2. Frequentista vs. Bayesiano (A/B Testing)
Imagine um teste A/B.

*   **Frequentista (P-valor):** "Se A e B fossem iguais, veríamos essa diferença apenas 3% das vezes." (P=0.03). Rejeita igualdade.
*   **Bayesiano:** "Existe 98.5% de probabilidade de B ser melhor que A."

Qual frase seu chefe entende? A segunda.

---

## 3. Prática em Python: Comparação Bayesiana

Vamos usar uma abordagem simplificada (Beta Distribution) para comparar duas taxas de conversão.

```python
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Cenário:
# Site A: 1000 visitas, 40 compras.
# Site B: 1000 visitas, 50 compras.

# 1. Priors (Ignorância total = Beta(1,1))
alpha_prior = 1
beta_prior = 1

# 2. Atualizando com os dados (Posterior)
# A Posterior de uma Binomial com Prior Beta é uma Beta(alpha+sucessos, beta+fracassos)
posterior_A = stats.beta(alpha_prior + 40, beta_prior + 960)
posterior_B = stats.beta(alpha_prior + 50, beta_prior + 950)

# 3. Visualização das Crenças
x = np.linspace(0.02, 0.08, 1000)
y_A = posterior_A.pdf(x)
y_B = posterior_B.pdf(x)

plt.figure(figsize=(10, 5))
plt.plot(x, y_A, label='Taxa do Site A', color='skyblue', fillstyle='full')
plt.fill_between(x, y_A, alpha=0.3, color='skyblue')

plt.plot(x, y_B, label='Taxa do Site B', color='salmon')
plt.fill_between(x, y_B, alpha=0.3, color='salmon')

plt.title('Posterior Distributions: Onde está a verdadeira taxa de conversão?')
plt.xlabel('Taxa de Conversão')
plt.legend()
plt.show()

# 4. A Pergunta de Milhão de Dólares
# Qual a chance de B ser melhor que A?
# Simulação Monte Carlo (Sorteamos da posterior)
amostras = 100000
sorteio_A = posterior_A.rvs(amostras)
sorteio_B = posterior_B.rvs(amostras)

prob_B_melhor = np.mean(sorteio_B > sorteio_A)
print(f"Chance de B ser melhor que A: {prob_B_melhor:.2%}")
```

### Vantagem
Você pode parar o teste a qualquer momento. No frequentista, "espiar" o p-valor infla o erro. No Bayesiano, apenas atualizamos a crença.
