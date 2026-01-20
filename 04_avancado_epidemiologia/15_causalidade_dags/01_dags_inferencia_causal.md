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

# Inferência Causal: Além da Correlação

> **"Correlação não implica Causalidade... mas com um DAG, você pode desenhar o caminho."**
>
> Até hoje te ensinaram que para provar causa precisa de um Ensaio Clínico Randomizado (RCT). Mentira.
> Com a revolução da Causalidade (Judea Pearl), podemos inferir causa de dados observacionais, **SE** desenharmos nossas premissas corretamente.

---

## 1. O DAG (Directed Acyclic Graph)
É um desenho das suas premissas sobre como o mundo funciona.
*   Setas representam CAUSA ($A \to B$).
*   A falta de seta é a premissa mais forte: diz que A **não** causa B.

## 2. As 3 Estruturas Fundamentais
Todo gráfico complexo é montado com peças de Lego dessas 3 estruturas.

### A. O Garfo (Fork): Confundidor (A $\leftarrow$ B $\to$ C)
$B$ é a causa comum de $A$ e $C$.
*   *Exemplo:* $B$ (Calor) causa $A$ (Venda de Sorvete) e $C$ (Ataques de Tubarão).
*   *Problema:* $A$ e $C$ parecerão correlacionados.
*   *Solução:* **Controlar por B** (fechar a porta dos fundos/backdoor). Se olharmos só dias com a mesma temperatura, a correlação some.

### B. A Corrente (Chain): Mediador (A $\to$ B $\to$ C)
$A$ causa $B$, que causa $C$.
*   *Exemplo:* $A$ (Fogo) $\to$ $B$ (Fumaça) $\to$ $C$ (Alarme).
*   *Atenção:* Se você quer saber o efeito total do Fogo no Alarme, **NÃO CONTROLE PELA FUMAÇA**. Se você controlar por $B$, você bloqueia o caminho causal e conclui (erroneamente) que Fogo não toca o alarme.

### C. O Colisor (Collider): O Perigo Oculto (A $\to$ B $\leftarrow$ C)
$A$ e $C$ causam $B$. A e C são independentes, mas "colidem" em B.
*   *Exemplo Clássico:* $A$ (Beleza) e $C$ (Talento) causam $B$ (Ser Celebridade).
*   *Problema:* Na população geral, gente bonita não é mais nem menos talentosa. A correlação é zero.
*   *Onde o viés nasce:* Quando você olha **apenas para Celebridades** (controla por $B$), você cria uma regra oculta: "Para estar aqui, ou você é lindo, ou é talentoso (ou ambos)".
    *   Se eu vejo uma celebridade feia, ela **TEM** que ser talentosa (senão não estaria ali).
    *   Se eu vejo uma celebridade linda, ela não precisa necessariamente de talento.
    *   Isso cria uma **correlação negativa artificial**: entre celebridades, quanto mais bonito, "menos talentoso" parece ser. Isso é falso no mundo real, é uma ilusão da amostra selecionada.
*   *Regra de Ouro:* **NUNCA controle por um colisor**. Isso abre um caminho de associação falso onde antes não existia nada.

---

## 3. Prática em Python: O Paradoxo de Berkson (Collider Bias)

Vamos provar que controlar pela variável errada cria correlações falsas.

```python
import pandas as pd
import numpy as np
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Hollywood
# Queremos saber: Beleza causa Talento? (Esperamos que NÃO)
n = 1000

# Beleza e Talento são independentes na população (Normal 0, 1)
beleza = np.random.normal(0, 1, n)
talento = np.random.normal(0, 1, n)

# Mas para ser Famoso (Sucesso), você precisa da soma dos dois
# Sucesso = Beleza + Talento + Ruído
score_sucesso = beleza + talento + np.random.normal(0, 0.5, n)

# Apenas os Top 15% viram Celebridades (Amostra Selecionada)
limite = np.percentile(score_sucesso, 85)
is_celebridade = score_sucesso > limite

df = pd.DataFrame({'beleza': beleza, 'talento': talento, 'celebridade': is_celebridade})

# 1. Análise na População Geral (Correta)
modelo_real = smf.ols("talento ~ beleza", data=df).fit()

# 2. Análise Estratificada (SÓ nas Celebridades - Errada)
modelo_celebridades = smf.ols("talento ~ beleza", data=df[df['celebridade']==True]).fit()

print("--- O Efeito da Beleza no Talento ---")
print(f"1. População Geral (Verdade): Beta = {modelo_real.params['beleza']:.2f} (Deveria ser 0)")
print(f"2. Só Celebridades (Viés):   Beta = {modelo_celebridades.params['beleza']:.2f}")

# Visualização
plt.figure(figsize=(10, 6))

# Plotando todo mundo (cinza)
sns.scatterplot(x='beleza', y='talento', data=df[~df['celebridade']], color='lightgray', alpha=0.3, label='Anônimos')

# Plotando celebridades (vermelho)
sns.scatterplot(x='beleza', y='talento', data=df[df['celebridade']], color='red', label='Celebridades')

# Regressão nas Celebridades
sns.regplot(x='beleza', y='talento', data=df[df['celebridade']], scatter=False, color='red')

plt.title('Paradoxo de Berkson: O Viés do Colisor')
plt.xlabel('Beleza')
plt.ylabel('Talento')
plt.legend()
# plt.show()
```

### O que aconteceu?
*   No grupo vermelho (Celebridades), a reta desce (correlação negativa). Parece que "Gente bonita é burra/sem talento".
*   Mas isso é falso! A reta cinza (população) é plana.
*   **Motivo:** Se você é uma celebridade e é feio, **você TEM que ser talentoso** para ter entrado lá. Se você é lindo, pode se dar ao luxo de ter menos talento.
*   Essa correlação negativa foi criada artificialmente ao selecionarmos a amostra baseada numa consequência comum.
