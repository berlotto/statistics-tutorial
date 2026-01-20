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

# GLM: Poisson e Binomial Negativa (Dados de Contagem)

> **"Quando o resultado não é nem Normal (dinheiro) nem Binário (sim/não), ele é Contagem."**
>
> Quantas internações hoje? Quantos bugs no código? Quantas vendas por hora?
> Usar Regressão Linear aqui é um erro grosseiro (ela prevê números negativos e assume variância constante). Usamos GLMs.

---

## 1. Regressão de Poisson
A base para contagens.
*   **Função de Ligação (Link Function):** Logarítmica ($\ln(y) = X\beta$).
*   **Premissa Chave:** Média = Variância ($\mu = \sigma^2$).
*   **Interpretação:** $\beta$ vira **IRR (Incidence Rate Ratio)**.
    *   IRR = 1.20 significa "Aumento de 20% na taxa de ocorrência".

## 2. O Problema da Superdispersão (Overdispersion)
Na vida real, a variância quase sempre é maior que a média (contágio, modas, surtos).
*   Se Variância > Média, o Poisson subestima o erro padrão e dá p-valores falsamente baixos (falso positivo).
*   **Solução:** Regressão Binomial Negativa.

---

## 3. Prática em Python: Prevendo Consultas Médicas

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Nº de Consultas Médicas (Y)
n = 500
idade = np.random.randint(20, 90, n)
doenca_cronica = np.random.binomial(1, 0.3, n) # 30% tem doença crônica

# Taxa base (lambda) depende dos fatores
log_lambda = -2 + (0.02 * idade) + (1.5 * doenca_cronica)
lambdas = np.exp(log_lambda)

# Gerando Y com Poisson
consultas = np.random.poisson(lambdas)

df = pd.DataFrame({'consultas': consultas, 'idade': idade, 'cronico': doenca_cronica})

print(f"Média: {df['consultas'].mean():.2f}")
print(f"Variância: {df['consultas'].var():.2f}")
# Se Média ~ Variância, Poisson serve. Se Var >> Média, Overdispersion.

# 1. Regressão de Poisson
modelo_poi = smf.poisson("consultas ~ idade + cronico", data=df).fit()
print(modelo_poi.summary())

# 2. Interpretando (IRR - Incidence Rate Ratio)
params = modelo_poi.params
conf = modelo_poi.conf_int()
conf['IRR'] = params
conf.columns = ['Lower CI', 'Upper CI', 'IRR']
odds = np.exp(conf)

print("\n--- Incidence Rate Ratios (IRR) ---")
print(odds)

# Exemplo de Leitura:
# Cronico IRR = 4.48 -> "Ter doença crônica aumenta a taxa de consultas em 4.48 vezes (ou 348%)."

# 3. Testando Binomial Negativa (Se houvesse superdispersão)
# alpha é o parâmetro de dispersão (se alpha=0, volta a ser Poisson)
modelo_nb = smf.negativebinomial("consultas ~ idade + cronico", data=df, alpha=1.0).fit()

print("\n--- Comparação AIC (Menor é melhor) ---")
print(f"Poisson AIC: {modelo_poi.aic:.1f}")
print(f"NegBin AIC: {modelo_nb.aic:.1f}")
# Se NB tiver AIC muito menor, houve superdispersão e ele corrigiu.
```

### Por que não Linear?
Note que a contagem anual de consultas é sempre $\geq 0$ e inteira. A Regressão Linear poderia prever "-2 consultas" para um jovem saudável. O GLM respeita a natureza dos dados.
