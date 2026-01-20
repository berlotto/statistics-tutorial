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

# Intervalos de Confiança (IC): A Margem de Erro Científica

> **"Não existe certeza na ciência, apenas graus de probabilidade."**
>
> Dizer que a média é 100 é ingênuo. Dizer que a média está entre 95 e 105 com 95% de confiança é profissional.

---

## 1. O que ALMEJA ser um IC?
O Intervalo de Confiança (IC) é a região onde, muito provavelmente, o verdadeiro parâmetro da população ($\mu$) está escondido.
Calculado como:
$$ IC = Estimativa \pm (Fator \times ErroPadrão) $$

### 1.1 A Interpretação Correta (E difícil)
Se você calcular um IC de 95% = [48, 52], o que isso significa?
*   **Errado:** "Existe 95% de chance da média real ser 50." (A média real é uma constante fixa, ela está lá ou não, não existe sorteio sobre ela na visão frequentista).
*   **Correto:** "Se repetíssemos este estudo 100 vezes, calculando novos ICs a cada vez, 95 desses intervalos conteriam a verdadeira média."
*   **Correto (Pragmático):** "Temos alta confiança de que o valor real está aqui dentro, compatível com nossos dados."

---

## 2. Tipos de IC

### A. Paramétrico (Normal/T)
Usa a fórmula clássica. Assume-se que a média segue a distribuição Normal (graças ao TLC).
$$ IC_{95\%} = \bar{x} \pm 1.96 \times SEM $$
*   O valor $1.96$ vem da Distribuição Normal Z (abrangendo 95%).
*   Se $n < 30$, usamos a Distribuição T em vez da Normal (o fator será maior que 1.96).

### B. Bootstrap (Computacional)
Não assume normalidade.
1.  Pega sua amostra original.
2.  Sorteia (com reposição) milhares de novas "amostras virtuais".
3.  Calcula a média de cada uma.
4.  Pega os percentis 2.5% e 97.5% dessa distribuição simulada.
*   **Vantagem:** Funciona para qualquer estatística (Mediana, Quartil, Risco Relativo) e qualquer distribuição estranha.

---

## 3. Prática em Python: Fórmula vs Bootstrap

```python
import numpy as np
import scipy.stats as stats

np.random.seed(42)

# Dados de Exemplo: Tempo de recuperação (dias) de 20 pacientes
# Distribuição ligeiramente assimétrica (Gamma)
dados = np.random.gamma(shape=2, scale=2, size=20) 

media = np.mean(dados)
sem = stats.sem(dados) # Erro Padrão
n = len(dados)

print(f"Média Amostral: {media:.2f} dias")
print(f"Erro Padrão (SEM): {sem:.2f}")

# --- MÉTODO 1: Paramétrico (T-Student, pois n=20 < 30) ---
# stats.t.interval(confiança, graus_liberdade, loc, scale)
ic_95_t = stats.t.interval(confidence=0.95, df=n-1, loc=media, scale=sem)

print(f"\nIC 95% (T-Student): [{ic_95_t[0]:.2f}, {ic_95_t[1]:.2f}]")

# --- MÉTODO 2: Bootstrap (Simulação) ---
# Vamos criar 10.000 amostras virtuais e ver a distribuição
medias_boot = []
for _ in range(10000):
    # Sorteia com reposição (replace=True)
    amostra_virt = np.random.choice(dados, size=n, replace=True)
    medias_boot.append(np.mean(amostra_virt))

# Pegamos os percentis 2.5% e 97.5%
ic_95_boot = np.percentile(medias_boot, [2.5, 97.5])

print(f"IC 95% (Bootstrap): [{ic_95_boot[0]:.2f}, {ic_95_boot[1]:.2f}]")

# Comparação
print("\n--- Conclusão ---")
print("Note que os intervalos são próximos, mas o Bootstrap é mais seguro")
print("se você suspeitar que a amostra viola premissas graves de simetria.")
```

### Quando aumentar a confiança?
Usamos 95% por convenção.
*   **Estudo exploratório:** 90% pode bastar.
*   **Segurança nuclear/Genética:** 99% ou 99.9%. Lembre-se: aumentar a confiança **alarga** o intervalo (perde precisão para ganhar certeza). Para ter certeza absoluta ($100\%$), o intervalo seria $[-\infty, +\infty]$, o que é inútil.
