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

# Regressão Logística: Prevendo o Sim/Não

> **"A vida é feita de escolhas binárias: Comprar ou não? Curar ou morrer? Fraude ou legítimo?"**
>
> Quando o seu $Y$ é 0 ou 1, a Regressão Linear falha (ela pode prever resultados como -0.5 ou 1.2, o que não faz sentido para probabilidades). Entra a Logística.

---

## 1. Probabilidade ($P$) vs Odds (Chances)
Antes de entender o modelo, precisamos falar a língua das apostas.

*   **Probabilidade ($p$):** Casos Favoráveis / Total.
    *   Ex: 80% de chance de chuva ($p=0.8$).
*   **Odds ($\frac{p}{1-p}$):** Favoráveis / Desfavoráveis.
    *   Ex: 80/20 = 4 para 1. ("A chance é 4 pra 1 que chove").

$$ \text{Odds} = \frac{p}{1-p} \quad \leftrightarrow \quad p = \frac{\text{Odds}}{1+\text{Odds}} $$

---

## 2. A Função Logit
Queremos prever o $p$ (0 a 1). Mas a regressão linear ($X\beta$) vai de $-\infty$ a $+\infty$.
A solução é transformar $p$ em Log-Odds (Logit):
$$ \ln(\text{Odds}) = \beta_0 + \beta_1 X $$
$$ \ln\left(\frac{p}{1-p}\right) = \beta_0 + \beta_1 X $$

Se isolarmos o $p$, chegamos na famosa **Função Sigmoide**:
$$ p = \frac{1}{1 + e^{-(\beta_0 + \beta_1 X)}} $$

---

## 3. Interpretação dos Coeficientes (Odds Ratio)
Em regressão linear, $\beta=2$ significa "Y aumenta 2". Na logística, é mais sutil.
O $\beta$ está na escala logarítmica. Para entender, elevamos a $e$.

*   $\beta = 0.693 \to e^{0.693} \approx 2.0$.
*   **Interpretação:** "Para cada unidade extra de X, as **chances (odds)** de Y acontecer dobram (aumentam 100%)."

---

## 4. Prática em Python: Prevendo Doença Cardíaca

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Prever Doença (1) ou Saúde (0) baseado na Idade
n = 200
idade = np.random.randint(20, 80, n)
# Probabilidade baseada na idade (Sigmoide simulada)
logits = -5 + 0.1 * idade # Aos 50 anos: -5 + 5 = 0 -> Odds=1 -> p=50%
probs = 1 / (1 + np.exp(-logits))
doenca = np.random.binomial(1, probs)

df = pd.DataFrame({'idade': idade, 'doenca': doenca})

# 1. Ajustando o Modelo Logístico
X = sm.add_constant(df['idade'])
y = df['doenca']

modelo_log = sm.Logit(y, X).fit()
print(modelo_log.summary())

# 2. Interpretando os Odds Ratios
beta_idade = modelo_log.params['idade']
odds_ratio = np.exp(beta_idade)

print(f"\n--- Interpretação ---")
print(f"Beta Idade: {beta_idade:.4f}")
print(f"Odds Ratio (e^beta): {odds_ratio:.4f}")
print(f"Conclusão: Para cada ano a mais de vida, a chance (odds) de ter a doença aumenta em {(odds_ratio-1)*100:.1f}%.")
# Ex: Se OR = 1.10, aumenta 10% por ano.

# 3. Visualizando a Curva Sigmoide
# Criamos pontos fictícios para desenhar a curva suave
x_teste = np.linspace(15, 85, 300)
X_teste_sm = sm.add_constant(x_teste)
y_pred_prob = modelo_log.predict(X_teste_sm)

plt.figure(figsize=(10, 6))
sns.scatterplot(x='idade', y='doenca', data=df, color='black', alpha=0.5, label='Dados Reais')
plt.plot(x_teste, y_pred_prob, color='red', linewidth=3, label='Modelo Logístico')
plt.axhline(0.5, color='gray', linestyle='--')
plt.title('Probabilidade de Doença por Idade')
plt.ylabel('Probabilidade (0 a 1)')
plt.legend()
# plt.show()
```

### Nota de Sênior
Nunca reporte apenas o $\beta$ bruto na logística para o público leigo. Ninguém entende "Log-Odds". Converta sempre para **Odds Ratio (RR/OR)** ou **Probabilidade Marginal**.
