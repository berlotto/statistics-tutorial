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

# Análise de Sobrevivência: Kaplan-Meier

> **"A morte é certa, a data é incerta. A Análise de Sobrevivência lida com essa incerteza."**
>
> Em estudos clínicos, nem todo mundo morre (felizmente). Alguns desistem do estudo, outros se mudam, outros o estudo acaba e eles ainda estão vivos.
> Como calcular a "taxa de mortalidade" se metade das pessoas não morreu?
> Se você deletar quem não morreu, você enviesa o estudo (parece mais mortal do que é).
> Se você tratar quem não morreu como "imortal", você enviesa também.

---

## 1. O Conceito de Censura (Censoring)
É o coração da Análise de Sobrevivência.
*   **Dados Completos:** Paciente morreu no dia 50. (Tempo = 50, Evento = 1).
*   **Dados Censurados à Direita:** O estudo acabou no dia 100 e o paciente estava vivo.
    *   O que sabemos? Que o tempo de vida dele é **> 100**.
    *   Isso é uma informação parcial valiosa. O método Kaplan-Meier usa isso.

## 2. A Curva de Kaplan-Meier
Ela estima a probabilidade de **sobreviver além do tempo t**, $S(t)$.
*   Cada vez que alguém morre, a curva cai um degrau.
*   Quando alguém é censurado, a curva não cai, mas o "denominador" (pessoas em risco) diminui para o próximo degrau.

## 3. Teste de Log-Rank
É o "Teste T" da sobrevivência. Compara se duas curvas (Tratamento vs Controle) são estatisticamente diferentes.
*   $H_0$: As curvas são iguais.

---

## 4. Prática em Python: `lifelines`

A biblioteca padrão para isso é a `lifelines`.
`pip install lifelines`

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from lifelines import KaplanMeierFitter
from lifelines.statistics import logrank_test

# Cenário: Estudo de Câncer
# Tempo: Dias até a morte ou fim do estudo
# Evento: 1 (Morreu), 0 (Vivo/Censurado)

df = pd.DataFrame({
    'tempo':  [5, 6, 6, 2.5, 4, 4],
    'evento': [1, 0, 0, 1, 1, 1],
    'grupo':  ['A', 'A', 'A', 'B', 'B', 'B'] 
})
# Nota: Grupo A tem tempos longos e censuras (0). Grupo B morre cedo.

# 1. Ajustando e Plotando Kaplan-Meier
plt.figure(figsize=(10, 6))
kmf = KaplanMeierFitter()

# Loop para plotar cada grupo
for nome_grupo, dados in df.groupby('grupo'):
    kmf.fit(dados['tempo'], dados['evento'], label=f"Grupo {nome_grupo}")
    kmf.plot_survival_function(ci_show=True) # ci_show mostra o intervalo de confiança

plt.title("Curva de Sobrevivência Kaplan-Meier")
plt.ylabel("Probabilidade de Sobrevivência S(t)")
plt.xlabel("Tempo (dias)")
plt.grid(True, alpha=0.3)
# plt.show()

# 2. Teste Log-Rank (Comparação Formal)
grupo_A = df[df['grupo']=='A']
grupo_B = df[df['grupo']=='B']

results = logrank_test(grupo_A['tempo'], grupo_B['tempo'],
                       event_observed_A=grupo_A['evento'],
                       event_observed_B=grupo_B['evento'])

print("--- Teste de Log-Rank ---")
print(f"P-valor: {results.p_value:.4f}")

if results.p_value < 0.05:
    print(">> Rejeitamos H0: As curvas de sobrevivência são diferentes.")
    print(">> (Visualmente, o Grupo A parece viver mais).")
else:
    print(">> Sem diferença significativa.")
```

### Interpretação Visual
*   **Eixo Y (1.0 a 0.0):** Começa em 100% vivo.
*   **Cruzinhas na linha:** Indicam censuras (alguém saiu do estudo naquele momento).
*   Se a linha do Tratamento fica sempre acima da linha Controle, o tratamento protege.
