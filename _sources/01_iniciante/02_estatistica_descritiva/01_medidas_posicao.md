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

# Medidas de Posição (Tendência Central)

> **"A pessoa média tem um seio e um testículo."**
>
> Essa piada clássica da estatística ilustra o perigo de olhar apenas para a Média. Se os dados são heterogêneos ou assimétricos, a média mente. O cientista de dados rigoroso busca o "centro" que melhor representa a realidade.

---

## 1. Média Aritmética ($\bar{x}$ ou $\mu$)
A soma de todos dividida pelo número de observações.
$$ \bar{x} = \frac{\sum x_i}{n} $$

*   **Ponto Forte:** Usa toda a informação disponível. É a base para Variância, Desvio Padrão e Teste T.
*   **Ponto Fraco:** Extremamente sensível a **outliers** (valores discrepantes).
    *   *Exemplo:* Em uma sala com 10 estagiários ganhando R$ 2k, a média é R$ 2k. Se o CEO (R$ 100k) entrar, a média sobe para ~R$ 11k. O "salário médio" representa alguém ali? Não.

---

## 2. Mediana (O Centro Robusto)
O valor que divide a amostra ordenada exatamente ao meio (50% abaixo, 50% acima).

*   **Ponto Forte:** Robusta a outliers. No exemplo do CEO, a mediana continuaria sendo R$ 2k.
*   **Quando usar:** Quando a distribuição é **Assimétrica** (ex: Salários, Preços de Imóveis, Tempos de Espera).
*   **Regra de Ouro:** Se Média $\approx$ Mediana, a distribuição é simétrica (provavelmente Normal). Se Média $\neq$ Mediana, investigue a assimetria.

---

## 3. Moda
O valor mais frequente.
*   **Quando usar:** Única medida possível para **Dados Nominais** (ex: a marca de carro mais vendida).
*   **Tipos:** Unimodal, Bimodal (população misturada?), Multimodal ou Amodal (plana).

---

## 4. Média Ponderada e Geométrica
*   **Ponderada:** Quando alguns dados valem mais ("pesos").
*   **Geométrica:** Para taxas de crescimento ou escalas logarítmicas. Se uma ação cai 50% num dia e sobe 50% no outro, a média aritmética diz que o retorno foi 0%. A geométrica mostra que você perdeu dinheiro (0.5 * 1.5 = 0.75, ou seja, -25%).

---

## 5. Assimetria (Skewness) e Curtose (Kurtosis)

Além de saber onde está o centro, precisamos saber a *forma* da distribuição.

### 5.1 Assimetria (Skewness)
Mede a falta de simetria dos dados.
*   **Simétrica (Skew $\approx$ 0):** Média $\approx$ Mediana. (Ex: Altura, QI).
*   **Assimétrica à Direita / Positiva (Skew > 0):** Cauda longa à direita. Média > Mediana. (Ex: Renda, Aluguéis, Acidentes). A maioria dos dados é "baixa", mas os ricos puxam a média.
*   **Assimétrica à Esquerda / Negativa (Skew < 0):** Cauda longa à esquerda. Média < Mediana. (Ex: Idade de óbito em países desenvolvidos, Notas em prova muito fácil).

### 5.2 Curtose (Kurtosis)
Mede o "peso das caudas" (frequentemente confundido com "achatamento").
*   **Mesocúrtica (Kurt $\approx$ 3 ou Excess $\approx$ 0):** Similar à Normal.
*   **Leptocúrtica (Kurt > 3):** Caudas pesadas. **Importante em Risco:** Indica que eventos extremos (Cisnes Negros) são mais prováveis do que numa curva normal. (Ex: Retornos financeiros em crise).
*   **Platicúrtica (Kurt < 3):** Caudas leves. Menos outliers extremos. (Ex: Distribuição Uniforme).

## 6. Prática em Python: A Sensibilidade aos Outliers e Forma

```python
import pandas as pd
import numpy as np
from scipy.stats import gmean, skew, kurtosis
import matplotlib.pyplot as plt
import seaborn as sns

# --- Cenário Comparativo: Mesma Média, Realidades Diferentes ---
# Dataset A: Simétrico (Normal)
data_a = np.random.normal(loc=100, scale=20, size=1000)

# Dataset B: Assimétrico (Log-normal - comum em salários/preços)
# Ajustado para ter média próxima de 100 também
data_b = np.random.lognormal(mean=4.1, sigma=1.0, size=1000) 

print(f"Média A: {np.mean(data_a):.2f} | Mediana A: {np.median(data_a):.2f}")
print(f"Média B: {np.mean(data_b):.2f} | Mediana B: {np.median(data_b):.2f}")

# Cálculo de Forma
print(f"\nAssimetria A: {skew(data_a):.2f} (Próximo de 0)")
print(f"Assimetria B: {skew(data_b):.2f} (Positiva forte)")

# Exemplo Clássico: Salários na Startup
# 19 Desenvolvedores e 1 Fundador
salarios = np.array([5000] * 19 + [150000])

df = pd.DataFrame({'salario': salarios})

media = df['salario'].mean()
mediana = df['salario'].median()
moda = df['salario'].mode()[0]

print(f"--- Comparação de Centralidade ---")
print(f"Média:   R$ {media:,.2f}  (Inflada pelo outlier)")
print(f"Mediana: R$ {mediana:,.2f}  (Representa a realidade da maioria)")
print(f"Moda:    R$ {moda:,.2f}")

# Detecção rápida de assimetria
if media > mediana:
    print("\nDiagnóstico: Assimetria à DIREITA (Positiva). A cauda dos ricos puxa a média.")
elif media < mediana:
    print("\nDiagnóstico: Assimetria à ESQUERDA (Negativa).")
else:
    print("\nDiagnóstico: Distribuição Simétrica.")

# Exemplo Média Ponderada
# Notas com pesos diferentes
notas = [8.0, 7.0, 9.0]
pesos = [1, 2, 3] # Prova final vale mais

media_simples = np.mean(notas)
media_ponderada = np.average(notas, weights=pesos)

print(f"\nMédia Simples: {media_simples:.2f}")
print(f"Média Ponderada: {media_ponderada:.2f} (Puxada pela nota 9.0 que tem peso 3)")
```

### O Que Levar Deste Código
1.  Sempre calcule **Média E Mediana**.
2.  A diferença entre elas é o seu primeiro "alerta de viés" ou assimetria.
3.  Reportar apenas a média em dados financeiros ou de saúde (ex: tempo de internação) é frequentemente considerado má conduta metodológica.
