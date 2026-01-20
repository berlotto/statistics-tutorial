# Medidas Epidemiológicas: O Idioma da Saúde

> **"Dizer que o risco 'dobrou' assusta. Dizer que aumentou de 0.1% para 0.2% acalma."**
>
> Estatística em saúde não é apenas sobre p-valores. É sobre magnitude de risco. Um p-valor < 0.001 num estudo gigante pode significar um aumento de risco irrelevante clinicamente.

---

## 1. O Básico: Prevalência vs Incidência

*   **Prevalência (Foto):** Quantos doentes existem AGORA?
    *   *Uso:* Planejamento de leitos hospitalares.
    *   *Fórmula:* Doentes / População Total.
*   **Incidência (Filme):** Quantos NOVOS casos surgiram no último ano?
    *   *Uso:* Identificar surtos ou causas.
    *   *Fórmula:* Novos Casos / Pessoas em Risco $\times$ Tempo.

> **O Paradoxo:** Um remédio que **evita a morte** mas **não cura** a doença (ex: insulina para diabetes) AUMENTA a prevalência (os doentes vivem mais, acumulando casos).

---

## 2. Estudos de Coorte $\to$ Risco Relativo (RR)
Em estudos prospectivos (acompanhamos pessoas no tempo), podemos calcular o risco real.

| | Doente | Saudável | Total |
|---|---|---|---|
| **Exposto** | $a$ | $b$ | $a+b$ |
| **Não-Exposto** | $c$ | $d$ | $c+d$ |

*   Risco no Exposto = $a / (a+b)$
*   Risco no Não-Exposto = $c / (c+d)$
*   **Risco Relativo (RR) =** RiscoExposto / RiscoNaoExposto.

**Interpretação:** "Quem fuma tem RR=5.0, ou seja, 5 vezes mais risco de câncer."

---

## 3. Estudos Caso-Controle $\to$ Odds Ratio (OR)
Em estudos retrospectivos (já começamos com os doentes), **não sabemos a incidência** (não sabemos o total de expostos na população). Só podemos calcular Odds.

*   Odds no Caso (Doente) de ter sido exposto = $a/c$
*   Odds no Controle (Saudável) de ter sido exposto = $b/d$
*   **Odds Ratio (OR) =** $(a \times d) / (b \times c)$

**Interpretação:** "Quem tem câncer tem OR=5.0, ou seja, 5 vezes mais chance (odds) de ter fumado."
*   *Nota:* Se a doença for rara (< 5%), o OR é praticamente igual ao RR.

---

## 4. O Número Necessário para Tratar (NNT)
A estatística favorita dos médicos baseados em evidência.
*   **Risco Absoluto (RA):** Diferença bruta de risco (ex: 10% no Placebo - 8% no Remédio = 2% ou 0.02).
*   **NNT = 1 / RA** = $1 / 0.02 = 50$.

**Tradução:** "Preciso tratar **50 pessoas** com esse remédio para salvar **1 vida**."
(As outras 49 tomam o remédio, pagam por ele, sofrem efeitos colaterais, e não ganham nada porque ou já sobreviveriam ou morreriam de qualquer jeito).

---

## 5. Prática em Python: Calculadora Epi 2x2

```python
import numpy as np
import statsmodels.api as sm
from statsmodels.stats.contingency_tables import Table2x2

# Cenário: Estudo de Coorte (Fumo vs Câncer)
#             Câncer    Saudável
# Fumante       40        60      (Total 100, Risco=40%)
# Não-Fumante   10        90      (Total 100, Risco=10%)

tabela = np.array([[40, 60],
                   [10, 90]])

epitable = Table2x2(tabela)

print("--- Medidas de Associação ---")
print(f"Risco Relativo (RR): {epitable.riskratio:.2f}")
print(f"Intervalo de Confiança RR: {epitable.riskratio_confint(alpha=0.05)}")
print(f"Odds Ratio (OR): {epitable.oddsratio:.2f}")

# Cáculo Manual do NNT
risco_exp = 40 / 100
risco_nao_exp = 10 / 100
reducao_risco_absoluto = risco_exp - risco_nao_exp # 0.30
nnt = 1 / reducao_risco_absoluto

print(f"\n--- Impacto Clínico ---")
print(f"Redução Absoluta de Risco: {reducao_risco_absoluto:.2%}")
print(f"NNT (Número Necessário para Prejudicar, neste caso): {nnt:.1f}")
print("Interpretação: A cada 3.3 pessoas que fumam, produzimos 1 caso extra de câncer.")
```

### Cuidado com o Risco Relativo
A indústria farmacêutica adora bradar: *"Nosso remédio reduziu o risco em 50%!!"*.
O que eles não dizem: O risco caiu de 0.0002% para 0.0001%. (Redução Absoluta insignificante).
**Sempre exija o Risco Absoluto e o NNT.**
