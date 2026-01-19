# Correlação: A Medida da Associação

> **"Correlação não implica causalidade... mas é um ótimo indício de para onde olhar."**
>
> Ver que "Venda de Sorvete" tem correlação $r=0.9$ com "Ataques de Tubarão" não significa que sorvete atrai tubarão. Significa que ambos sobem no Verão (variável de confusão).

---

## 1. O Coeficiente de Pearson ($r$)
Mede a força da **relação linear** entre duas variáveis quantitativas.
*   **Range:** $-1$ a $+1$.
*   **0:** Nenhuma associação linear.
*   **+1:** Relação positiva perfeita (se X sobe, Y sobe).
*   **-1:** Relação negativa perfeita (se X sobe, Y desce).

**Premissa:** Assume que a relação é uma reta e que os dados são Normais/Sem outliers.

---

## 2. O Coeficiente de Spearman ($\rho$)
Mede a força da **relação monotônica** (não necessariamente uma reta).
*   Baseado em **Ranks** (postos), não nos valores brutos.
*   **Quando usar:**
    *   Dados não-normais.
    *   Outliers presentes.
    *   Relações curvas (ex: Y cresce com X, mas desacelera).

---

## 3. Prática em Python: Pearson vs Spearman

```python
import numpy as np
import scipy.stats as stats
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário:
# X: Horas de Estudo
# Y: Nota na Prova (Relação forte)
x = np.linspace(0, 10, 20)
y = 2*x + 5 + np.random.normal(0, 2, 20) # y = 2x + 5 + ruído

# Adicionando um Outlier Bizarro (O Gênio que não estudou)
x = np.append(x, [0.5])
y = np.append(y, [95.0]) # Nota 95 com 0.5h de estudo

# 1. Pearson (Sensível ao Outlier)
r, p_r = stats.pearsonr(x, y)

# 2. Spearman (Robusto)
rho, p_rho = stats.spearmanr(x, y)

print(f"--- Correlação com Outlier ---")
print(f"Pearson (r):   {r:.4f} (Distorcido!)")
print(f"Spearman (rho): {rho:.4f} (Mais confiável)")

# Visualização
plt.figure(figsize=(8, 6))
sns.scatterplot(x=x, y=y, color='blue', s=100)
plt.title(f'Horas Estudo vs Nota\nPearson={r:.2f} | Spearman={rho:.2f}')
plt.xlabel('Horas')
plt.ylabel('Nota')

# Adicionando linha de tendência para ver a distorção
m, b = np.polyfit(x, y, 1)
plt.plot(x, m*x + b, color='red', linestyle='--', label='Tendência Linear (Pearson)')
plt.legend()
# plt.show()
```

### O Perigo do $R^2$ (Regressão)
O coeficiente de determinação ($R^2$) é apenas o quadrado da correlação de Pearson ($r^2$). Se Pearson mente por causa de outliers, seu $R^2$ também mentirá.

### Matriz de Correlação
Em Data Science, usamos `df.corr(method='spearman')` para gerar um **Heatmap** e ver rapidamente quem se relaciona com quem.
```python
# sns.heatmap(df.corr(), annot=True, cmap='coolwarm')
```
