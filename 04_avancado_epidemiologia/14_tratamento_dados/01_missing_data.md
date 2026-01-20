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

# Missing Data: O Silêncio Também Fala

> **"A ausência de evidência não é apenas um bug no banco de dados. É uma informação em si mesma."**
>
> O instinto do iniciante ao ver um `NaN` (Not a Number) é: *`df.dropna()`*.
> **PARE.**
> Jogar dados fora sem entender o *motivo* da ausência pode destruir seu estudo. Se apenas os pacientes mais graves morreram antes de coletar o exame, e você deleta esses dados, seu estudo vai concluir que a doença é inofensiva. Isso é **Viés de Seleção**.

---

## 1. Os 3 Mecanismos de Perda (Crucial)
Você precisa diagnosticar COMO o dado sumiu.

### A. MCAR (Missing Completely At Random) - O "Sorteio"
A perda é aleatória e não tem nada a ver com seus dados.
*   *Exemplo:* Um tubo de ensaio caiu no chão e quebrou.
*   *Consequência:* Deletar essas linhas diminui o poder ($N$), mas **não enviesa** os resultados. É o único cenário onde `dropna()` é seguro.

### B. MAR (Missing At Random) - O "Previsível"
A perda depende de outras variáveis que você coletou.
*   *Exemplo:* Homens (variável Sexo) têm mais chances de não responder sobre "Sentimentos" do que Mulheres.
*   *Consequência:* Se você deletar os `NaN`, você deleta mais homens. Sua amostra fica viciada em mulheres.
*   *Solução:* Como explicamos a perda pela variável "Sexo", métodos de **Imputação** funcionam perfeitamente aqui.

### C. MNAR (Missing Not At Random) - O "Pesadelo"
A perda depende do próprio valor que está faltando.
*   *Exemplo:* Pessoas com **renda muito alta** se recusam a responder qual é a renda.
*   *Consequência:* Os dados que sobraram são todos de rendas médias/baixas. A média calculada será totalmente errada (subestimada).
*   *Solução:* Quase impossível consertar estatisticamente. Requer *"Análise de Sensibilidade"* ou coleta de novos dados. A imputação vai errar aqui.

---

## 2. Estratégias de Tratamento

### O que NÃO fazer:
1.  **Listwise Deletion (`dropna`)**: Só use se for MCAR e for < 5% dos dados. Caso contrário, introduz viés severo.
2.  **Imputação pela Média/Mediana**: "Tapa buraco". Reduz artificialmente a variância (achatamento da curva) e distorce correlações. Só use para protótipos rápidos.

### O Padrão Ouro: MICE (Multiple Imputation by Chained Equations)
O MICE é muito mais sofisticado do que um simples "preenchimento". Ele entende que **a melhor dica sobre o valor que falta está nos valores que sobraram**.

**Como ele funciona "por baixo do capô" (O Ciclo das Equações Encadeadas):**
1.  **Inicialização:** Ele preenche os buracos inicialmente com a média (apenas para começar).
2.  **Ciclo de Regressão:** Ele pega a primeira coluna com dados faltantes (ex: `Renda`) e a trata como o "Y" numa regressão temporária, usando todas as outras colunas (`Idade`, `Sexo`, `Escolaridade`) como "X".
3.  **Predição Inteligente:** Ele usa essa regressão para prever o valor exato da `Renda` para aquele indivíduo, baseando-se na idade, sexo e escolaridade *dele*.
4.  **Iteração:** Ele repete isso para a próxima coluna, e para a próxima, ciclicamente. A cada rodada, as estimativas ficam mais refinadas e coerentes com a estrutura dos dados.
5.  **Incerteza ("Multiple"):** O MICE não faz isso apenas uma vez. Ele gera, por exemplo, 5 ou 10 conjuntos de dados diferentes. Se um valor faltante é muito incerto, ele variará bastante entre esses conjuntos. Isso captura a incerteza estatística real da imputação, algo que a simples média joga no lixo.

---

## 3. Prática em Python: MICE com Scikit-Learn

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.experimental import enable_iterative_imputer # Necessário ativar!
from sklearn.impute import IterativeImputer # O MICE do sklearn
from sklearn.impute import SimpleImputer

sns.set_theme(style="whitegrid")
np.random.seed(42)

# Cenário: Renda (Y) depende da Idade (X).
# Vamos introduzir buracos (Missings).

n = 1000
idade = np.random.uniform(20, 60, n)
renda_real = 2000 + 100 * idade + np.random.normal(0, 500, n) # Relação linear

df = pd.DataFrame({'idade': idade, 'renda': renda_real})

# Introduzindo Missing (MAR - Missing At Random)
# Pessoas mais jovens (>30 anos) "esquecem" de responder a renda com mais frequência
prob_missing = np.where(df['idade'] < 30, 0.4, 0.1) # 40% chance se jovem, 10% se velho
mask = np.random.rand(n) < prob_missing

df_missing = df.copy()
df_missing.loc[mask, 'renda'] = np.nan

print(f"Total de Missings: {df_missing['renda'].isna().sum()} ({df_missing['renda'].isna().mean():.1%})")

# Comparando Métodos

# 1. Simple Imputer (Média)
imp_mean = SimpleImputer(strategy='mean')
df_mean = df_missing.copy()
df_mean['renda'] = imp_mean.fit_transform(df_mean[['renda']])

# 2. MICE (Iterative Imputer)
# Ele usa a 'idade' para estimar a 'renda' perdida!
mice = IterativeImputer(max_iter=10, random_state=0)
df_mice = df_missing.copy()
# O MICE precisa de todas as colunas para aprender as relações
df_mice[:] = mice.fit_transform(df_mice) 

# --- Visualização: A Tragédia da Média vs A Mágica do MICE ---
fig, ax = plt.subplots(1, 3, figsize=(18, 5))

# Dados Reais (Sem perda)
sns.scatterplot(x='idade', y='renda', data=df, ax=ax[0], color='gray', alpha=0.3)
sns.regplot(x='idade', y='renda', data=df, ax=ax[0], scatter=False, color='black')
ax[0].set_title(f"Verdade Real\nCorrelação: {df.corr()['idade']['renda']:.2f}")

# Imputação por Média (Destrói a correlação)
sns.scatterplot(x='idade', y='renda', data=df_mean, ax=ax[1], color='red', alpha=0.3)
sns.regplot(x='idade', y='renda', data=df_mean, ax=ax[1], scatter=False, color='red')
ax[1].set_title(f"Imputação pela Média\nCorr: {df_mean.corr()['idade']['renda']:.2f} (Distorcida!)")
# Note a linha horizontal de pontos vermelhos. Isso destrói a relação idade/renda.

# Imputação MICE (Reconstrói a relação)
sns.scatterplot(x='idade', y='renda', data=df_mice, ax=ax[2], color='green', alpha=0.3)
sns.regplot(x='idade', y='renda', data=df_mice, ax=ax[2], scatter=False, color='green')
ax[2].set_title(f"Imputação MICE\nCorr: {df_mice.corr()['idade']['renda']:.2f} (Fiel!)")

plt.tight_layout()
# plt.show()
```

### Análise dos Gráficos
*   **Média (Vermelho):** Você verá uma linha horizontal bizarra. Isso subestima a correlação. Se você rodar uma regressão nesses dados, seu beta estará errado.
*   **MICE (Verde):** Ele "adivinhou" que pessoas jovens ganham menos (porque usou a coluna idade) e preencheu os buracos seguindo a linha de tendência. A correlação foi preservada.
