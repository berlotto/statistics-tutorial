# Distribuição de Frequência e Forma

> **"Os olhos humanos são ótimos detectores de padrões, mas péssimos estimadores de probabilidade."**
>
> Olhar uma tabela gigantesca de números não diz nada. Olhar para a "forma" desses dados (o Histograma) nos conta a história instantaneamente: "É normal?", "Tem duas modas?", "Está enviesado para a esquerda?".

---

## 1. Tabelas de Frequência
A forma mais primitiva de resumo.
*   **Absoluta ($n_i$):** Contagem simples (ex: 50 pacientes).
*   **Relativa ($f_i$):** Porcentagem (ex: 10%).
*   **Acumulada ($F_i$):** Soma progressiva ("Quantos ganham *até* R$ 5k?").

---

## 2. Histograma
O rei da visualização estatística. Divide os dados contínuos em faixas (*bins*) e conta quantas observações caem em cada faixa.

### A Escolha de *Bins* (O Segredo)
Mudar o número de bins pode mudar a história.
*   **Poucos bins:** Oculta detalhes (Underfitting).
*   **Muitos bins:** Mostra ruído aleatório (Overfitting).
*   **Regra de Ouro (Sturges):** $k \approx 1 + 3.322 \log_{10} n$. O Python (`matplotlib/seaborn`) geralmente escolhe bem no automático (Regra de Freedman-Diaconis).

---

## 3. Estimativa de Densidade de Kernel (KDE)
Imagine que cada ponto de dado é um bloco de manteiga. Se derretermos esses blocos, teremos uma curva suave. Isso é o KDE.
*   **Vantagem:** Elimina a arbitrariedade dos *bins* do histograma. Mostra a "forma real" da distribuição de probabilidade subjacente.

---

## 4. Analisando a Forma (Mometos 3 e 4)

### 4.1 Assimetria (*Skewness*) - 3º Momento
Mede para onde a cauda dos dados se estica.
*   **Simétrica (Skew $\approx$ 0):** Média $\approx$ Mediana. (ex: Altura, QI).
*   **Positiva / À Direita (Skew > 0):** Cauda longa para a direita. Média > Mediana. (ex: Salários, Riqueza, Tempo de reação). *A maioria ganha pouco, poucos ganham muito.*
*   **Negativa / À Esquerda (Skew < 0):** Cauda longa para a esquerda. Média < Mediana. (ex: Idade de óbito em países desenvolvidos, Notas em prova muito fácil).

### 4.2 Curtose (*Kurtosis*) - 4º Momento
Mede o peso das caudas (e não o pico, como muitos pensam). Indique a propensão a **outliers extremos**.
*   **Mesocúrtica (K $\approx$ 3):** Normal padrão.
*   **Leptocúrtica (K > 3):** Caudas pesadas. Eventos raros acontecem com mais frequência do que na Normal (Cisnes Negros).
*   **Platicúrtica (K < 3):** Caudas leves. Dispersão mais uniforme.

---

## 5. Prática em Python: Histograma, KDE e Métricas

```python
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import skew, kurtosis

# Configurando visualização
sns.set_theme(style="whitegrid")

# 1. Gerando Dados Simulados
np.random.seed(42)
# Distribuição Normal (Simétrica)
dados_normal = np.random.normal(loc=100, scale=15, size=1000)
# Distribuição Exponencial (Assimétrica à Direita)
dados_assim = np.random.exponential(scale=100, size=1000)

df = pd.DataFrame({'Normal': dados_normal, 'Assimétrica': dados_assim})

# 2. Plotando Histograma + KDE
fig, ax = plt.subplots(1, 2, figsize=(12, 5))

# Gráfico 1: Normal
sns.histplot(df['Normal'], kde=True, color='skyblue', ax=ax[0])
ax[0].set_title('Distribuição Normal\n(Média $\\approx$ Mediana)')

# Gráfico 2: Assimétrica
sns.histplot(df['Assimétrica'], kde=True, color='salmon', ax=ax[1])
ax[1].set_title('Distribuição Assimétrica Positiva\n(Cauda para a Direita)')

# Calculando as métricas de forma
media_n = df['Normal'].mean()
mediana_n = df['Normal'].median()
skew_n = skew(df['Normal'])

media_a = df['Assimétrica'].mean()
mediana_a = df['Assimétrica'].median()
skew_a = skew(df['Assimétrica'])

print(f"--- Distribuição Normal ---")
print(f"Média: {media_n:.2f} | Mediana: {mediana_n:.2f}")
print(f"Skewness: {skew_n:.2f} (Próximo de 0)")

print(f"\n--- Distribuição Assimétrica ---")
print(f"Média: {media_a:.2f} | Mediana: {mediana_a:.2f}")
print(f"Skewness: {skew_a:.2f} (Positivo = Cauda Dir.)")
print("Nota: A média é puxada pelos valores extremos!")

# plt.show()
```

### Interpretação
Note como na distribuição **Assimétrica**, a média se afasta da mediana, indo em direção à cauda. Em dados de saúde (tempo de sobrevivência) ou economia (renda), assumir normalidade (simetria) pode levar a erros graves de planejamento. Testar o *Skewness* é o primeiro passo antes de escolher um teste estatístico.
