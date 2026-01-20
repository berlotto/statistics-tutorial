# Meta-Análise: A Ciência da Síntese

> **"A ciência não avança com um único estudo. Ela avança com o consenso."**
>
> Um estudo diz que café causa câncer. Outro diz que protege. Quem tem razão?
> A Meta-Análise é a técnica estatística para **matematicamente combinar** os resultados de vários estudos independientes em uma única estimativa robusta.

---

## 1. O Segredo: A Média Ponderada
Você não pode simplesmente tirar a média dos resultados dos estudos.
*   **Estudo A:** Feito com 10 pessoas (Incerteza gigante).
*   **Estudo B:** Feito com 10.000 pessoas (Incerteza minúscula).

Se você tirar a média simples, o Estudo A (lixo) vai influenciar tanto quanto o Estudo B (ouro).
**Solução:** Peso Baseado na Variância Inversa.
$$ Peso_i = \frac{1}{Variância_i^2} $$
*   Estudos com erro grande ganham peso pequeno.
*   Estudos com erro pequeno ganham peso gigante.

---

## 2. O Forest Plot (O Gráfico da Verdade)
É como lemos uma Meta-Análise.
*   **Quadrados:** A média de cada estudo.
*   **Tamanho do Quadrado:** O peso do estudo (quanto maior, mais confiável).
*   **Linha Horizontal:** O Intervalo de Confiança (IC) daquele estudo.
*   **Diamante (Embaixo):** O resultado final combinado. A largura do diamante é a precisão final da meta-análise.
*   **Linha Vertical do "Sem Efeito":** Se o diamante cruzar essa linha, não há evidência estatística de efeito.

---

## 3. Heterogeneidade ($I^2$)
Os estudos são parecidos o suficiente para serem combinados?
*   Se um estudo foi feito com jovens atletas e outro com idosos acamados, não faz sentido misturar. Isso é alta heterogeneidade.
*   **$I^2$:** Mede o quanto da bagunça nos dados é real (diferença entre estudos) e não erro amostral.
    *   $I^2 < 25\%$: Baixa (Pode confiar).
    *   $I^2 > 75\%$: Alta (Alerta vermelho! Talvez não devesse meta-analisar).

---

## 4. O Viés de Publicação (O Efeito Gaveta)
Revistas científicas adoram publicar "Sucesso!". Elas odeiam publicar "Não funcionou".
*   Se 10 estudos provaram que o remédio não funciona, e eles foram para a gaveta...
*   ...e 1 estudo (por sorte) deu positivo e foi publicado...
*   Sua Meta-Análise vai achar que o remédio é mágico.
*   **Funnel Plot:** Um gráfico para detectar se estudos negativos estão "sumidos".

---

## 5. Prática em Python: Não há bibliotecas 'padrão' fáceis
*Nota: Python não é a primeira língua da Meta-Análise (R é rei aqui, com o pacote `metafor`). Mas podemos simular a matemática.*

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Dados Simulados de 5 Estudos (Odds Ratio e Intervalo de Confiança)
estudos = ['Estudo A', 'Estudo B', 'Estudo C', 'Estudo D', 'Estudo E']
odds_ratios = np.array([1.2, 0.9, 1.5, 1.1, 2.0]) # Efeitos estimados
n_pacientes = np.array([100, 150, 80, 200, 50])   # Tamanhos (proxy de peso)

# Erro Padrão (Simulado: inversamente proporcional à raiz do N)
se = 1 / np.sqrt(n_pacientes)

# 1. Calculando os Pesos (Inverse Variance)
pesos = 1 / (se**2)

# 2. Calculando o Efeito Combinado (Pooled Effect)
efeito_pooled = np.average(odds_ratios, weights=pesos)
print(f"Efeito Combinado (Odds Ratio): {efeito_pooled:.2f}")

# 3. Forest Plot "Na Mão"
plt.figure(figsize=(8, 5))

# Plotando linhas de cada estudo
for i, estudo in enumerate(estudos):
    ci_low = odds_ratios[i] - 1.96*se[i]
    ci_high = odds_ratios[i] + 1.96*se[i]
    
    # Linha do IC
    plt.plot([ci_low, ci_high], [i, i], color='black')
    
    # Quadrado (Tamanho proporcional ao peso)
    tamanho = pesos[i] / np.max(pesos) * 100
    plt.scatter(odds_ratios[i], i, s=tamanho, marker='s', color='blue')

# Plotando o Diamante (Resultado Final)
plt.axvline(x=1.0, color='gray', linestyle='--') # Linha de nulidade
plt.scatter(efeito_pooled, -1, s=200, marker='D', color='red', label='Meta-Análise')

plt.yticks(list(range(len(estudos))) + [-1], estudos + ['COMBINADO'])
plt.xlabel('Odds Ratio (log scale)')
plt.title('Forest Plot Simplificado (Python)')
plt.grid(axis='x', alpha=0.3)
# plt.show()
```

### Por que o Diamante Vermelho importa?
Repare no gráfico gerado. Alguns estudos podem cruzar a linha cinza (sem efeito), outros não. Mas o **Diamante** geralmente tem um intervalo muito mais estreito (preciso). É o poder da multidão estatística.
