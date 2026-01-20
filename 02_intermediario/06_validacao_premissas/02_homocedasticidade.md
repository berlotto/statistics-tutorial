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

# Validação de Premissas: Homocedasticidade

> **"Homo" (Igual) + "Cedasticidade" (Dispersão).**
>
> Para comparar dois grupos (ex: Homens vs Mulheres), não basta que as médias sejam comparáveis. Se a variabilidade de um grupo for explosiva e a do outro for comportada, o Teste T padrão pode falhar.

---

## 1. O Conceito
A maioria dos testes paramétricos (Teste T, ANOVA) assume que **as variâncias dos grupos são iguais** (ou pelo menos parecidas).
*   Imagine comparar a precisão de dois rifles. Se um atira sempre perto do alvo (baixa variância) e o outro espalha tiros por todo lado (alta variância), comparar apenas a "média do ponto de impacto" esconde o defeito do segundo rifle.

---

## 2. Testes Formais de Homogeneidade

### A. Teste de Levene
*   **O Padrão Ouro Moderno.**
*   É menos sensível à falta de normalidade. Funciona bem mesmo se os dados forem meio tortos.
*   Testa $H_0$: As variâncias são iguais.

### B. Teste de Bartlett
*   **Mais sensível**, mas exige que os dados sejam perfeitamente Normais.
*   Se seus dados não forem normais, o Bartlett vai rejeitar a homocedasticidade por erro, confundindo "falta de normalidade" com "falta de variância igual".

---

## 3. O que fazer se violar? (Heterocedasticidade)
Se $p < 0.05$ no Levene (Rejeitou igualdade):
1.  **No Teste T:** Use o argumento `equal_var=False` (Python `scipy`) ou "Welch's t-test". O teste de Welch corrige os graus de liberdade e funciona perfeitamente sem variâncias iguais.
2.  **Na ANOVA:** Use correções robustas (Welch ANOVA ou Brown-Forsythe).

**Dica de Sênior:** Na dúvida, muitos estatísticos modernos recomendam usar o **Teste de Welch por padrão** sempre, pois ele é robusto em ambos os casos.

---

## 4. Prática em Python: Levene e Bartlett

```python
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")

np.random.seed(42)

# Cenário: Salários em dois departamentos
# Depto A: Todo mundo ganha parecido (SD=200)
grupo_estavel = np.random.normal(loc=5000, scale=200, size=50)

# Depto B: Caos total (SD=1500)
# Média similar, mas variância absurda
grupo_caotico = np.random.normal(loc=5200, scale=1500, size=50)

# 1. Visualização (Boxplot é ótimo para ver variância)
plt.figure(figsize=(8, 5))
plt.boxplot([grupo_estavel, grupo_caotico], labels=['Estável (A)', 'Caótico (B)'])
plt.title('Comparação Visual da Dispersão')
# O Boxplot B será muito mais "comprido" que o A.

# 2. Testes Formais
# Teste de Levene (Recomendado)
stat_lev, p_lev = stats.levene(grupo_estavel, grupo_caotico)

# Teste de Bartlett (Só se normalidade for garantida)
stat_bart, p_bart = stats.bartlett(grupo_estavel, grupo_caotico)

print(f"--- Diagnóstico de Homocedasticidade ---")
print(f"Levene (p-valor):   {p_lev:.5f}")
print(f"Bartlett (p-valor): {p_bart:.5f}")

if p_lev < 0.05:
    print("\n[ALERTA] Heterocedasticidade detectada (Variâncias diferentes)!")
    print(">> AÇÃO: Ao usar Teste T, ative 'equal_var=False' (Welch's Test).")
else:
    print("\n[OK] Homocedasticidade confirmada (Variâncias iguais).")
    print(">> AÇÃO: Pode usar Teste T padrão ('equal_var=True').")
```

### Resumo do Pipeline de Validação
Antes de comparar grupos:
1.  **Cheque Normalidade** (Shapiro/Q-Q).
2.  **Cheque Homocedasticidade** (Levene).
3.  **Decida:**
    *   Passou em ambos? -> **Teste T Padrão**.
    *   Falhou Homocedasticidade? -> **Teste T de Welch**.
    *   Falhou Normalidade? -> **Mann-Whitney** (Veremos no próximo módulo).
