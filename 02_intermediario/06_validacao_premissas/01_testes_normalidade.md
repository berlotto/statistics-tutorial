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

# Validação de Premissas: Normalidade

> **"Estatística é como um contrato: se você violar as cláusulas (premissas), a garantia (o resultado) é anulada."**
>
> Antes de rodar um Teste T ou uma ANOVA, você **deve** provar que seus dados têm o direito de usar esses testes. A premissa número 1 é a Normalidade.

---

## 1. Inspeção Visual (O Melhor Método)
Testes estatísticos de normalidade são traiçoeiros (veja item 3). O olho humano treinado é frequentemente superior.

### A. Histograma
Procure pelo "sino". Simetria e caudas que descem suavemente.

### B. Q-Q Plot (Quantile-Quantile Plot)
O padrão ouro visual.
*   **Eixo X:** Os quantis teóricos de uma Normal perfeita.
*   **Eixo Y:** Os quantis dos seus dados.
*   **Interpretação:** Se os pontos caírem em cima da linha vermelha de 45 graus, seus dados são Normais. Se fizerem um formato de "S" ou "Banana", não são.

---

## 2. Testes Formais de Hipótese
Eles testam a Hipótese Nula ($H_0$) de que "Os dados vêm de uma população Normal".
*   **$p > 0.05$:** Não rejeito $H_0$. (Ufa! "Parece Normal").
*   **$p < 0.05$:** Rejeito $H_0$. (Ops! "Não é Normal").

### A. Shapiro-Wilk
*   **Uso:** O mais poderoso para amostras pequenas a médias ($n < 50$ ou $n < 2000$ dependendo da implementação).
*   **Recomendação:** Use como padrão para a maioria dos casos experimentais.

### B. Kolmogorov-Smirnov (KS)
*   **Uso:** Para amostras maiores. Menos sensível nas caudas que o Shapiro.

---

## 3. O Paradoxo do Tamanho da Amostra
Aqui mora o perigo que pega 90% dos pesquisadores.

1.  **Amostras Minúsculas ($n=10$):** O teste quase nunca rejeita a normalidade (falta poder), mesmo que os dados sejam tortos. Vira um "falso salvo-conduto".
2.  **Amostras Gigantes ($n=10.000$):** O teste rejeita a normalidade por qualquer desvio milimétrico irrelevante na prática. Vira um "falso alarme".

**Conselho de Mestre (Sênior):**
*   Se $n > 30$, confie mais no **Teorema Central do Limite** (que garante que a média é normal) e no **Q-Q Plot** do que no p-valor do Shapiro. Para $N$ grande, pequenos desvios da normalidade não invalidam o Teste T.

---

## 4. Prática em Python: Check-up Completo

```python
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats

sns.set_theme(style="whitegrid")

# 1. Gerando Dados
np.random.seed(42)
# Grupo A: Normal Pura (n=30)
dados_normais = np.random.normal(loc=100, scale=15, size=30)

# Grupo B: Log-Normal (Assimétrica, parece salário) (n=30)
dados_assimetricos = np.random.lognormal(mean=3, sigma=1, size=30)

def check_normalidade(dados, nome):
    print(f"\n--- Análise de Normalidade: {nome} ---")
    
    # 1. Visual: Histograma + KDE
    fig, ax = plt.subplots(1, 2, figsize=(12, 4))
    sns.histplot(dados, kde=True, ax=ax[0], color='skyblue')
    ax[0].set_title(f'Histograma: {nome}')
    
    # 2. Visual: Q-Q Plot
    stats.probplot(dados, dist="norm", plot=ax[1])
    ax[1].set_title(f'Q-Q Plot: {nome}')
    plt.show()
    
    # 3. Teste Formal: Shapiro-Wilk
    stat, p_shapiro = stats.shapiro(dados)
    print(f"Shapiro-Wilk: p-valor = {p_shapiro:.4f}")
    
    if p_shapiro > 0.05:
        print(">> Conclusão: Não rejeitamos a hipótese de normalidade (Parece Normal).")
    else:
        print(">> Conclusão: Rejeitamos a hipótese de normalidade (NÃO é Normal).")

# Executando
check_normalidade(dados_normais, "Grupo Normal")
check_normalidade(dados_assimetricos, "Grupo Assimétrico")
```

### O Que Observar
No "Grupo Assimétrico":
1.  **Histograma:** Cauda longa à direita.
2.  **Q-Q Plot:** Os pontos fogem da linha vermelha nas pontas (formato curvado).
3.  **Shapiro:** P-valor será baixo ($<0.05$).

**Ação:** Se não for normal, você tem duas saídas:
1.  Tentar transformar os dados (Log, Raiz Quadrada).
2.  Usar testes **Não-Paramétricos** (Mann-Whitney), que veremos no Módulo 7.
