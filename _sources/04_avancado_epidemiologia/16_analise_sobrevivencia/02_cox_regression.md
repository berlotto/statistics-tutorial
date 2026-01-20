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

# Regressão de Cox: Sobrevivência Multivariada

> **"Kaplan-Meier é ótimo para comparar 2 curvas. Mas e se eu quiser ajustar por Idade, Peso e Sexo ao mesmo tempo?"**
>
> Assim como o Teste T evoluiu para ANOVA e Regressão Linear, o Log-Rank evolui para a Regressão de Cox.

---

## 1. O Modelo de Riscos Proporcionais (Cox PH)
Ele modela o "Risco Instantâneo" (Hazard) de morrer no tempo $t$.
$$ h(t) = h_0(t) \cdot e^{(\beta_1 X_1 + \beta_2 X_2 + ...)} $$
*   **h_0(t):** Risco basal (Baseline). O Cox não se importa com a forma dessa curva (por isso é semi-paramétrico).
*   **e^(...):** A parte paramétrica que multiplica o risco.

## 2. O Hazard Ratio (HR)
É a "Odds Ratio" do tempo.
*   **HR = 1.0:** Sem efeito.
*   **HR = 2.0:** O grupo tem **o dobro do risco** de morrer a qualquer momento comparado ao basal. (Morre mais rápido).
*   **HR = 0.5:** O grupo tem **metade do risco**. (Fator de proteção).

## 3. A Premissa dos Riscos Proporcionais
O modelo assume que o HR é constante no tempo.
*   Se o remédio protege no início, mas mata no final, as curvas se cruzam. O Cox falha aqui (viola a premissa).

---

## 4. Prática em Python: `lifelines` avançado

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from lifelines import CoxPHFitter, KaplanMeierFitter

# Dados Simulados: Prisão (Tempo até reincidência criminal)
# 'fin': Se recebeu ajuda financeira (1) ou não (0)
# 'age': Idade
# 'wexp': Experiência de trabalho prévia
from lifelines.datasets import load_rossi
df = load_rossi()

print(df.head())
# week (tempo), arrest (evento 1=preso), fin, age, prio (prisões anteriores)

# 1. Ajustando o Modelo de Cox
cph = CoxPHFitter()
cph.fit(df, duration_col='week', event_col='arrest')

# 2. Resumo dos Resultados
cph.print_summary()

# Interpretação da Saída (Olhar coluna exp(coef) = HR):
# Variável 'fin' (Ajuda Financeira):
# HR (exp(coef)) ≈ 0.68
# Isso significa que quem recebe ajuda tem 32% MENOS risco de ser preso novamente (1 - 0.68).
# P-valor < 0.05? Sim.

# Variável 'prio' (Prisões Anteriores):
# HR ≈ 1.09
# Cada prisão anterior aumenta o risco de reincidência em 9%.

# 3. Visualizando o Efeito das Variáveis
cph.plot() # Plota os intervalos de confiança dos HRs
plt.title("Hazard Ratios (Riscos)")
# plt.show()

# 4. Checando a Premissa (Proportional Hazards Assumption)
print("\n--- Checando Premissas ---")
cph.check_assumptions(df, show_plots=True)
# Se der erro ou p-valor baixo nos testes de premissa, o modelo é inválido.
# Solução: Estratificar o modelo ou usar modelos AFT (Accelerated Failure Time).
```

### Cox vs AFT
O Cox mede "Risco" (velocidade do evento). Modelos AFT (Weibull) medem "Tempo Restante" (expectativa de vida). Em epidemiologia, Cox domina. Em engenharia (falha de máquinas), Weibull domina.
