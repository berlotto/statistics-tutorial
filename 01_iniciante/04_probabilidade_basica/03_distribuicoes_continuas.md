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

# Distribuições Contínuas (A Régua do Mundo)

> **"Todo mundo acredita na Lei Normal: os experimentadores porque acham que é um teorema matemático, e os matemáticos porque acham que é um fato experimental."** — Gabriel Lippmann
>
> Em variáveis contínuas, a curva em forma de sino (Bell Curve) é a rainha. Mas cuidado: nem tudo é normal.

---

## 1. Distribuição Normal (Gaussiana)
É simétrica, unimodal e definida apenas por dois parâmetros: Média ($\mu$) e Desvio Padrão ($\sigma$).

### Propriedades Mágicas (Regra 68-95-99.7)
*   **68.2%** dos dados estão a $\pm 1 \sigma$ da média.
*   **95.4%** dos dados estão a $\pm 2 \sigma$ da média.
*   **99.7%** dos dados estão a $\pm 3 \sigma$ da média.

Isso nos permite detectar o que é "raro". Se alguém tem altura de $4\sigma$ acima da média, essa pessoa é um gigante estatístico (probabilidade < 0.003%).

### Padronização (Z-Score)
Para comparar laranjas com bananas, transformamos tudo em "Desvios Padrão de distância da média".
$$ Z = \frac{x - \mu}{\sigma} $$
*   Uma variável $Z$ sempre tem Média=0 e Desvio Padrão=1. Isso é a **Normal Padrão**.

---

## 2. Distribuição T-Student (A Amiga das Pequenas Amostras)
Criada por William Gosset (que trabalhava na cervejaria Guinness e usava o pseudônimo "Student"), ela se parece com a Normal, mas tem **Caudas Mais Grossas** (Fat Tails).

*   **Por que existe?** Quando temos amostras pequenas ($n < 30$), nossa estimativa do desvio padrão real ($\sigma$) é ruim. A incerteza aumenta. As caudas gordas da T-Student compensam essa incerteza, tornando os Intervalos de Confiança mais largos (mais conservadores).
*   Quando $n$ cresce ($>30$ ou $>100$), a T-Student vira idêntica à Normal.

---

## 3. Prática em Python: Normal vs T-Student

```python
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

# Configurando o plot
x = np.linspace(-4, 4, 1000)

# 1. Normal Padrão (Média 0, SD 1)
y_normal = stats.norm.pdf(x, loc=0, scale=1)

# 2. T-Student com poucos graus de liberdade (df=2) - Amostra minúscula
y_t_small = stats.t.pdf(x, df=2)

# 3. T-Student com muitos graus de liberdade (df=30) - Amostra decente
y_t_large = stats.t.pdf(x, df=30)

plt.figure(figsize=(10, 6))

# Plotando
plt.plot(x, y_normal, 'k-', linewidth=2, label='Normal Padrão (Z)')
plt.plot(x, y_t_small, 'r--', linewidth=2, label='t-Student (n=3) - Caudas Gordas!')
plt.plot(x, y_t_large, 'b:', linewidth=2, label='t-Student (n=31) - Quase Normal')

plt.title('Normal vs T-Student: O impacto do tamanho da amostra')
plt.xlabel('Desvios Padrão (Z ou t)')
plt.ylabel('Densidade de Probabilidade')
plt.legend()
plt.grid(True, alpha=0.3)

# Calculando probabilidades (Área sob a curva)
# Qual a chance de cair acima de 2 desvios padrão?
# Na Normal:
p_normal = 1 - stats.norm.cdf(2)
# Na T-Student (n=3):
p_t = 1 - stats.t.cdf(2, df=2)

print(f"Probabilidade de valor > 2 desvios:")
print(f"Normal:   {p_normal:.4f} (Evento raro, ~2.2%)")
print(f"t-Student:{p_t:.4f} (Evento mais comum, ~9.1%!)")
```

### Interpretação Crítica
Veja o print final. Na Normal, estar a 2 desvios da média é raro (2%). Na T-Student (amostra pequena), isso acontece em 9% das vezes!
Isso mostra que, **com poucos dados, eventos extremos são muito mais prováveis do que a curva Normal prevê**. Ignorar isso (usar Normal para $n=5$) leva a erros grosseiros de subestimação de risco.
