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

# Seleção de Modelos: A Navalha de Occam

> **"Entia non sunt multiplicanda praeter necessitatem." (As entidades não devem ser multiplicadas além do necessário).** — William of Ockham
>
> Entre dois modelos com performance similar, o **mais simples** é sempre o melhor. Um modelo com 50 variáveis vai ter um $R^2$ incrível, mas vai falhar miseravelmente com novos dados (Overfitting).

---

## 1. Critérios de Informação (AIC e BIC)
Eles penalizam a complexidade. É um saldo entre "Quão bem ajusta" (Likelihood) e "Quantas variáveis usou" (Penalidade).

### AIC (Akaike Information Criterion)
*   **Foco:** Predição. Tenta estimar a qualidade do modelo em dados futuros.
*   **Fórmula:** $AIC = 2k - 2\ln(L)$ (onde $k$ é o nº de variáveis).
*   **Interpretação:** Quanto MENOR, melhor. Diferenças < 2 são irrelevantes. Diferenças > 10 são decisivas.

### BIC (Bayesian Information Criterion)
*   **Foco:** Encontrar o modelo "verdadeiro".
*   **Penalidade:** Mais severa que o AIC para grandes amostras. Tende a escolher modelos mais enxutos.

---

## 2. A Morte do Stepwise
Antigamente, softwares faziam "Stepwise Selection": adicionar/remover variáveis automaticamente baseado no p-valor.
**NÃO FAÇA ISSO.**
*   Isso infla o $R^2$, vicia os p-valores e ignora a teoria.
*   **Alternativa Moderna:** Regularização (Lasso/Ridge) ou conhecimento do especialista (Teoria).

---

## 3. Regularização (Conceito)
Em vez de remover variáveis bruta (entrar/sair), nós "encolhemos" os coeficientes das variáveis inúteis em direção a zero.
*   **LASSO (L1):** Zera coeficientes inúteis (seleção automática).
*   **RIDGE (L2):** Diminui coeficientes correlacionados (resolve multicolinearidade).

---

## 4. Prática em Python: Comparando AIC/BIC

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf

np.random.seed(42)

# Cenário: Consumo de Combustível (Y)
# X1: Peso (Importante)
# X2: Potência (Importante)
# X3: Cor do Carro (Inútil - Ruído)
n = 100
X1 = np.random.normal(1000, 200, n)
X2 = np.random.normal(100, 30, n)
X3 = np.random.choice([0, 1], n) # Cor
y = 10 + 0.01*X1 + 0.5*X2 + np.random.normal(0, 5, n) # Note: X3 não entra na conta real

df = pd.DataFrame({'y':y, 'peso':X1, 'cv':X2, 'cor':X3})

# Modelo 1: Complexo (Todas as variáveis)
mod_complexo = smf.ols('y ~ peso + cv + cor', data=df).fit()

# Modelo 2: Simples (Apenas as relevantes)
mod_simples = smf.ols('y ~ peso + cv', data=df).fit()

print("--- Comparação de Modelos ---")
print(f"Modelo Complexo (R2={mod_complexo.rsquared:.3f}):")
print(f"AIC: {mod_complexo.aic:.2f} | BIC: {mod_complexo.bic:.2f}")

print(f"\nModelo Simples (R2={mod_simples.rsquared:.3f}):")
print(f"AIC: {mod_simples.aic:.2f} | BIC: {mod_simples.bic:.2f}")

# Decisão
diff_aic = mod_complexo.aic - mod_simples.aic
print(f"\nDiferença de AIC: {diff_aic:.2f}")

if mod_simples.aic < mod_complexo.aic:
    print(">> O AIC prefere o Modelo Simples (Menor valor).")
    print(">> A variável 'cor' não pagou seu custo de complexidade.")
else:
    print(">> O AIC prefere o Modelo Complexo.")
```

### Conclusão do Cientista
Sempre reporte o AIC/BIC ao comparar modelos. Se adicionar uma variável melhora o AIC, ela é útil. Se o AIC piora (sobe), ela é ruído, mesmo que tenha alguma correlaçãozinha.
