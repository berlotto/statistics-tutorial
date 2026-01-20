# Associação Categórica: Chi-Quadrado e Fisher

> **"Fumar causa Câncer? A Associação não prova, a biologia sim. Mas a Estatística levanta a bandeira vermelha."**
>
> Quando suas duas variáveis são **Qualitativas** (ex: Fumante/Não-Fumante vs Doente/Saudável), a correlação de Pearson não serve. Precisamos analisar Tabelas de Contingência.

---

## 1. O Teste Chi-Quadrado ($\chi^2$)
Ele compara o **Observado** ($O$) com o **Esperado** ($E$) se não houvesse nenhuma relação entre os grupos (Hipótese Nula de Independência).

$$ \chi^2 = \sum \frac{(O_i - E_i)^2}{E_i} $$

*   **Lógica:** Se Fumantes e Não-Fumantes tivessem a mesma taxa de câncer, esperaríamos ver números proporcionais em cada célula. Se observamos 50 fumantes doentes quando esperávamos 10, o $\chi^2$ explode e o p-valor cai.
*   **Requisito:** Todas as células da tabela devem ter frequência esperada > 5. Se tiver poucos dados, o teste falha.

---

## 2. Teste Exato de Fisher
Quando usar? **Quando o Chi-Quadrado falha** (amostras pequenas ou células com < 5 observações).
*   **Como funciona:** Calcula a probabilidade exata combinatória de obter aquela tabela. É computacionalmente pesado para tabelas grandes, mas perfeito para tabelas $2 \times 2$.

---

## 3. Prática em Python: Tabela de Contingência

```python
import pandas as pd
import numpy as np
import scipy.stats as stats
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="whitegrid")

# Cenário: Teste A/B de conversão num e-commerce
# Grupo Controle: Viu botão azul
# Grupo Teste: Viu botão vermelho

# Tabela de Contingência (Cross-tab)
#                 Comprou   Não Comprou
# Controle (Azul)   30         970      (Total 1000, Conv=3%)
# Teste (Vermelho)  55         945      (Total 1000, Conv=5.5%)

# Criando a tabela direto
tabela = np.array([[30, 970],
                   [55, 945]])

print("--- Tabela de Contingência Observada ---")
print(tabela)

# 1. Teste Chi-Quadrado de Independência
chi2, p, dof, expected = stats.chi2_contingency(tabela)

print(f"\n--- Chi-Quadrado ---")
print(f"Estatística: {chi2:.2f}")
print(f"P-valor: {p:.4f}")

# Validação do pressuposto (Esperado > 5)
print("\nFrequências Esperadas (se H0 fosse verdade):")
print(expected)
if np.min(expected) < 5:
    print("[ALERTA] Use Fisher! (Células com < 5 esperados)")
else:
    print("[OK] Pressuposto atendido.")

# 2. Teste Exato de Fisher (Para 2x2)
odds_ratio, p_fisher = stats.fisher_exact(tabela)

print(f"\n--- Fisher Exact Test ---")
print(f"P-valor: {p_fisher:.4f}")
print(f"Odds Ratio: {odds_ratio:.2f}")

# Interpretação
if p < 0.05:
    print("\n>> Conclusão: Existe associação significativa!")
    print(">> A cor do botão influencia a compra.")
```

### Visualizando Associação (Mosaic Plot)
Em Python, o `statsmodels` tem o `mosaic`, que é a melhor forma de ver tabelas cruzadas.

```python
from statsmodels.graphics.mosaicplot import mosaic
# mosaic(df, ['cor_botao', 'comprou'])
```

Isso encerra as ferramentas fundamentais de comparação. A partir de agora, no próximo nível, pararemos de olhar variáveis isoladas e começaremos a **Modelar o Mundo** (Regressão).
