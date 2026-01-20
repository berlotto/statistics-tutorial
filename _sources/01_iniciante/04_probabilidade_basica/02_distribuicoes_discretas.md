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

# Distribuições Discretas (Contagens)

> **"Deus não joga dados... mas se jogasse, usaria uma Distribuição Binomial."**
>
> Quando seus dados são contagens de eventos (número de vendas, número de curas, número de falhas), você não está lidando com a curva Normal "perfeita". Você está no reino discreto.

---

## 1. Distribuição de Bernoulli
O bloco fundamental. Um único experimento com dois resultados possíveis:
*   Sucesso ($1$, com probabilidade $p$).
*   Fracasso ($0$, com probabilidade $q = 1-p$).
*   *Exemplo:* Jogar uma moeda uma vez.

## 2. Distribuição Binomial
A soma de $n$ experimentos de Bernoulli independentes.
*   **Pergunta:** "Se eu jogar a moeda 10 vezes, qual a chance de sair Cara exatamente 6 vezes?"
*   **Parâmetros:** $n$ (tentativas) e $p$ (sucesso).
*   **Atenção:** Se $n$ for muito grande, a Binomial se aproxima da Normal (TLC).

## 3. Distribuição de Poisson
Modela a contagem de eventos raros que ocorrem em um **intervalo fixo de tempo ou espaço**.
*   **Pergunta:** "Quantos clientes chegam na loja por hora?" ou "Quantos defeitos por metro de tecido?"
*   **Parâmetro Único:** Lambda ($\lambda$), que representa a taxa média de ocorrência.
*   **Propriedade Mágica:** Na Poisson, Média = Variância ($\mu = \sigma^2$). Se sua variância for muito maior que a média, você tem *Superdispersão* (Overdispersion) e a Poisson falha (use Binomial Negativa).

---

## 4. Prática em Python: Simulando o Mundo Real

```python
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import binom, poisson

sns.set_theme(style="whitegrid")

# --- Cenário 1: Binomial ---
# Um remédio tem 60% de eficácia (p=0.6).
# Tratamos 10 pacientes (n=10). Qual a chance de curar exatamente 8?

n, p = 10, 0.6
prob_8_curas = binom.pmf(k=8, n=n, p=p)  # PMF = Probability Mass Function

print(f"Chance de curar exatamente 8 de 10 pacientes: {prob_8_curas:.2%}")

# Distribuição completa de probabilidades (0 a 10 curas)
x_binom = np.arange(0, 11)
y_binom = binom.pmf(x_binom, n, p)

# --- Cenário 2: Poisson ---
# Um call center recebe média de 4 ligações por minuto (lambda=4).
# Qual a chance de receber ZERO ligações num minuto?
# Qual a chance de receber DEZ (caos)?

lam = 4
prob_0_ligacoes = poisson.pmf(k=0, mu=lam)
prob_10_ligacoes = poisson.pmf(k=10, mu=lam)

print(f"Chance de silêncio total (0 ligações): {prob_0_ligacoes:.2%}")
print(f"Chance de caos (10 lig. espera): {prob_10_ligacoes:.2%}")

# Visualização Comparativa
fig, ax = plt.subplots(1, 2, figsize=(12, 5))

sns.barplot(x=x_binom, y=y_binom, color='skyblue', ax=ax[0])
ax[0].set_title(f'Binomial (n={n}, p={p})')
ax[0].set_ylabel('Probabilidade')
ax[0].set_xlabel('Sucessos')

# Para Poisson, vamos plotar até k=15 para ver a cauda
x_poisson = np.arange(0, 16)
y_poisson = poisson.pmf(x_poisson, mu=lam)

sns.barplot(x=x_poisson, y=y_poisson, color='salmon', ax=ax[1])
ax[1].set_title(f'Poisson ($\lambda$={lam})')
ax[1].set_xlabel('Ocorrências')
```

### Aplicação Científica
*   Se seu desfecho é **"Sim/Não"** (Curou/Não Curou), você usará Regressão Logística (baseada na Bernoulli/Binomial).
*   Se seu desfecho é **Contagem** (Nº de dias internado), você usará Regressão de Poisson.
*   Saber a distribuição guia a escolha do modelo preditivo.
