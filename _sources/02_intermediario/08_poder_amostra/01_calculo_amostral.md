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

# Cálculo Amostral: Quantos Precisamos?

> **"Qual o $N$ ideal? O menor possível que satisfaça seu orçamento e sua necessidade de precisão."**
>
> Chegou o momento. Agora que você entende **Variância** ($s^2$) e **Intervalo de Confiança** ($Z$), podemos calcular o tamanho da amostra científicamente.

---

## 1. Os Ingredientes da Fórmula
Para calcular $n$, você **precisa** definir 3 coisas antecipadamente:

1.  **Margem de Erro ($E$):** O quanto você aceita errar para mais ou para menos? (ex: $\pm 2\%$).
2.  **Nível de Confiança ($Z$):** Quão certo você quer estar de que o erro está nessa margem? (ex: 95% $\to Z=1.96$).
3.  **Variabilidade da População ($\sigma$ ou $p$):**
    *   Para **Médias:** Você precisa estimar o Desvio Padrão ($\sigma$). (Use literatura ou estudo piloto).
    *   Para **Proporções:** Você precisa estimar a proporção esperada ($p$). Na pior hipótese (incerteza máxima), use $p=0.5$ (50%).

---

## 2. As Fórmulas Sagradas

### A. Para Proporções (População Infinita)
Ex: "Qual a % de clientes satisfeitos?"
$$ n \approx \frac{Z^2 \cdot p \cdot (1-p)}{E^2} $$
*   Note que o erro $E$ está ao quadrado no denominador. **Dividir o erro pela metade exige QUADRUPLICAR a amostra.**

### B. Para Médias (População Infinita)
Ex: "Qual o salário médio?"
$$ n \approx \left( \frac{Z \cdot \sigma}{E} \right)^2 $$

### C. Correção para População Finita ($N$)
Se sua amostra é > 5% da população total, você pode "economizar" amostra.
$$ n_{final} = \frac{n_{infinito}}{1 + \frac{n_{infinito}-1}{N}} $$

---

## 3. Prática em Python: Calculadoras Reais

O `statsmodels` é mais rigoroso que calculadoras de internet porque ele calcula o **Poder (Power)**.

```python
import numpy as np
import statsmodels.stats.power as smp
import math

# --- 1. Método Clássico (Fórmulas) ---
def calcular_n_proporcao(erro, confianca=0.95, p=0.5, N=None):
    # Z-score para a confiança
    z = stats.norm.ppf((1 + confianca) / 2)
    
    # Amostra Infinita
    n = (z**2 * p * (1-p)) / (erro**2)
    
    # Ajuste População Finita
    if N:
        n = n / (1 + (n-1)/N)
        
    return math.ceil(n) # Sempre arredonda para cima!

# Exemplo: Eleição. Quero erro de 2% (0.02) com 95% confiança.
n_eleicao = calcular_n_proporcao(erro=0.02, confianca=0.95)
print(f"Necessário para Erro 2%: {n_eleicao} pessoas")
# Resultado típico: ~2401 pessoas.

# --- 2. Método Poder Estatístico (Teste T) ---
# "Quero detectar uma diferença de 2kg (efeito) com 80% de poder".

from statsmodels.stats.power import TTestIndPower

effect_size = 0.5 # d de Cohen médio
alpha = 0.05      # 5% de chance de Falso Positivo
power = 0.80      # 80% de chance de achar o efeito se ele existir

analysis = TTestIndPower()
n_per_group = analysis.solve_power(effect_size=effect_size, power=power, alpha=alpha)

print(f"\n--- Dimensionamento Experimental (Teste T) ---")
print(f"Para detectar efeito médio (d=0.5) com 80% de Poder:")
print(f"Você precisa de {math.ceil(n_per_group)} pessoas POR GRUPO.")
print(f"Total: {math.ceil(n_per_group)*2} voluntários.")
```

### O Dilema do Orçamento
O cliente sempre quer **Erro de 1% com 99% de Confiança**.
*   Rode o código. Isso exigiria n > 16.000 pessoas.
*   Mostre que aceitar **Erro de 3% e 95% Confiança** baixa o n para ~1.000.
*   Esse é o papel do cientista: negociar custo vs precisão.
