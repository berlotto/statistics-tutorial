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

# Effect Size e Significância Prática

> **"Significância Estatística é o mínimo necessário para publicar. Significância Prática é o que muda o mundo."**

Um P-valor de 0.00001 diz apenas uma coisa: *"É muito improvável que a diferença seja zero"*. Mas ele não diz se a diferença é **importante**.

---

## 1. O Problema da Amostra Gigante

Se você tiver 1 milhão de usuários, qualquer diferença minúscula (ex: cor do botão aumentou cliques em 0.01%) terá $p < 0.05$.
*   **A pergunta estatística:** É zero? Resposta: Não.
*   **A pergunta de negócio:** Vale a pena mudar a cor de todos os botões por 0.01%? Resposta: Provavelmente não.

Isso é a **Significância Prática**.

---

## 2. Effect Size (Tamanho do Efeito)

É uma medida padronizada de *quanto* os grupos diferem. O mais famoso é o **Cohen's d** (para médias).

### Regra de Bolso (Cohen):
*   $d = 0.2$: Pequeno (Difícil de ver a olho nu)
*   $d = 0.5$: Médio (Visível)
*   $d = 0.8$: Grande (Óbvio)

$$ d = \frac{\bar{x}_1 - \bar{x}_2}{s_{pooled}} $$

Onde $s_{pooled}$ é o desvio padrão combinado.

---

## 3. Prática em Python: Calculando e Reportando

Vamos simular dois cenários:
1.  **Amostra Grande, Efeito Minúsculo** (P-valor baixo, mas inútil).
2.  **Amostra Pequena, Efeito Grande** (P-valor alto, mas promissor).

```python
import numpy as np
import scipy.stats as stats

np.random.seed(42)

def cohen_d(x, y):
    nx = len(x)
    ny = len(y)
    dof = nx + ny - 2
    return (np.mean(x) - np.mean(y)) / np.sqrt(((nx-1)*np.std(x, ddof=1) ** 2 + (ny-1)*np.std(y, ddof=1) ** 2) / dof)

# Cenário 1: Big Data, Small Effect
# 10.000 usuários em cada grupo. Diferença minúscula.
grupo_A_big = np.random.normal(100, 15, 10000)
grupo_B_big = np.random.normal(100.2, 15, 10000) # Diferença de 0.2

t_stat_big, p_big = stats.ttest_ind(grupo_A_big, grupo_B_big)
d_big = cohen_d(grupo_A_big, grupo_B_big)

print("--- Cenário 1: Big Data ---")
print(f"P-valor: {p_big:.5f} (Significativo!)")
print(f"Cohen's d: {d_big:.4f} (Irrelevante, < 0.2)")

# Cenário 2: Small Data, Huge Effect
# 10 usuários. Diferença enorme.
grupo_A_small = np.random.normal(100, 15, 10)
grupo_B_small = np.random.normal(115, 15, 10) # Diferença de 15!

t_stat_small, p_small = stats.ttest_ind(grupo_A_small, grupo_B_small)
d_small = cohen_d(grupo_A_small, grupo_B_small)

print("\n--- Cenário 2: Small Data ---")
print(f"P-valor: {p_small:.5f} (Quase não significativo, depende do alfa)")
print(f"Cohen's d: {d_small:.4f} (GIGANTE, > 1.0)")
```

### Insights
*   No Cenário 1, você publicaria um artigo ("Diferença Significante!"), mas o produto seria inútil.
*   No Cenário 2, você talvez não publicasse (se $p=0.06$), mas estaria jogando fora uma descoberta incrível por falta de amostra.
*   **Conclusão:** Sempre olhe o $d$ junto com o $p$.

---

## 4. Intervalo de Confiança para o Effect Size

Assim como a média, a estimativa do *d* tem incerteza. Podemos usar Bootstrap para calcular o IC do Effect Size.

```python
# Bootstrap para IC do Cohen's d (Cenário Small)
boot_d = []
n = 10
for _ in range(5000):
    # Reamostragem
    sample_A = np.random.choice(grupo_A_small, n, replace=True)
    sample_B = np.random.choice(grupo_B_small, n, replace=True)
    boot_d.append(cohen_d(sample_A, sample_B))

ic_d = np.percentile(boot_d, [2.5, 97.5])

print(f"\nIC 95% do Cohen's d (Small): [{ic_d[0]:.2f}, {ic_d[1]:.2f}]")
```
Se o IC do Effect Size for todo positivo (ex: [0.2, 1.8]), você tem forte evidência de que o efeito é real E relevante, mesmo com n pequeno.
