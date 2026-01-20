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

# Boxplot, Outliers e Violin Plots

> **"Valores discrepantes (outliers) não são erros necessariamente; às vezes são a descoberta do século."** — Fleming descobrindo a Penicilina (um fungo "intruso" na placa).
>
> O Boxplot não julga, ele aponta. Cabe ao cientista decidir: é erro de digitação ou um fenômeno real?

---

## 1. A Anatomia do Boxplot (Diagrama de Caixa)
Criado pelo gigante John Tukey, é a melhor ferramenta para resumir a distribuição robusta (baseada em Quartis, não em Média).

*   **A "Caixa":** Representa o **IQR** (Intervalo Interquartil). 50% dos dados centrais estão ali dentro (entre $Q_1$ e $Q_3$).
*   **O "Risco" do meio:** É a **Mediana** ($Q_2$). NÃO é a média.
*   **Os "Bigodes" (Whiskers):** Se estendem até o último dado que **NÃO é um outlier**. A regra padrão (Tukey) é no máximo $1.5 \times IQR$.
*   **Os Pontos Fora:** São os **Outliers** (discrepantes). Valores além dos limites dos bigodes.

---

## 2. Detectando Outliers
Como definir matematicamente o que é "estranho"?

### Método A: Intervalo Interquartil (Robusto)
$$ Limite Inferior = Q_1 - 1.5 \times IQR $$
$$ Limite Superior = Q_3 + 1.5 \times IQR $$
*   **Uso:** Padrão ouro para dados não-normais ou assimétricos. Resiste bem a distorções.

### Método B: Z-Score (Sensível)
Qualquer dado com mais de 3 desvios padrões da média ($|Z| > 3$).
*   **Risco:** Só funciona bem se os dados forem **Normais**. Se a distribuição já tiver caudas longas naturais (ex: renda), o Z-Score vai marcar muita gente legítima como "outlier".

---

## 3. Violin Plot: A Evolução (Boxplot + KDE)
O Boxplot esconde a "forma" da distribuição (ele mostra só a caixinha retangular). E se os dados forem bimodais? O Boxplot não mostra.
*   **Violin Plot:** Combina a caixa do Boxplot com a curva de densidade (KDE) nas laterais. Permite ver "onde tem mais gente".

---

## 4. Prática em Python: Identificando e "Tratando"

```python
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="whitegrid")

# 1. Dados: Idade de participantes + 1 Erro de Digitação
np.random.seed(10)
idades = np.random.normal(loc=35, scale=5, size=50) # Pessoas normais
idades = np.append(idades, [120, 1500]) # 1 Idoso (120) e 1 Erro (1500 anos??)

df = pd.DataFrame({'idade': idades})

# 2. Visualização: Boxplot
plt.figure(figsize=(10, 4))
sns.boxplot(x=df['idade'], color='lightgreen')
plt.title('Boxplot: Identificando a "Sujeira"')
plt.xlabel('Idade (anos)')
# Na tela, você veria pontos isolados lá no 140 e no 1000.

# 3. Detecção Automática (Método IQR)
Q1 = df['idade'].quantile(0.25)
Q3 = df['idade'].quantile(0.75)
IQR = Q3 - Q1

limite_inf = Q1 - 1.5 * IQR
limite_sup = Q3 + 1.5 * IQR

outliers = df[(df['idade'] < limite_inf) | (df['idade'] > limite_sup)]

print(f"Limites IQR: {limite_inf:.2f} a {limite_sup:.2f}")
print(f"Outliers Detectados:\n{outliers}")

# 4. Decisão do Cientista (Filtragem)
# O valor 120 é possível? Sim. O valor 1500 é erro.
# Uma limpeza inteligente removeria apenas o impossível, ou usaria quantis fixos (ex: 99%)
df_limpo = df[df['idade'] < 130] # Regra de negócio: ninguém vive > 130

print(f"\nMédia Original (com erro): {df['idade'].mean():.2f}")
print(f"Média Limpa: {df_limpo['idade'].mean():.2f}")
print(f"Mediana Original (Robusta): {df['idade'].median():.2f}") 
# Note como a mediana quase não sentiu o erro de 1500!
```

### Interpretação para Projetos Reais
O Boxplot é sua primeira defesa contra dados sujos. Se você rodar um modelo de Machine Learning com aquele "1500" na idade, o modelo vai quebrar.
*   **Mediana:** Ignorou o erro de 1500 anos.
*   **Média:** Foi destruída por ele.
*   **Ação:** Use o Boxplot na fase de EDA (Exploratory Data Analysis) para criar regras de filtro (`query`).
