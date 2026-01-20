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

# Regressão Múltipla e Diagnóstico: O Mundo Real

> **"Correlação não é Causalidade... mas uma Regressão Múltipla bem feita chega bem perto."**
>
> Na vida real, nada depende de uma única causa. O salário depende da experiência, MAS TAMBÉM da educação, do setor e do gênero.
> A Regressão Múltipla nos permite dizer: *"Qual o efeito da Educação sobre o Salário, **mantendo a Experiência constante**?"* (Ceteris Paribus).

---

## 1. O Modelo Multivariado
$$ Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + ... + \epsilon $$

### Variáveis Dummy (Categóricas)
Regressão só entende números. Como colocar "Sexo (M/F)" na equação?
Criamos uma variável Dummy (0 ou 1).
*   $X_{sexo} = 1$ (Mulher), $0$ (Homem).
*   O $\beta_{sexo}$ será a **diferença média** de salário das mulheres em relação aos homens (categoria referência), ajustado pelas outras variáveis.

### Termos de Interação ($X_1 \times X_2$)
E se o efeito da Experiência no Salário for *maior* para quem tem Doutorado?
Isso é uma interação. Criamos uma nova variável $X_3 = X_{xp} \times X_{doutorado}$.

---

## 2. Diagnóstico: O Modelo é Confiável?
Não basta rodar `.fit()`. Você precisa checar 4 premissas vitais dos Resíduos ($\epsilon$):
1.  **Linearidade:** A relação é linear?
2.  **Normalidade dos Resíduos:** Os erros seguem uma curva Normal? (Use Jarque-Bera ou Q-Q Plot).
3.  **Homocedasticidade:** O erro é constante ao longo de toda a reta? (Não deve formar um "funil").
4.  **Ausência de Multicolinearidade:** As variáveis X não podem ser muito correlacionadas entre si.

### Multicolinearidade e VIF (Variance Inflation Factor)
Se você coloca "Idade" e "Ano de Nascimento" no mesmo modelo, o Python vai surtar. Elas dizem a mesma coisa. O modelo não sabe a quem atribuir o crédito.
*   **Sintoma:** $R^2$ alto, mas p-valores altos (nada é significativo).
*   **Cura:** Calcule o VIF. Se VIF > 5 ou 10, remova a variável redundante.

---

## 3. Prática em Python: Múltipla, Dummies e VIF

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(10)

# Cenário: Previsão de Salário
n = 100
experiencia = np.random.uniform(0, 20, n)
educacao_anos = np.random.uniform(10, 20, n)
sexo = np.random.choice([0, 1], n) # 0=Homem, 1=Mulher

# Mulheres ganham 1000 a menos (Viés simulado)
# Cada ano de educacao = +500. Cada ano xp = +200.
salario = 2000 + (200 * experiencia) + (500 * educacao_anos) - (1000 * sexo) + np.random.normal(0, 1000, n)

df = pd.DataFrame({'salario': salario, 'xp': experiencia, 'edu': educacao_anos, 'sexo_fem': sexo})

# 1. Regressão Múltipla
X = df[['xp', 'edu', 'sexo_fem']]
X = sm.add_constant(X)
y = df['salario']

modelo = sm.OLS(y, X).fit()
print(modelo.summary())

# Você verá que o coef 'sexo_fem' será próximo de -1000 com p-valor < 0.05.
# Isso isola o efeito do gênero, "descontando" o efeito da educação e experiência.

# 2. Testando Multicolinearidade (VIF)
# Criamos um DataFrame para guardar os VIFs
vif_data = pd.DataFrame()
vif_data["feature"] = X.columns
vif_data["VIF"] = [variance_inflation_factor(X.values, i) for i in range(len(X.columns))]

print("\n--- Variance Inflation Factor (VIF) ---")
print(vif_data)
# Regra: VIF > 5 ou 10 é problema. Constante geralmente tem VIF alto (ignore).
# Se 'xp' tivesse VIF=15, ela estaria brigando com outra variável.

# 3. Análise de Resíduos (Diagnóstico Visual)
residuos = modelo.resid
preditos = modelo.predict(X)

fig, ax = plt.subplots(1, 2, figsize=(12, 5))

# A: Resíduos vs Preditos (Checar Homocedasticidade/Linearidade)
sns.scatterplot(x=preditos, y=residuos, ax=ax[0])
ax[0].axhline(0, color='red', linestyle='--')
ax[0].set_title('Resíduos vs Preditos (Ideal: Nuvem aleatória)')
# Se formar um padrão (U ou Funil), tem problema.

# B: QQ Plot (Checar Normalidade dos Resíduos)
sm.qqplot(residuos, line='45', fit=True, ax=ax[1])
ax[1].set_title('QQ Plot dos Resíduos')

plt.tight_layout()
# plt.show()
```

### O $R^2$ Ajustado
Na regressão múltipla, sempre olhe o **Adj. R-squared**.
O $R^2$ normal *sempre* aumenta se você colocar variáveis lixo no modelo. O Ajustado pune variáveis inúteis. Se o Ajustado for muito menor que o normal, você tem excesso de variáveis (Overfitting).
