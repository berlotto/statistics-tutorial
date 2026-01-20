# Multivariada Não-Supervisionada: PCA e Clustering

> **"Quando você não tem o Y (Label), só lhe resta explorar a estrutura do X."**
>
> Até agora, tinhamos um alvo (prever Doença, prever Salário). Na aprendizagem não-supervisionada, temos apenas dados brutos e queremos achar **padrões escondidos**.

---

## 1. PCA (Principal Component Analysis)
Imagine que você tem 50 variáveis num banco de dados médico (Colesterol, Triglicerídeos, HDL, LDL, Peso, IMC...). Muitas delas dizem a mesma coisa (são correlacionadas).
O PCA "espreme" essas 50 variáveis em, digamos, 2 ou 3 "Super-Variáveis" (Componentes Principais) que resumem a informação.

### A Mágica por Baixo do Capô (Autovetores)
1.  O PCA procura a **direção** no espaço multidimensional onde os dados têm a MAIOR variância (onde eles mais se espalham). Roda um eixo ali. Esse é o **PC1**.
2.  Depois, ele procura uma segunda direção, **ortogonal** (90 graus) à primeira, que explique o que sobrou da variância. Esse é o **PC2**.
3.  Ele repete isso.
*   **Resultado:** O PC1 e PC2 capturam, digamos, 80% da informação de todo o dataset. Agora você pode plotar um gráfico 2D de um problema que era 50D.

---

## 2. Clustering (K-Means)
O objetivo é agrupar indivíduos similares.
*   **A lógica:**
    1.  Escolha $K$ centroides aleatórios.
    2.  Atribua cada ponto ao centroide mais próximo.
    3.  Mova o centroide para o "centro de gravidade" dos pontos atribuídos a ele.
    4.  Repita até estabilizar.
*   **Desafio:** Escolher o $K$ ideal (Método do Cotovelo/Elbow).

---

## 3. Prática em Python: Reduzindo e Agrupando Vinhos

Vamos usar o clássico dataset de Vinhos. Tem 13 características químicas. Vamos ver se conseguimos separar os tipos de vinho sem saber o rótulo.

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_wine
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans

sns.set_theme(style="whitegrid")

# 1. Carregando Dados
data = load_wine()
df = pd.DataFrame(data.data, columns=data.feature_names)
# Variáveis: Alcohol, Malic acid, Magnesium, etc... (13 variáveis)

# 2. Padronização (CRUCIAL para PCA e K-Means)
# Se uma variável é "Peso" (kg) e outra "Salário" (milhares), o Salário domina o PCA.
# Temos que colocar tudo na mesma régua (Z-Score).
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df)

# 3. PCA: Reduzindo 13 dimensões para 2
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

# Quanto explicamos?
print(f"Variância Explicada por PC1: {pca.explained_variance_ratio_[0]:.2%}")
print(f"Variância Explicada por PC2: {pca.explained_variance_ratio_[1]:.2%}")
print(f"Total: {sum(pca.explained_variance_ratio_):.2%} da informação original preservada em 2D.")

# 4. K-Means: Tentando achar 3 grupos
kmeans = KMeans(n_clusters=3, random_state=42)
grupos = kmeans.fit_predict(X_scaled)

# 5. Visualização
# Plotamos PC1 vs PC2, colorindo pelo Cluster encontrado
plt.figure(figsize=(10, 6))
sns.scatterplot(x=X_pca[:, 0], y=X_pca[:, 1], hue=grupos, palette='viridis', s=100)

plt.title('Mapa de Vinhos (PCA + K-Means)')
plt.xlabel(f'PC1 (Sabor/Química Principal) - Explica {pca.explained_variance_ratio_[0]:.0%}')
plt.ylabel(f'PC2 (Sabor Secundário) - Explica {pca.explained_variance_ratio_[1]:.0%}')
plt.legend(title='Cluster Automatico')

# Validando com a verdade (só porque temos o gabarito)
# Na prática real, você não teria 'data.target'.
# plt.show()

# O que significa o PC1? (Loadings)
loadings = pd.DataFrame(pca.components_.T, columns=['PC1', 'PC2'], index=data.feature_names)
print("\n--- O que compõe o PC1? (Top 3 variáveis) ---")
print(loadings['PC1'].abs().sort_values(ascending=False).head(3))
# Se 'Flavanoids' e 'Phenols' forem altos, o PC1 representa "Riqueza de sabor".
```

### O Poder da Interpretação
O gráfico do PCA mostra "ilhas" de pontos.
*   Se os clusters (cores) estiverem bem separados, significa que os vinhos são quimicamente distintos.
*   Se estiverem misturados, eles são parecidos.
*   Você acabou de criar um mapa 2D de um universo de 13 dimensões!
