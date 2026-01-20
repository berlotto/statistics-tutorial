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

# Fundamentos de Testes de Hipótese

> **"A ausência de evidência não é evidência de ausência."** — Carl Sagan

Muitos aprendem testes estatísticos mecanicamente: *"calcule p, se < 0.05 rejeite"*. Isso leva a erros graves. Vamos reconstruir a lógica correta.

---

## 1. A Lógica do "Advogado do Diabo"

A ciência é conservadora. Ela assume que **nada aconteceu** até que se prove o contrário.

1.  **Hipótese Nula ($H_0$):** O status quo. "O remédio não funciona", "A média é igual", "Não há correlação".
2.  **Hipótese Alternativa ($H_1$):** A descoberta. "O remédio funciona", "A média mudou".

Nós nunca "provamos" $H_0$. Nós apenas falhamos em rejeitá-la (como um tribunal que declara "inocente por falta de provas", não "inocente porque provamos bondade").

### O Fluxo Real:
1.  Assumimos que $H_0$ é verdadeira (Mundo chato).
2.  Coletamos dados.
3.  Perguntamos: *"Se $H_0$ fosse verdade, qual a chance de eu ver dados tão extremos quanto esses?"*
4.  Essa chance é o **P-valor**.

---

## 2. Erros Tipo I e Tipo II (A Tabela da Verdade)

Toda decisão estatística tem risco.

| Decisão \ Realidade | $H_0$ é Verdadeira (Sem efeito) | $H_0$ é Falsa (Existe efeito) |
| :--- | :--- | :--- |
| **Rejeitar $H_0$** (Dizer que há efeito) | **Erro Tipo I ($\alpha$)** <br> *Falso Positivo* | **Decisão Correta** <br> (Poder) |
| **Não Rejeitar $H_0$** (Dizer que não há efeito) | **Decisão Correta** | **Erro Tipo II ($\beta$)** <br> *Falso Negativo* |

### Exemplos Dramáticos:
*   **Erro Tipo I (Alarme Falso):** Condenar um inocente. Aprovar um remédio inútil com efeitos colaterais.
*   **Erro Tipo II (Perda de Oportunidade):** Deixar um culpado solto. Jogar fora um remédio que curaria o câncer porque o estudo foi pequeno demais.

---

## 3. P-Hacking e Múltiplas Comparações

Se você definir $\alpha = 0.05$ (5% de chance de erro Tipo I), significa que a cada 20 testes inúteis, **1 dará positivo por pura sorte**.

Se você testar 20 variáveis diferentes contra o seu target, você *vai* encontrar algo "significante" que é apenas ruído. Isso é **P-Hacking**.

### Solução: Correção de Bonferroni
Se você fizer $N$ testes, divida seu alfa por $N$.
$$ \alpha_{ajustado} = \frac{0.05}{N} $$
Se testar 20 hipóteses, só aceite $p < 0.0025$.

---

## 4. Prática: Visualizando o Poder do Teste

Vamos simular o "Poder" (Chance de não cometer erro Tipo II).

```python
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

# Configuração
mu_h0 = 100       # Média se H0 for verdade
mu_h1 = 105       # Média se H1 for verdade (Efeito Real = 5)
sigma = 15
n = 30
alpha = 0.05

# Erro Padrão
sem = sigma / np.sqrt(n)

# Valor Crítico para Rejeitar H0 (Unicaudal à direita)
# Se a média da amostra for maior que isso, rejeitamos H0
valor_critico = stats.norm.ppf(1 - alpha, loc=mu_h0, scale=sem)

x = np.linspace(85, 120, 1000)
y_h0 = stats.norm.pdf(x, loc=mu_h0, scale=sem)
y_h1 = stats.norm.pdf(x, loc=mu_h1, scale=sem)

plt.figure(figsize=(10, 6))

# Plot H0
plt.plot(x, y_h0, 'k-', label='H0 (Sem efeito)')
plt.fill_between(x, y_h0, where=(x > valor_critico), color='red', alpha=0.3, label='Erro Tipo I (Alfa)')

# Plot H1
plt.plot(x, y_h1, 'b--', label=f'H1 (Efeito real={mu_h1-mu_h0})')
plt.fill_between(x, y_h1, where=(x > valor_critico), color='green', alpha=0.3, label='Poder (1 - Beta)')
plt.fill_between(x, y_h1, where=(x <= valor_critico), color='gray', alpha=0.3, label='Erro Tipo II (Beta)')

plt.axvline(valor_critico, color='black', linestyle=':', label=f'Crítico: {valor_critico:.1f}')
plt.title('A Batalha entre H0 e H1: Trade-off de Erros')
plt.legend()
plt.show()

# Cálculo do Poder
poder = 1 - stats.norm.cdf(valor_critico, loc=mu_h1, scale=sem)
print(f"Poder do Teste: {poder:.2%}")
print("Significa que temos {:.1f}% de chance de detectar esse efeito com n={}.".format(poder*100, n))
```

### Insights
Se você rodar o código acima com `n=100`, verá a área verde (Poder) crescer e a cinza (Erro II) sumir. **Aumentar a amostra é a única forma de reduzir o Erro Tipo II sem aumentar o Erro Tipo I.**
