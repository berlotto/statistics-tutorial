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

# Medidas de Dispersão (Variabilidade)

> **"A estatística é a ciência que diz que, se você colocar a cabeça no forno e os pés na geladeira, na média seu corpo está numa temperatura ótima."**
>
> Saber apenas a média é perigoso. A dispersão nos diz quão confiável essa média é. Dois hospitais podem ter o mesmo tempo médio de espera (30 min), mas um varia de 25-35 min (consistente) e o outro de 5-55 min (caótico). Em qual você iria?

---

## 1. Amplitude Total (Range)
É a diferença entre o maior e o menor valor.
$$ Amplitude = Max - Min $$
*   **Problema:** Depende apenas dos dois extremos. Um único erro de digitação (1000 em vez de 10) explode a amplitude.

## 2. Intervalo Interquartil (IQR)
A amplitude "focada no centro". É a diferença entre o 3º Quartil ($Q3$, 75%) e o 1º Quartil ($Q1$, 25%).
$$ IQR = Q3 - Q1 $$
*   **Vantagem:** Ignora os 25% menores e os 25% maiores. É a medida de dispersão **robusta** (companheira da Mediana).

---

## 3. Variância ($s^2$ ou $\sigma^2$) e Desvio Padrão ($s$ ou $\sigma$)

A medida rainha da estatística. Baseia-se na distância de *cada ponto* até a média.

### 3.1 A Intuição
Calculamos a diferença de cada ponto para a média, elevamos ao quadrado (para eliminar negativos e punir desvios grandes) e tiramos a média desses quadrados.

### 3.2 A Polêmica do $n-1$ (Graus de Liberdade)
Para calcular a variância da **População** ($\sigma^2$), dividimos por $N$.
Para calcular a variância da **Amostra** ($s^2$), dividimos por $n-1$.

$$ s^2 = \frac{\sum (x_i - \bar{x})^2}{n - 1} $$

**Por que n-1?** (Explicação sênior):
Como usamos a média da *amostra* ($\bar{x}$) para calcular os desvios (em vez da média real da população $\mu$), nós "forçamos" os desvios a serem menores do que realmente são (os dados estão sempre mais próximos da sua própria média do que da média real). Dividir por um número menor ($n-1$ em vez de $n$) corrige essa subestimação. É a **Correção de Bessel**.

### 3.3 Desvio Padrão ($SD$)
É a raiz quadrada da variância. Traz o valor de volta para a **unidade original** (metros, reais, kg).
$$ s = \sqrt{s^2} $$

---

## 4. Coeficiente de Variação (CV)
Como comparar a variabilidade de coisas diferentes?
*   Ex: Variabilidade do peso de um Elefante (SD = 500kg) vs de um Rato (SD = 0.05kg). O elefante varia mais? Em valor absoluto sim, mas proporcionalmente ao tamanho?

$$ CV = \frac{s}{\bar{x}} \times 100 (\%) $$
*   Elimina a unidade de medida. Permite comparar variabilidade de Preço vs Tempo.

---

## 5. Prática em Python: `ddof=1` é crucial

O numpy por padrão calcula variância populacional ($N$). O pandas e o scipy calculam amostral ($n-1$). **Isso cria confusão diária em times de Data Science.**

```python
import pandas as pd
import numpy as np
import scipy.stats as stats

# Cenário: Tempo de resposta de dois servidores (ms)
servidor_A = np.array([195, 200, 205, 198, 202]) # Estável
servidor_B = np.array([150, 250, 100, 300, 200]) # Instável

# Média idêntica!
print(f"Média A: {np.mean(servidor_A)}")
print(f"Média B: {np.mean(servidor_B)}")

# 1. Variância (Cuidado com ddof)
# Numpy default: ddof=0 (População). Pandas default: ddof=1 (Amostra).
var_A_pop = np.var(servidor_A)          # Divide por 5
var_A_amostra = np.var(servidor_A, ddof=1) # Divide por 4 (Correto para inferência!)

print(f"\nVariância Amostral A (ddof=1): {var_A_amostra:.2f}")
print(f"Variância Amostral B (ddof=1): {np.var(servidor_B, ddof=1):.2f}")

# 2. Desvio Padrão
std_A = np.std(servidor_A, ddof=1)
std_B = np.std(servidor_B, ddof=1)

print(f"\nDesvio Padrão A: {std_A:.2f} ms")
print(f"Desvio Padrão B: {std_B:.2f} ms (Muito maior!)")

# 3. Coeficiente de Variação (CV)
# scipy.stats.variation usa ddof=0 por padrão, cuidado.
cv_A = (std_A / np.mean(servidor_A)) * 100
cv_B = (std_B / np.mean(servidor_B)) * 100

print(f"\nCV A: {cv_A:.2f}%")
print(f"CV B: {cv_B:.2f}%")

# 4. IQR (Intervalo Interquartil)
# Usamos o percentil 75 e 25
q3_B, q1_B = np.percentile(servidor_B, [75, 25])
iqr_B = q3_B - q1_B
print(f"\nIQR B: {iqr_B:.2f}")

# --- Regra Prática para o Pesquisador ---
# Se CV > 30% ou 40%, considere os dados como "altamente dispersos".
# A média pode não ser confiável.
```

### Resumo para o Pesquisador Sênior
*   Sempre especifique se está usando desvio padrão amostral ou populacional em relatórios técnicos.
*   Em Python puros (`numpy`), lembre-se do `ddof=1`. No `pandas`, isso já é automático.
*   Dispersão alta sugere que talvez existam subgrupos (clusters) misturados nos seus dados. Investigue!
