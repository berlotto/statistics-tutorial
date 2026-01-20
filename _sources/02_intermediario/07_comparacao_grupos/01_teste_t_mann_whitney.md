# Comparação de 2 Grupos: Teste T e Seus Amigos

> **"A diferença entre o remédio e o veneno é a dose... e o P-valor."**
>
> Você tem dois grupos (Tratamento vs Controle, Antes vs Depois). A média de um é 50, do outro é 55. Essa diferença é real ou obra do acaso?

---

## 1. O Fluxograma de Decisão
Antes de rodar código, faça o checklist mental:
1.  **Os grupos são independentes?** (Pessoas diferentes) ou **Pareados** (Mesma pessoa antes/depois)?
2.  **Os dados são Normais?** (Ver Módulo 6).
3.  **As variâncias são iguais?** (Ver Módulo 6).

| Cenário | Normal (Paramétrico) | Não-Normal (Não-Paramétrico) |
| :--- | :--- | :--- |
| **Independentes** | Teste T de Student | Mann-Whitney U |
| **Pareados** | Teste T Pareado | Wilcoxon Signed-Rank |

---

## 2. Teste T (Paramétrico)
Testa se a diferença das médias é estatisticamente diferente de zero.
*   **Premissas:** Normalidade + Homocedasticidade (se não tiver homocedasticidade, use Welch).
*   **Interpretação:** $p < 0.05$ indica que a diferença é improvável de ocorrer ao acaso.

## 3. Mann-Whitney U (Não-Paramétrico)
Não compara médias! Compara **postos (ranks)**. É como dizer: *"Se eu pegar uma pessoa aleatória do Grupo A e uma do Grupo B, qual a chance de A > B?"*
*   **Vantagem:** Funciona com dados assimétricos, escalas ordinais e outliers.
*   **Poder Estatístico:** Surpreendentemente alto (95% da eficiência do Teste T, mesmo se os dados forem normais). Na dúvida, é uma escolha segura.

---

## 4. Além do P-valor: Tamanho de Efeito (d de Cohen)
Um estudo com 1 milhão de pessoas pode achar um P-valor < 0.0001 para uma diferença de média de 0.01kg (irrelevante).
O **d de Cohen** mede a magnitude da diferença em desvios padrões.
*   0.2: Pequeno
*   0.5: Médio
*   0.8: Grande

---

## 5. Prática em Python: O Confronto

```python
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Eficácia de Dieta (Perda de Peso em kg)
# Grupo A: Dieta Nova (n=20) - Ligeiramente melhor
grupo_A = np.random.normal(loc=5.0, scale=1.5, size=20)

# Grupo B: Placebo (n=20) - Média menor
grupo_B = np.random.normal(loc=3.5, scale=1.5, size=20)

# 1. Visualização
plt.figure(figsize=(6, 4))
sns.boxplot(data=[grupo_A, grupo_B], palette=["skyblue", "salmon"])
plt.xticks([0, 1], ['Dieta (A)', 'Placebo (B)'])
plt.title('Perda de Peso por Grupo')
# plt.show()

# 2. Teste T Independente
# Assumindo variâncias iguais (se dúvida, use equal_var=False)
stat_t, p_t = stats.ttest_ind(grupo_A, grupo_B)

print(f"--- Teste T (Paramétrico) ---")
print(f"Média A: {np.mean(grupo_A):.2f} | Média B: {np.mean(grupo_B):.2f}")
print(f"P-valor: {p_t:.4f}")

if p_t < 0.05:
    print(">> Rejeitamos H0: A Dieta funciona!")
else:
    print(">> Não rejeitamos H0: Sem evidência de diferença.")

# 3. Teste de Mann-Whitney (Plano B seguro)
stat_u, p_u = stats.mannwhitneyu(grupo_A, grupo_B, alternative='two-sided')

print(f"\n--- Mann-Whitney U (Não-Paramétrico) ---")
print(f"P-valor: {p_u:.4f}")

# 4. Tamanho de Efeito (d de Cohen)
# d = (Mean1 - Mean2) / SD_pooled
n1, n2 = len(grupo_A), len(grupo_B)
s1, s2 = np.std(grupo_A, ddof=1), np.std(grupo_B, ddof=1)
s_pooled = np.sqrt(((n1-1)*s1**2 + (n2-1)*s2**2) / (n1+n2-2))
d_cohen = (np.mean(grupo_A) - np.mean(grupo_B)) / s_pooled

print(f"\n--- Tamanho do Efeito ---")
print(f"d de Cohen: {d_cohen:.2f}")
if abs(d_cohen) > 0.8:
    print("(Efeito Grande: A diferença é clinicamente notável)")
elif abs(d_cohen) > 0.5:
    print("(Efeito Médio)")
else:
    print("(Efeito Pequeno)")
```

### Amostras Pareadas?
Se fosse um estudo "Antes vs Depois" nas **mesmas pessoas**, o código mudaria:
*   `stats.ttest_rel(antes, depois)`
*   `stats.wilcoxon(antes, depois)`

A análise pareada é muito mais poderosa pois remove a variabilidade biológica entre indivíduos (cada um é seu próprio controle).
