# Comparando 3+ Grupos: ANOVA e Kruskal-Wallis

> **"Por que não rodar vários Testes T? Porque você vai cometer o Erro Tipo I."**
>
> Se você tem 3 grupos (A, B, C) e faz T-Test(A,B), T-Test(B,C) e T-Test(A,C), sua chance de achar um falso positivo sobe de 5% para quase 14%. A ANOVA resolve isso testando tudo de uma vez.

---

## 1. ANOVA One-Way (Análise de Variância)
Apesar do nome "Variância", ela serve para comparar **Médias**.
*   **Hipótese Nula ($H_0$):** Todas as médias são iguais ($\mu_A = \mu_B = \mu_C$).
*   **Hipótese Alternativa ($H_1$):** Pelo menos uma média é diferente das outras. (Não diz qual!).

### A Lógica F (Ratio)
A ANOVA compara:
1.  **Variância ENTRE grupos:** A diferença dos Tratamentos. (Sinal).
2.  **Variância DENTRO dos grupos:** O ruído aleatório. (Ruído).
$$ F = \frac{\text{Variância ENTRE}}{\text{Variância DENTRO}} $$
Se $F$ for grande, o Tratamento supera o ruído.

---

## 2. Testes Post-Hoc (O Detective)
Se a ANOVA deu $p < 0.05$, você sabe que *alguém* é diferente. Mas quem?
Para descobrir, usamos testes Post-Hoc que ajustam o P-valor para evitar falsos positivos (Correção de Bonferroni ou Tukey).

*   **Tukey HSD:** O melhor para todos-contra-todos se tiver homocedasticidade.
*   **Games-Howell:** Se **não** tiver variâncias iguais.

---

## 3. Kruskal-Wallis (A ANOVA Não-Paramétrica)
O primo do Mann-Whitney para 3+ grupos.
*   **Quando usar:** Dados não-normais ou ordinais (scores).
*   **Post-Hoc:** Teste de Dunn com correção de Bonferroni.

---

## 4. Prática em Python: Qual Marketing vende mais?

```python
import pandas as pd
import numpy as np
import scipy.stats as stats
import seaborn as sns
import matplotlib.pyplot as plt
from statsmodels.stats.multicomp import pairwise_tukeyhsd

sns.set_theme(style="whitegrid")
np.random.seed(99)

# Cenário: Vendas diárias em 3 estratégias de Marketing
# A: Controle (Não mudou)
# B: Influencers (Eficiente)
# C: TV (Muito Eficiente)

vendas_A = np.random.normal(100, 20, 30)
vendas_B = np.random.normal(115, 20, 30) # +15
vendas_C = np.random.normal(130, 20, 30) # +30

# Criando DataFrame longo (Tidy format)
df = pd.DataFrame({
    'vendas': np.concatenate([vendas_A, vendas_B, vendas_C]),
    'grupo': ['A']*30 + ['B']*30 + ['C']*30
})

# 1. Visualização
plt.figure(figsize=(8, 5))
sns.boxplot(x='grupo', y='vendas', data=df, palette="viridis")
plt.title('Vendas por Estratégia')
# plt.show()

# 2. ANOVA One-Way
# Premissa: Normalidade e Homocedasticidade (assumiremos OK aqui)
f_stat, p_anova = stats.f_oneway(vendas_A, vendas_B, vendas_C)

print(f"--- ANOVA One-Way ---")
print(f"F-statistic: {f_stat:.2f}")
print(f"P-valor: {p_anova:.5f}")

if p_anova < 0.05:
    print(">> Rejeitamos H0: Existe diferença entre os grupos!")
    print(">> Próximo passo: Post-Hoc para saber quem ganha de quem.")
else:
    print(">> Não houve diferença significativa.")

# 3. Post-Hoc de Tukey
# Compara par a par (A-B, A-C, B-C) ajustando o p-valor
tukey = pairwise_tukeyhsd(endog=df['vendas'], groups=df['grupo'], alpha=0.05)
print("\n--- Teste Post-Hoc de Tukey ---")
print(tukey)

# Interpretação da Tabela Tukey:
# reject=True significa que a diferença é real.
# Provavelmente A!=B, A!=C e B!=C.

# 4. Caso Não-Paramétrico: Kruskal-Wallis
stat_k, p_k = stats.kruskal(vendas_A, vendas_B, vendas_C)
print(f"\n--- Kruskal-Wallis (Se falhasse normalidade) ---")
print(f"P-valor: {p_k:.5f}")
```

### O Perigo do "P-Hacking"
Nunca rode ANOVA e depois Kruskal e escolha o que deu p-valor menor. Isso é fraude científica.
O algoritmo deve ser:
1.  Testar Premissas.
2.  Escolher o teste **antes** de ver o resultado.
3.  Reportar.
