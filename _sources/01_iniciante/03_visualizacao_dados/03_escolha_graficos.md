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

# A Arte de Escolher o Gráfico Correto

> **"O objetivo da visualização é o insight, não as figuras."** — Ben Shneiderman

Um erro comum é escolher o gráfico "mais bonito" em vez do mais claro. A escolha do gráfico depende exclusivamente de duas coisas:
1.  **O Tipo de Dados** que você tem.
2.  **A Pergunta** que você quer responder.

---

## 1. Matriz de Decisão

Como pesquisador, use esta tabela mental antes de abrir o Python/R:

| Pergunta Principal | Tipo de Dados Envolvidos | Gráfico Recomendado | O que ele mostra? |
| :--- | :--- | :--- | :--- |
| **Como é a distribuição?** | 1 Variável Numérica | **Histograma** ou **Densidade (KDE)** | Forma, simetria, bimodalidade. |
| **Comparar distribuições?** | 1 Numérica + 1 Categórica | **Box Plot** ou **Violin Plot** | Onde está o centro, a dispersão e os outliers em cada grupo. |
| **Há relação entre variáveis?** | 2 Variáveis Numéricas | **Scatter Plot** (Dispersão) | Correlação (positiva/negativa), linearidade, clusters. |
| **Como evolui no tempo?** | Tempo + 1 Numérica | **Line Chart** (Linha) | Tendência, sazonalidade, quebras estruturais. |
| **Composição (Partes do todo)?** | 1 Categórica | **Bar Chart** (Barras) | Comparação de magnitudes. (Evite Pizza se > 3 categorias). |
| **Quantidades por categoria?** | 1 Categórica + Contagem | **Bar Chart** | Frequência de cada categoria. |

---

## 2. Exemplos Práticos

### 2.1 Histograma vs Boxplot
*   Use **Histograma** quando quiser ver detalhes da forma (ex: é bimodal? tem duas corcovas de usuários?).
*   Use **Boxplot** quando quiser comparar *muitos* grupos lado a lado (ex: Salário por Departamento). 30 histogramas seriam ilegíveis; 30 boxplots funcionam bem.

### 2.2 Barras vs Pizza (O ódio à Pizza)
O ser humano é péssimo em comparar áreas e ângulos (Pizza), mas ótimo em comparar comprimentos (Barras).
*   **Regra de Ouro:** Só use Pizza se tiver 2 ou 3 categorias com diferenças óbvias (ex: 50% vs 50%).
*   Para todo o resto, use **Gráfico de Barras**.

### 2.3 Scatter Plot: O Detector de Padrões
O gráfico de dispersão é o pai do Machine Learning. Antes de rodar uma Regressão Linear, olhe o Scatter.
*   Os pontos formam uma linha? (Linear)
*   Formam uma banana/curva? (Não-linear)
*   Tem nuvens separadas? (Clusters)

---

## 3. Prática: O Mesmo Dado, Histórias Diferentes

Vamos pegar dados de gorjetas (`tips`) e ver como gráficos diferentes respondem perguntas diferentes.

```python
import seaborn as sns
import matplotlib.pyplot as plt

# Dados clássicos de gorjetas em restaurante
tips = sns.load_dataset('tips')

# Configuração estética
sns.set_theme(style="whitegrid")
plt.figure(figsize=(12, 10))

# 1. Pergunta: "Qual o valor mais comum de conta?"
# Resposta: Histograma
plt.subplot(2, 2, 1)
sns.histplot(tips['total_bill'], kde=True, color='skyblue')
plt.title('Distribuição do Valor da Conta (Histograma)')

# 2. Pergunta: "Quem gasta mais: Fumantes ou Não Fumantes?"
# Resposta: Boxplot
plt.subplot(2, 2, 2)
sns.boxplot(x='smoker', y='total_bill', data=tips, palette='Set2')
plt.title('Conta por Status de Fumante (Boxplot)')

# 3. Pergunta: "Gorjeta aumenta com a conta?"
# Resposta: Scatter Plot
plt.subplot(2, 2, 3)
sns.scatterplot(x='total_bill', y='tip', data=tips, hue='time', alpha=0.7)
plt.title('Relação Conta vs Gorjeta (Scatter)')

# 4. Pergunta: "Qual dia da semana é mais movimentado?"
# Resposta: Countplot (Gráfico de Barras de contagem)
plt.subplot(2, 2, 4)
sns.countplot(x='day', data=tips, palette='viridis')
plt.title('Frequência de Clientes por Dia (Barras)')

plt.tight_layout()
plt.show()
```

### Insights Deste Dashboard
1.  **Histograma:** A maioria das contas é baixa (~$15), com cauda longa à direita (assimetria positiva).
2.  **Boxplot:** A mediana de fumantes e não fumantes é similar, mas fumantes têm maior variabilidade (cauda maior).
3.  **Scatter:** Relação positiva clara. Contas maiores geram gorjetas maiores.
4.  **Barras:** Sábado e Domingo são os dias de pico.

Escolher o gráfico certo é 80% do trabalho de comunicação.
