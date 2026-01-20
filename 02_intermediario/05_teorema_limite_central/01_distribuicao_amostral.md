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

# Teorema Central do Limite (TLC) e Distribuição Amostral

> **"A Normalidade não é a regra na natureza, é a exceção. Mas a mágica é que a MÉDIA de qualquer coisa tende a ser Normal."**
>
> Você provavelmente já ouviu: *"Para usar estatística, os dados precisam ser normais"*.
> **Isso é uma meia-verdade.** Os dados brutos não precisam ser normais. A **distribuição das médias** amostrais é que será normal, graças ao TLC. E é isso que nos permite fazer inferências.

---

## 1. A Intuição da Distribuição Amostral
Imagine que você queira saber a altura média de **todos** os brasileiros (200 milhões). Impossível medir todos.
1.  Você pega uma amostra de 100 pessoas e calcula a média: `1.72m`.
2.  Seu colega pega outra amostra aleatória de 100 pessoas e acha: `1.69m`.
3.  Outro colega acha: `1.75m`.

Os valores brutos (altura das pessoas) podem ter qualquer formato. Mas se plotarmos essas **Médias das Amostras**, elas formarão um sino perfeito (Normal).

## 2. O Teorema Central do Limite (TLC)
O TLC afirma que, para uma amostra suficientemente grande ($n \geq 30$ é a regra de bolso, mas depende):
1.  A distribuição das médias amostrais ($\bar{X}$) será aproximadamente **Normal**.
2.  A média dessas médias será igual à média verdadeira da população ($\mu$).
3.  O desvio padrão dessas médias diminuirá conforme $n$ aumenta. Esse "desvio das médias" tem um nome especial: **Erro Padrão**.

---

## 3. Erro Padrão da Média (SEM - Standard Error of the Mean)
Não confunda com Desvio Padrão (SD)!
*   **Desvio Padrão ($SD$):** Mede o quanto *indivíduos* variam da média. (Dispersão biológica/natural).
*   **Erro Padrão ($SEM$):** Mede o quanto a *média da amostra* varia da média real. (Precisão da nossa estimativa).

$$ SEM = \frac{SD}{\sqrt{n}} $$

**Interpretação:**
*   Para reduzir o $SD$ (variabilidade natural), você não pode fazer nada (altura das pessoas varia mesmo).
*   Para reduzir o $SEM$ (sua incerteza), você pode **aumentar o n**. Note que é uma raiz quadrada: para reduzir o erro pela metade, você precisa quadruplicar a amostra.

---

## 4. Prática em Python: A Prova Visual

Vamos criar uma distribuição **Bizarra** (totalmente não-normal) e provar que suas médias viram uma Normal.

```python
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

sns.set_theme(style="whitegrid")

# 1. População "Bizarra" (Exponencial - altamente assimétrica)
# Imagine tempo de espera em fila: muitos zeros, poucos muito longos.
np.random.seed(42)
populacao = np.random.exponential(scale=10, size=100000)

media_pop = np.mean(populacao)
sd_pop = np.std(populacao)

print(f"População Real -> Média: {media_pop:.2f}, SD: {sd_pop:.2f}")

# 2. Simulando o TLC
tamanhos_amostra = [5, 30, 100]
fig, ax = plt.subplots(1, 4, figsize=(20, 5))

# Plot 0: A População Original (Não é Normal!)
sns.histplot(populacao, bins=50, color='gray', ax=ax[0])
ax[0].set_title("População Original (Exponencial)")

# Plots 1, 2, 3: Distribuição das MÉDIAS de 1000 amostras
for i, n in enumerate(tamanhos_amostra):
    medias_amostrais = []
    # Coletamos 1000 amostras de tamanho n
    for _ in range(1000):
        amostra = np.random.choice(populacao, size=n)
        medias_amostrais.append(np.mean(amostra))
    
    # Plotando
    sns.histplot(medias_amostrais, kde=True, ax=ax[i+1], color='skyblue')
    
    # Calculando SEM teórico e empírico
    sem_teorico = sd_pop / np.sqrt(n)
    sem_empirico = np.std(medias_amostrais)
    
    # Teste de Normalidade (Shapiro-Wilk)
    # Se p > 0.05, não rejeitamos a normalidade (é normal)
    _, p_shapiro = stats.shapiro(medias_amostrais)
    status = "Normal" if p_shapiro > 0.05 else "Não-Normal"
    
    ax[i+1].set_title(f"n={n} ({status})\nShapiro p={p_shapiro:.3f}")

plt.tight_layout()
# plt.show()
```

### O Que Você Deve Ver
1.  **Gráfico 1 (População):** Uma curva despencando (exponencial). Nada de sino.
2.  **Gráfico 2 (n=5):** Começa a subir um morrinho, mas ainda torto.
3.  **Gráfico 4 (n=100):** Um sino perfeito (Normal).

**Conclusão Master:** Graças ao TLC, podemos usar testes paramétricos (Teste T, ANOVA) que assumem normalidade da média, mesmo se os dados originais não forem perfeitamente normais, **desde que o N seja razoável**.
