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

# Avaliando Classificadores: Acurácia não é tudo

> **"Dizer que um modelo tem 99% de acurácia na detecção de fraudes é inútil se 99% das transações são legítimas."**
>
> A performance de um modelo de classificação (Logística, Árvore, etc.) depende do balanço das classes e do custo do erro.

---

## 1. A Matriz de Confusão
O mapa da verdade. Cruza o **Predito** com o **Real**.

| | Predito Negativo (0) | Predito Positivo (1) |
|---|---|---|
| **Real Negativo (0)** | True Negative (TN) | False Positive (FP) - *Erro Tipo I* |
| **Real Positivo (1)** | False Negative (FN) - *Erro Tipo II* | True Positive (TP) |

### Métricas Derivadas
1.  **Acurácia:** $(TP+TN)/Total$. Só serve se as classes forem balanceadas (50/50).
2.  **Precisão (Precision):** Dos que chamei de Positivo, quantos realmente eram? (Evita alarme falso).
3.  **Sensibilidade (Recall):** Dos que realmente eram Positivos, quantos eu achei? (Evita perder casos).
4.  **Especificidade:** Dos que realmente eram Negativos, quantos eu acertei?

---

## 2. O Trade-off (Precisão vs Recall)
Não dá para ter tudo.
*   Se você quer achar **todos** os ladrões (Alta Sensibilidade), vai prender alguns inocentes (Baixa Precisão).
*   Se você quer prender **só** quem tem certeza absoluta (Alta Precisão), vai deixar alguns ladrões escaparem (Baixa Sensibilidade).

### F1-Score
A média harmônica entre Precisão e Recall. Uma métrica única de equilíbrio.

---

## 3. Curva ROC e AUC
A Regressão Logística cospe uma probabilidade (0.1, 0.7, 0.9). Mas para decidir (0 ou 1), precisamos de um **Limiar (Threshold)** (padrão 0.5).
E se mudarmos esse limiar?
*   **Curva ROC:** Plota a Sensibilidade vs (1 - Especificidade) para **todos** os limiares possíveis.
*   **AUC (Area Under Curve):** A área sob essa curva.
    *   0.5: Modelo aleatório (Moeda).
    *   1.0: Modelo perfeito.
    *   0.7-0.8: Bom.

---

## 4. Prática em Python: Scikit-learn Metrics

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix, classification_report, roc_curve, roc_auc_score

sns.set_theme(style="whitegrid")
np.random.seed(42)

# 1. Dados Desbalanceados (Fraude)
# 95% Legítimo (0), 5% Fraude (1)
n = 1000
X = np.random.normal(0, 1, (n, 2))
y = np.random.binomial(1, 0.05, n) # Apenas 5% de 1s

# Adicionando sinal: Fraudes têm valores um pouco maiores em X[0]
X[y==1, 0] += 2.0

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)

# 2. Treino
modelo = LogisticRegression()
modelo.fit(X_train, y_train)

# Predições
y_pred = modelo.predict(X_test) # Classe (0 ou 1) usando limiar 0.5
y_prob = modelo.predict_proba(X_test)[:, 1] # Probabilidade Real

# 3. Avaliação Simples (CUIDADO com Acurácia)
print("--- Classificação Padrão (Threshold 0.5) ---")
print(classification_report(y_test, y_pred))
# Note: Acurácia pode ser alta (0.95), mas Recall do 1 pode ser baixo!

# 4. Matriz de Confusão Visual
cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(5, 4))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.title('Matriz de Confusão')
plt.xlabel('Predito')
plt.ylabel('Real')
# plt.show()

# 5. Curva ROC e AUC
fpr, tpr, thresholds = roc_curve(y_test, y_prob)
auc = roc_auc_score(y_test, y_prob)

plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, label=f'Logística (AUC = {auc:.2f})')
plt.plot([0, 1], [0, 1], 'r--', label='Aleatório (0.5)')
plt.title('Curva ROC')
plt.xlabel('1 - Especificidade (Falso Positivo)')
plt.ylabel('Sensibilidade (Verdadeiro Positivo)')
plt.legend()
plt.grid(True)
# plt.show()

# 6. Ajuste de Limiar (Tuning)
# Se fraude é grave, quero pegar mais. Baixo o limiar para 0.2.
print("\n--- Classificação Ajustada (Threshold 0.2) ---")
y_pred_ajustado = (y_prob >= 0.2).astype(int)
print(classification_report(y_test, y_pred_ajustado))
# Resultado: O Recall do 1 deve subir, mas a precisão cairá.
```

### Mensagem Final
Em medicina e fraude: **Otimize o Recall** (melhor investigar falso alarme do que deixar morrer).
Em spam e recomendação youtube: **Otimize a Precisão** (melhor deixar passar um spam do que jogar email importante no lixo).
Ajuste o limiar conforme o negócio!
