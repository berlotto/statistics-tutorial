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

# Tipos de Dados e Escalas de Mensuração

> **"Torture os dados e eles confessarão qualquer coisa."** — Ronald Coase
>
> Mas antes de torturá-los, você precisa saber que língua eles falam. Tratar uma variável ordinal como se fosse quantitativa é o erro primário que invalida teses de doutorado inteiras.

---

## 1. O Conceito: A Ontologia da Variável

Em ciência de dados e estatística, **saber o tipo da variável dita o teste estatístico**. Você não faz uma média de gênero, e você não deve fazer um teste de Qui-Quadrado com a pressão arterial (a menos que a categorize, o que geralmente é uma má ideia).

### 1.1 Dados vs. Informação
*   **Dado:** É o registro bruto. Ex: `140`.
*   **Informação:** É o dado com contexto e semântica. Ex: `140 mmHg` (Pressão Sistólica de um paciente em repouso).

### 1.2 A Taxonomia das Variáveis

#### A. Variáveis Qualitativas (Categóricas)
Descrevem qualidades ou categorias. Não fazem sentido matemático direto (não existe "Categoria A menos Categoria B").

1.  **Nominais:** Nomes ou rótulos sem ordem implícita.
    *   *Exemplos:* Tipo Sanguíneo (A, B, AB, O), Sexo Biológico (M, F), Estado Civil.
    *   *Dicotômicas (Binárias):* Apenas duas categorias (Sim/Não, Vivo/Morto). São fundamentais para Regressão Logística.
    *   *Politômicas:* Mais de duas categorias.

2.  **Ordinais:** Categorias com uma ordem clara, mas **a distância entre elas não é mensurável**.
    *   *Exemplos:* Estadiamento de Câncer (I, II, III, IV), Escolaridade, Escala Likert de Satisfação.
    *   *O ERRO CLÁSSICO:* Calcular a média de uma escala Likert (1=Discordo, 5=Concordo). A distância entre "Discordo" e "Neutro" é a mesma que entre "Neutro" e "Concordo"? Matematicamente não garantido. Use a **Mediana**.

#### B. Variáveis Quantitativas (Numéricas)
Representam quantidades mensuráveis.

1.  **Discretas:** Resultam de uma **contagem**. Apenas números inteiros fazem sentido no contexto.
    *   *Exemplos:* Número de filhos, número de internações, tentativas de login.
    *   *Distribuição Típica:* Poisson.

2.  **Contínuas:** Resultam de uma **mensuração**. Podem assumir infinitos valores dentro de um intervalo (dependendo da precisão do instrumento).
    *   *Exemplos:* Altura (1.75m), Peso, Glicemia, Tempo.
    *   *Distribuição Típica:* Normal (Gaussiana).

---

## 2. As Escalas de Mensuração (O Nível de Refinamento)

Stevens (1946) definiu quatro escalas que determinam as operações matemáticas permitidas:

1.  **Nominal:** Identidade. (Operações: $=, \neq$).
2.  **Ordinal:** Ordem. (Operações: $>, <$).
3.  **Intervalar:** Diferenças fazem sentido, mas o **zero é arbitrário**. Não indica ausência de grandeza.
    *   *Exemplo Clássico:* Temperatura em Celsius. 0°C não é "ausência de temperatura". 20°C não é "o dobro de calor" de 10°C.
    *   *Estatística:* Pode calcular média e desvio padrão.
4.  **Razão (Ratio):** Diferenças fazem sentido e existe um **zero absoluto** (ausência de quantidade).
    *   *Exemplo:* Peso, Altura, Salário, Kelvin. R$ 2000 é o dobro de R$ 1000.
    *   *Estatística:* Permite todas as operações, inclusive coeficiente de variação.

> ⚠️ **Atenção Crítica:** Evite categorizar variáveis contínuas (ex: transformar IMC numérico em "Baixo/Normal/Alto") a menos que estritamente necessário para a clínica. Isso joga fora informação valiosa e diminui o poder estatístico (a capacidade de detectar efeitos).

---

## 3. Prática em Python `pandas`

No Python, o `pandas` nem sempre adivinha o tipo ideal. Cabe ao cientista definir.

```python
import pandas as pd
import numpy as np

# Simulação de um Dataset Clínico
dados = {
    'id_paciente': [1, 2, 3, 4, 5],
    'sexo': ['M', 'F', 'F', 'M', 'M'],            # Nominal
    'estagio_doenca': ['I', 'II', 'I', 'IV', 'III'], # Ordinal
    'numero_filhos': [0, 2, 1, 3, 0],               # Quantitativa Discreta
    'colesterol_total': [190.5, 240.2, 180.0, 210.8, 300.1], # Quantitativa Contínua
    'satisfacao': [5, 4, 5, 2, 1]                   # Ordinal ("Numérica" mas é Qualitativa!)
}

df = pd.DataFrame(dados)

# --- 1. Definindo Tipos Corretamente ---

# Nominal: 'category' sem ordem
df['sexo'] = df['sexo'].astype('category')

# Ordinal: 'category' COM ordem (Crítico para gráficos funcionarem na ordem certa)
ordem_estagio = ['I', 'II', 'III', 'IV']
df['estagio_doenca'] = pd.Categorical(df['estagio_doenca'], categories=ordem_estagio, ordered=True)

# Discreta e Contínua geralmente ficam como int64 ou float64
# Mas atenção! 'satisfacao' parece número, mas é ordinal.
# Se tratarmos como número, calcularemos média (o que é discutível).

print("--- Tipos de Dados (Dtypes) ---")
print(df.dtypes)

print("\n--- Estatísticas Descritivas Apropriadas ---")
# Para Contínuas: Média e Desvio
print(f"Colesterol Médio: {df['colesterol_total'].mean():.2f}")

# Para Ordinais/Nominais: Contagem e Moda
print(f"Moda do Estágio da Doença: {df['estagio_doenca'].mode()[0]}")

# O perigo da média em ordinais
print(f"Média da Satisfação (Cuidado!): {df['satisfacao'].mean():.2f}")
print(f"Mediana da Satisfação (Mais seguro): {df['satisfacao'].median():.2f}")
```

### Interpretação do Código
1.  **`astype('category')`:** Economiza memória e informa às bibliotecas de plotagem (`seaborn`) como agrupar.
2.  **`pd.Categorical(..., ordered=True)`:** Essencial. Sem isso, um gráfico ordenaria 'Estágio IV' antes de 'Estágio II' porque alfabeticamente 'I' vem antes.
3.  **Análise Diferenciada:** Note que pedimos média para colesterol, mas moda para estágio da doença. O Python calcula média de `satisfacao` porque são números (1-5), mas o cientista deve saber que 3.4 de satisfação é uma abstração arriscada.

---

## Próximo Passo
Agora que sabemos *o que* estamos medindo, precisamos saber *como* coletar esses dados sem enviesar a realidade. Vamos para **Técnicas de Amostragem**.
