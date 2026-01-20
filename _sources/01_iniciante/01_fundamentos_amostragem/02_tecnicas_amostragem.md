# Técnicas de Amostragem e Viés

> **"Comer uma colher de sopa é suficiente para saber se a panela inteira está salgada - desde que você tenha misturado a sopa antes."** — George Gallup
>
> Estatística inferencial é a arte de julgar o todo (População) olhando apenas uma parte (Amostra). Se a parte for malcolhida, o julgamento será falho.

---

## 1. População vs. Amostra
*   **População ($N$):** O conjunto completo de todos os elementos que você quer estudar. (Ex: Todos os pacientes com Diabetes no Brasil). Fazer um Censo é caro, demorado e muitas vezes impossível.
*   **Amostra ($n$):** Um subconjunto da população. O objetivo é que ela seja **Representativa**.

---

## 2. Amostragem Probabilística (O Padrão Ouro)
Aqui, todos os indivíduos têm uma probabilidade conhecida (e não nula) de serem selecionados. É a única forma de calcular margens de erro e intervalos de confiança válidos.

### 2.1 Amostragem Aleatória Simples (AAS)
*   **Conceito:** Como um sorteio de loteria. Todos têm exata mesma chance.
*   **Quando usar:** Quando a população é homogênea e se tem uma lista completa de todos os indivíduos (*frame*).

### 2.2 Amostragem Estratificada
*   **Conceito:** Divide a população em subgrupos (estratos) que são importantes para a pesquisa (ex: Sexo, Faixa Etária) e sorteia proporcionalmente dentro de cada um.
*   **Vantagem:** Garante que minorias sejam representadas. Reduz o erro padrão se os estratos forem homogêneos internamente.
*   **O "Misturar a Sopa":** É a garantia de que pegamos um pouco de cada ingrediente (carne, batata, caldo).

### 2.3 Amostragem Sistemática
*   **Conceito:** Define um intervalo $k$ (ex: a cada 10 pessoas). Sorteia o ponto de partida e pega cada $k$-ésimo indivíduo.
*   **Risco:** Se a lista tiver um padrão cíclico (ex: pegar sempre a casa de esquina), introduzirá viés.

### 2.4 Amostragem por Conglomerados (*Cluster*)
*   **Conceito:** A unidade de sorteio não é o indivíduo, mas um grupo (ex: Escolas, Bairros). Sorteia-se aleatoriamente 4 escolas e testa-se TODOS os alunos delas.
*   **Uso:** Logística e custo. É mais barato viajar para 4 escolas do que para 100 escolas diferentes para pegar 1 aluno em cada.

---

## 3. Amostragem Não-Probabilística (Onde Mora o Perigo)
Não se conhece a chance de seleção. Os resultados **não podem ser generalizados** estatisticamente para a população, embora possam gerar *insights*.

1.  **Conveniência:** Pegar quem está perto (ex: entrevistar colegas da faculdade sobre a opinião nacional). Altíssimo viés.
2.  **Bola de Neve (*Snowball*):** Um participante indica outro. Útil para populações ocultas/marginalizadas (ex: usuários de drogas, diagnóstico raro).
3.  **Quotas:** Tenta imitar a estratificada, mas a seleção dentro da quota é por conveniência, não aleatória.

### O Viés de Sobrevivência (*Survivorship Bias*)
O exemplo clássico dos aviões na 2ª Guerra Mundial. O exército queria blindar as partes onde os aviões que retornavam tinham mais furos de bala. O estatístico Abraham Wald apontou o erro: **deviam blindar onde NÃO havia furos**. Por quê? Porque os aviões atingidos naquelas áreas (motores, cockpit) **não voltaram para serem contados**. A amostra "aviões que retornaram" era enviesada.

---

## 4. Prática em Python: Simulando Métodos

Vamos usar o `pandas` para demonstrar como extrair amostras de um dataset sintético.

```python
import pandas as pd
import numpy as np

# 1. Gerando uma População Sintética (N=10.000)
np.random.seed(42) # Para reprodutibilidade
dados = {
    'id': range(1, 10001),
    'idade': np.random.randint(18, 90, 10000),
    'classe_social': np.random.choice(['A', 'B', 'C', 'D'], 10000, p=[0.1, 0.3, 0.4, 0.2]),
    'valor_compra': np.random.normal(500, 150, 10000)
}
df_populacao = pd.DataFrame(dados)

print(f"Média Real da População (Valor Compra): {df_populacao['valor_compra'].mean():.2f}")
print(f"Distribuição Real Classes:\n{df_populacao['classe_social'].value_counts(normalize=True)}")

print("\n--- 1. Amostragem Aleatória Simples (n=100) ---")
amostra_simples = df_populacao.sample(n=100, random_state=1)
print(f"Média AAS: {amostra_simples['valor_compra'].mean():.2f}")
# Note: Pode se aproximar ou não, dependendo apenas da sorte

print("\n--- 2. Amostragem Estratificada (Proporcional a Classe Social) ---")
# O pandas não tem 'stratified' nativo direto no sample, mas o scikit-learn tem.
# Vamos fazer "na mão" com pandas groupby para entender a lógica.

def amostragem_estratificada(df, coluna_estrato, n_amostra):
    n_pop = len(df)
    amostra = df.groupby(coluna_estrato, group_keys=False).apply(
        lambda x: x.sample(frac=n_amostra/n_pop, random_state=1)
    )
    return amostra

amostra_estrat = amostragem_estratificada(df_populacao, 'classe_social', 100)
print(f"Média Estratificada: {amostra_estrat['valor_compra'].mean():.2f}")
print("Proporções na Amostra Estratificada (Deve ser igual à pop):")
print(amostra_estrat['classe_social'].value_counts(normalize=True))

print("\n--- 3. Amostragem de Conveniência (Os primeiros 100 ids) ---")
# Simulando que pegamos apenas quem chegou primeiro na loja (IDs baixos)
# Se ID tivesse correlação com tempo/perfil, isso daria muito errado.
amostra_conveniencia = df_populacao.head(100)
print(f"Média Conveniência: {amostra_conveniencia['valor_compra'].mean():.2f}")
```

### Interpretação
Ao rodar este código, observe como a **Amostragem Estratificada** tende a manter as proporções das classes (`A, B, C, D`) idênticas à população original, garantindo que não tenhamos, por acaso, uma amostra só de classe 'A' (o que inflaria a média de compra, já que classe A talvez gaste mais). A amostragem aleatória simples (AAS) é boa, mas a estratificada é **tecnicamente superior** quando sabemos que existem grupos heterogêneos.

---
## Próximo Passo
Com os dados coletados corretamente, precisamos resumi-los. Entramos em **Estatística Descritiva: Medidas de Posição**.
