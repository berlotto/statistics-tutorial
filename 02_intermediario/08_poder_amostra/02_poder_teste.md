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

# O Poder do Teste (Statistical Power)

> **"Ausência de evidência não é evidência de ausência."**
>
> Se você rodou um estudo e $p > 0.05$ (não achou diferença), existem duas opções:
> 1.  Realmente não há diferença (O remédio não funciona).
> 2.  O remédio funciona, mas sua amostra era tão pequena que você "perdeu" o sinal (Erro Tipo II).
>
> O **Poder Estatístico** é a proteção contra a opção 2.

---

## 1. A Matriz de Erros (Decisão Binária)

Em qualquer teste de hipótese, corremos riscos:

| Realidade \ Decisão | Rejeitar $H_0$ (Achei Efeito!) | Não Rejeitar $H_0$ (Nada aconteceu) |
| :--- | :--- | :--- |
| **$H_0$ é Verdadeira** (Remédio inútil) | **Erro Tipo I ($\alpha$)**<br>Falso Positivo. Padrão: 5%. | Decisão Correta<br>($1 - \alpha$) |
| **$H_0$ é Falsa** (Remédio funciona) | **Decisão Correta (Poder)**<br>($1 - \beta$). Padrão: 80%. | **Erro Tipo II ($\beta$)**<br>Falso Negativo. |

*   **Poder ($1 - \beta$):** É a probabilidade de **NÃO** cometer o Erro Tipo II. Ou seja, a probabilidade de gritar "EUREKA!" quando realmente existe algo para ser descoberto.

---

## 2. A Dança das 4 Variáveis
O Poder depende intrinsecamente de 3 fatores. Se você mexer em um, os outros reagem.

1.  **Tamanho da Amostra ($n$):** Mais dados = Mais visão = Mais Poder.
2.  **Tamanho do Efeito ($d$):** É mais fácil ver um Elefante (efeito gigante) do que uma Formiga (efeito sutil). Efeitos grandes exigem menos amostra.
3.  **Nível de Significância ($\alpha$):** Se você for super rigoroso para evitar Falsos Positivos (ex: $\alpha=0.001$), você ficará "cego" e perderá os Verdadeiros Positivos (Poder cai). É um *trade-off*.

---

## 3. Prática em Python: Curvas de Poder

Visualizar isso é a melhor forma de entender. Vamos ver como o N impacta o poder para diferentes tamanhos de efeito.

```python
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.stats.power import TTestIndPower

sns.set_theme(style="whitegrid")

# Parâmetros
analysis = TTestIndPower()
tamanhos_efeito = [0.2, 0.5, 0.8] # Pequeno, Médio, Grande
tamanhos_amostra = np.arange(5, 100) # De 5 a 100 pessoas

plt.figure(figsize=(10, 6))

analysis.plot_power(
    dep_var='nobs',
    nobs=tamanhos_amostra,
    effect_size=tamanhos_efeito,
    alpha=0.05,
    title='Curva de Poder: Quantos eu preciso?'
)

plt.axhline(y=0.8, color='red', linestyle='--', label='Poder Mínimo (80%)')
plt.legend(title='d de Cohen')
plt.ylabel('Poder (Probabilidade de Detecção)')
plt.xlabel('Tamanho da Amostra (n)')
# plt.show()
```

### Interpretação do Gráfico
*   **Linha Verde (d=0.8, Efeito Grande):** Com apenas 25 pessoas, você já cruza a linha vermelha (80% poder). É fácil provar que paraquedas funcionam.
*   **Linha Azul (d=0.2, Efeito Pequeno):** A curva sobe devagar. Mesmo com 100 pessoas, o poder ainda é baixo (< 30%). Você precisaria de milhares. É difícil provar que comer mirtilo melhora a memória em 1%.

### Análise de Poder "Post-Hoc" (Cuidado!)
Muitos revisores pedem para calcular o poder **depois** que o estudo acabou. Estatísticos modernos odeiam isso. O poder deve ser calculado **antes** (A Priori).
Se o estudo acabou e $p > 0.05$, o poder calculado será baixo por definição. Não acrescenta informação.
**Use o Poder para planejar, não para justificar fracassos.**
