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

# DAGs e Inferência Causal

> **"Correlação não é causalidade, mas é uma dica muito boa."** — Edward Tufte (Meia verdade)

Dados observacionais são cheios de armadilhas.
*   Quem toma vinho tem mais saúde. (Causa: Vinho? Ou Renda?)
*   Quem usa o remédio morre mais. (Causa: Remédio? Ou quem toma já estava mais grave?)

A Inferência Causal nos dá ferramentas para sair da correlação e chegar na causa.

---

## 1. DAGs (Digramas Acíclicos Dirigidos)

Antes de rodar código, desenhe sua hipótese.

*   **Confundimento (Confounder):** Uma variável Z que causa X e Y.
    *   Ex: Calor (Z) -> Vendas de Sorvete (X) e Crimes (Y).
    *   Se não controlar Z, parece que Sorvete causa Crime.
*   **Colisor (Collider):** Uma variável Z que é causada por X e Y.
    *   Ex: Beleza (X) e Talento (Y) -> Sucesso (Z).
    *   Se você filtrar só "Atores de Sucesso" (controlar Z), cria uma correlação negativa falsa entre Beleza e Talento.

**Regra de Ouro (Backdoor Criterion):** Você deve controlar (incluir na regressão) os Confundidores, mas **NUNCA** os Colisores.

---

## 2. Propensity Score Matching (PSM)

Quando não podemos fazer um teste A/B randômico (ética ou custo), usamos dados observacionais. O problema: o grupo Tratamento é diferente do Controle (viés de seleção).

O PSM tenta "criar" um experimento artificial pareando gêmeos estatísticos.

### O Algoritmo
1.  Calcule a probabilidade de cada pessoa receber o tratamento (Propensity Score) usando Regressão Logística baseada em suas características (idade, renda, gravidade).
2.  Encontre para cada pessoa tratada, uma pessoa não-tratada com score "gêmeo".
3.  Compare os desfechos apenas desses pares.

---

## 3. Prática em Python: PSM Simplificado

Vamos simular um tratamento que **não funciona**, mas parece funcionar porque foi dado para pacientes mais jovens.

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import NearestNeighbors

np.random.seed(42)
n = 1000

# 1. Gerar Dados Confounding
idade = np.random.normal(50, 10, n)

# Tratamento é dado mais para jovens (Viés!)
# Probabilidade baseada na idade (quanto mais jovem, mais provável)
prob_trat = 1 / (1 + np.exp(-(4 - 0.1 * idade)))
tratamento = np.random.binomial(1, prob_trat)

# Desfecho (Saúde): Jovens têm mais saúde. O Tratamento NÃO faz nada (efeito 0).
saude = 100 - (1 * idade) + (0 * tratamento) + np.random.normal(0, 5, n)

df = pd.DataFrame({'idade': idade, 'tratamento': tratamento, 'saude': saude})

# Análise Naive (Ingênua)
naive_diff = df[df['tratamento']==1]['saude'].mean() - df[df['tratamento']==0]['saude'].mean()
print(f"Diferença Naive: {naive_diff:.2f} (Parece que o tratamento melhora a saúde!)")

# 2. Calcular Propensity Score
# P(Tratamento | Idade)
log_reg = LogisticRegression()
log_reg.fit(df[['idade']], df['tratamento'])
df['propensity_score'] = log_reg.predict_proba(df[['idade']])[:, 1]

# 3. Matching (Vizinho mais próximo)
treatment_group = df[df['tratamento'] == 1]
control_group = df[df['tratamento'] == 0]

nbrs = NearestNeighbors(n_neighbors=1).fit(control_group[['propensity_score']])
distances, indices = nbrs.kneighbors(treatment_group[['propensity_score']])

# Pegar os controles pareados
matched_controls = control_group.iloc[indices.flatten()]

# 4. Comparar Pares (ATE - Average Treatment Effect on Treated)
diff_matched = treatment_group['saude'].values - matched_controls['saude'].values
ate = np.mean(diff_matched)

print(f"Diferença Após Matching (PSM): {ate:.2f} (Próximo de zero, que é a verdade!)")

# Visualização de Diagnóstico
plt.figure(figsize=(10, 5))
sns.kdeplot(df[df['tratamento']==1]['propensity_score'], label='Tratado', fill=True)
sns.kdeplot(df[df['tratamento']==0]['propensity_score'], label='Controle', fill=True)
plt.title("Overlap de Propensity Scores (Precisa haver sobreposição!)")
plt.legend()
# plt.show()
```

### Interpretação
O PSM removeu o viés da idade. Mostrou que a diferença de saúde era explicada pela juventude, não pelo remédio.
