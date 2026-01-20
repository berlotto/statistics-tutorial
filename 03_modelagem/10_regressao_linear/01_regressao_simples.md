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

# Regressão Linear Simples: A Arte de Prever

> **"Todos os conceitos estatísticos convergem para a Regressão."**
>
> Até agora, comparamos grupos (Teste T). Agora, vamos **conectar** variáveis. Se eu aumento X, quanto sobe Y? Isso é modelagem.

---

## 1. O Conceito ($Y = \beta_0 + \beta_1 X + \epsilon$)
Queremos traçar uma reta que minimize o erro entre os pontos reais e a linha.
*   **$Y$ (Variável Dependente/Desfecho):** O que queremos prever (ex: Salário).
*   **$X$ (Variável Independente/Preditor):** O que explica (ex: Anos de Experiência).
*   **$\beta_0$ (Intercepto):** O valor de Y quando X=0.
*   **$\beta_1$ (Inclinação/Slope):** O quanto Y aumenta para cada unidade extra de X. **(O número mais importante!)**
*   **$\epsilon$ (Resíduo):** O erro aleatório que o modelo não consegue explicar.

---

## 2. O Método: Mínimos Quadrados Ordinários (OLS)
Como escolher a "melhor reta"? A matemática escolhe a reta que torna a **Soma dos Quadrados dos Resíduos (RSS)** a menor possível.

### Coeficiente de Determinação ($R^2$)
Quanto da variação de Y é explicada por X?
*   $R^2 = 0$: O modelo é inútil.
*   $R^2 = 1$: O modelo acerta tudo perfeitamente (suspeito!).
*   *Em ciências sociais/saúde, $R^2$ de 0.3 ou 0.4 já é considerado excelente.*

---

## 3. Prática em Python: `statsmodels` (O Jeito Científico)
O `scikit-learn` é ótimo para Machine Learning (foco em predição), mas o `statsmodels` é **obrigatório** para Estatística (foco em inferência e p-valores dos coeficientes).

```python
import numpy as np
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Preço de Carros (Y) baseados na Potência (X)
# Y = 10.000 + 200 * CV + erro
n = 50
potencia = np.random.uniform(100, 300, n) # Cavalos (CV)
erro = np.random.normal(0, 5000, n)       # Ruído de mercado
preco = 10000 + 200 * potencia + erro

df = pd.DataFrame({'potencia': potencia, 'preco': preco})

# 1. Definindo Variáveis
X = df['potencia']
y = df['preco']

# IMPORTANTE: Statsmodels não adiciona intercepto (constante) por padrão!
X_com_constante = sm.add_constant(X)

# 2. Ajustando o Modelo (Fit)
modelo = sm.OLS(y, X_com_constante).fit()

# 3. O Relatório Completo (Summary)
print(modelo.summary())

# Vamos extrair o que importa para um humano:
print(f"\n--- Interpretação Humana ---")
print(f"R-quadrado: {modelo.rsquared:.4f} (O modelo explica {modelo.rsquared:.1%} da variação de preço)")
print(f"Intercepto: R$ {modelo.params['const']:.2f}")
print(f"Inclinação (Beta da Potência): R$ {modelo.params['potencia']:.2f}")
print(f"P-valor da Potência: {modelo.pvalues['potencia']:.4e}")

# Interpretação do Beta:
# "Para cada 1 CV (Cavalo) a mais de potência, o preço do carro aumenta, 
# em média, R$ 200,00, mantendo tudo o mais constante."
# Se o p-valor for < 0.05, esse aumento é estatisticamente significativo.

# 4. Visualização da Reta
plt.figure(figsize=(8, 6))
sns.regplot(x='potencia', y='preco', data=df, line_kws={'color': 'red'})
plt.title(f'Regressão Linear: Preço = {modelo.params["const"]:.0f} + {modelo.params["potencia"]:.1f}*CV')
plt.xlabel('Potência (CV)')
plt.ylabel('Preço (R$)')
# plt.show()
```

### Por que `statsmodels` e não `sklearn`?
Rode o código. Olhe a tabela `summary()`. Ela mostra:
1.  **P-valor de cada coeficiente:** A variável X importa mesmo?
2.  **Intervalo de Confiança do Beta:** O aumento é R$ 200, mas pode ser entre R$ 180 e R$ 220?
3.  **Testes de Diagnóstico:** Jarque-Bera (Normalidade dos resíduos), Durbin-Watson (Autocorrelação).
O `sklearn` esconde tudo isso (black box).
