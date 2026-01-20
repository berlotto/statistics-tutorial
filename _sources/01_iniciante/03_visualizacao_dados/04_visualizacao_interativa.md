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

# Visualização Interativa (Plotly)

> **"Se uma imagem vale mil palavras, uma imagem interativa vale mil imagens."**

Gráficos estáticos (`matplotlib`, `seaborn`) são ótimos para artigos impressos (PDFs). Mas no mundo digital (dashboards, notebooks, apresentações), a interatividade permite que o usuário **explore** os dados e encontre seus próprios insights.

A biblioteca padrão-ouro para isso em Python é o **Plotly**.

---

## 1. Por que Interativo?
1.  **Zoom:** Permite focar em detalhes ou outliers específicos.
2.  **Hover (Mouse sobre):** Mostra os dados exatos (ex: valor exato da venda, nome do cliente) sem poluir o gráfico com rótulos.
3.  **Filtragem:** Clicar na legenda para esconder/mostrar grupos.

---

## 2. Prática: Transformando Estático em Dinâmico

Vamos recriar gráficos clássicos, mas agora com "superpoderes".

```python
import plotly.express as px
import plotly.io as pio

# Definir template padrão para ficar bonito
pio.templates.default = "plotly_white"

# Dados: Gapminder (Expectativa de vida e PIB per capita por país)
df = px.data.gapminder().query("year == 2007")

# --- 1. Scatter Plot Interativo ---
# O que ganho: Ao passar o mouse, vejo o NOME DO PAÍS (que seria impossível colocar estático)
fig1 = px.scatter(df, 
                 x="gdpPercap", 
                 y="lifeExp", 
                 size="pop", 
                 color="continent",
                 hover_name="country", 
                 log_x=True, 
                 size_max=60,
                 title="Expectativa de Vida vs PIB (2007)")
fig1.show()
```

### Experimente:
*   Passe o mouse sobre as bolhas grandes. Qual país é?
*   Dê dois cliques na legenda "Americas" para isolar apenas esse continente.
*   Use a ferramenta de zoom (lupa) para ver os países pobres (canto inferior esquerdo).

---

## 3. Boxplot Interativo com Pontos

No `matplotlib`, adicionar os pontos de dados (jitter) sobre o boxplot é trabalhoso. No Plotly, é um argumento.

```python
# Dados de gorjetas novamente
tips = px.data.tips()

fig2 = px.box(tips, 
              x="day", 
              y="total_bill", 
              color="smoker",
              points="all", # Mostra TODOS os pontos ao lado da caixa
              title="Distribuição de Contas por Dia (com dados brutos)")

fig2.update_layout(xaxis_title="Dia da Semana", yaxis_title="Valor da Conta ($)")
fig2.show()
```

### O Poder dos Pontos "All"
Ao ver a caixa (resumo) E os pontos (realidade), você evita ser enganado por estatísticas. Você vê se a "cauda longa" é feita de um único outlier ou de vários pontos dispersos.

---

## 4. Gráfico de Linha Interativo (Séries Temporais)

O "killer feature" para séries temporais é o **Range Slider**.

```python
# Dados de ações (stocks)
stocks = px.data.stocks()

fig3 = px.line(stocks, 
               x='date', 
               y=['GOOG', 'AAPL', 'AMZN', 'FB', 'NFLX', 'MSFT'],
               title='Evolução de Ações Tech (Use o slider abaixo!)')

# Adiciona o slider mágico no eixo X
fig3.update_xaxes(rangeslider_visible=True)
fig3.show()
```

### Conclusão
Para **exploração de dados** (EDA) e **apresentação para stakeholders**, prefira o Plotly. A capacidade de responder perguntas ("quem é aquele outlier?") em tempo real durante uma reunião é inestimável.
