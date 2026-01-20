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

# Correlação Parcial: Controlando Confundidores

> **"A correlação entre A e B é real, ou é culpa de C?"**
>
> Muitas vezes, duas variáveis parecem conectadas, mas ambas são apenas sintomas de uma terceira causa comum. A **Correlação Parcial** é a ferramenta estatística que nos permite "limpar" esse ruído e ver a relação pura entre duas variáveis, mantendo a terceira constante.

---

## 1. O Conceito de "Controlar por"

Imagine que você descobre uma correlação forte ($r=0.8$) entre **Venda de Sorvetes** ($X$) e **Ataques de Tubarão** ($Y$).
*   Você proibiria sorvete nas praias? Não.
*   Você sabe que existe um **Confundidor ($Z$): Temperatura**.
    *   Calor faz vender sorvete.
    *   Calor faz gente entrar no mar (e encontrar tubarões).

A Correlação Parcial ($r_{xy.z}$) responde à pergunta:
**"Se todos os dias tivessem exatamente a mesma temperatura, qual seria a correlação entre sorvete e tubarões?"**
Provavelmente, seria zero.

---

## 2. A Intuição Matemática (Método dos Resíduos)

Como o computador "fixa a temperatura" matematicamente sem precisar deletar dados? **Via Resíduos de Regressão.**

O processo mental (e matemático) é:
1.  **Limpar X:** Tentamos prever Sorvete ($X$) usando Temperatura ($Z$). O que sobra (o **resíduo**) é a variação na venda de sorvete que *não tem nada a ver com o calor*.
2.  **Limpar Y:** Tentamos prever Ataques ($Y$) usando Temperatura ($Z$). O resíduo é a variação nos ataques que *independe do calor*.
3.  **Correlacionar as Sobras:** Calculamos a correlação de Pearson entre o Resíduo de X e o Resíduo de Y.

Se essa nova correlação for zero, a associação original era espúria. Se ainda for alta, então existe uma conexão direta real.

---

## 3. Prática em Python

Vamos simular esse cenário e resolvê-lo de duas formas:
1.  **Método Manual (Hard way):** Para entender o que está acontecendo "debaixo do capô".
2.  **Método Pingouin (Easy way):** Como fazemos na vida real.

```python
import numpy as np
import pandas as pd
import scipy.stats as stats
import statsmodels.formula.api as smf
import seaborn as sns
import matplotlib.pyplot as plt

# Configuração visual
sns.set_theme(style="whitegrid")
np.random.seed(42)

# --- 1. Gerando Dados (Cenário de Confundidor) ---
n = 200
# Z: Temperatura (Causa Comum)
temperatura = np.random.normal(30, 5, n)

# X: Sorvetes (Explicado pela temperatura + ruído aleatório)
# Dependência forte de Z
sorvetes = 20 * temperatura + np.random.normal(0, 10, n)

# Y: Tubarões (Explicado pela temperatura + ruído aleatório)
# Dependência forte de Z, mas NENHUMA ligação direta com X
tubaroes = 0.5 * temperatura + np.random.normal(0, 5, n)

df = pd.DataFrame({'temp': temperatura, 'sorvete': sorvetes, 'tubarao': tubaroes})

# --- 2. Correlação Simples (Ingênua) ---
r_simples, _ = stats.pearsonr(df['sorvete'], df['tubarao'])

print(f"Correlação Simples (Sorvete vs Tubarão): {r_simples:.4f}")
# Resultado esperado: ~0.8 (Alto! Parece que sorvete atrai tubarão)


# --- 3. Correlação Parcial (Método Manual: Resíduos) ---
# Passo A: Regredir Sorvete ~ Temp e pegar resíduos
res_sorvete = smf.ols('sorvete ~ temp', data=df).fit().resid

# Passo B: Regredir Tubarão ~ Temp e pegar resíduos
res_tubarao = smf.ols('tubarao ~ temp', data=df).fit().resid

# Passo C: Correlacionar os resíduos
r_parcial, p_valor = stats.pearsonr(res_sorvete, res_tubarao)

print(f"Correlação Parcial (Controlando Temp):   {r_parcial:.4f}")
# Resultado esperado: ~0.0 (A verdade aparece!)


# --- Visualização do "Milagre" ---
fig, ax = plt.subplots(1, 2, figsize=(12, 5))

# Gráfico 1: A Ilusão
sns.scatterplot(x='sorvete', y='tubarao', data=df, ax=ax[0], color='salmon')
ax[0].set_title(f'Antes: Correlação Espúria (r={r_simples:.2f})')
ax[0].set_ylabel('Ataques de Tubarão')

# Gráfico 2: A Realidade (Resíduos)
sns.scatterplot(x=res_sorvete, y=res_tubarao, ax=ax[1], color='teal')
ax[1].set_title(f'Depois: Controlando Temperatura (r={r_parcial:.2f})')
ax[1].set_xlabel('Resíduos de Sorvete (Variação s/ Temp)')
ax[1].set_ylabel('Resíduos de Tubarão (Variação s/ Temp)')

plt.tight_layout()
# plt.show()
```

### Usando Bibliotecas Prontas (`pingouin`)

Na prática profissional, não calculamos resíduos na mão. Usamos a biblioteca `pingouin`, que é excelente para estatística t-test, ANOVA e correlações robustas.

> **Instalação:** `pip install pingouin`

```python
import pingouin as pg

# Uma linha de código para resolver tudo
stats_parcial = pg.partial_corr(data=df, x='sorvete', y='tubarao', covar='temp')

print("\n--- Resultado com Pingouin ---")
print(stats_parcial)
# O output mostrará o 'r' (correlação) corrigido e o p-valor
```

### Quando usar Correlação Parcial?
*   **Controle de Qualidade:** Verificar se a correlação entre "Tempo de Fábrica" e "Defeitos" persiste se controlarmos pela "Qualidade da Matéria Prima".
*   **Psicometria:** Entender se "Inteligência" correlaciona com "Renda" se controlarmos pela "Educação dos Pais".
*   **Saúde:** Saber se "Café" causa "Câncer" controlando pelo "Cigarro" (spoiler: a correlação costuma sumir, pois fumantes bebem mais café).
