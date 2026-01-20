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

# Storytelling com Dados

> **"Números têm uma história importante para contar. Eles dependem de você para dar-lhes uma voz."** — Stephen Few

Você rodou os modelos, calculou os p-valores e tem os gráficos. Agora, como convencer seu chefe, orientador ou cliente? É aqui que entra o **Data Storytelling**.

Não é sobre inventar ficção, é sobre **estruturar a verdade** de forma que o cérebro humano entenda e lembre.

---

## 1. O Arco Narrativo da Análise

Uma boa apresentação de dados segue a estrutura de uma história:

1.  **O Contexto (A Situação):** "Nossas vendas caíram 10% no último trimestre."
2.  **O Conflito (O Problema/Mistério):** "Acreditávamos que era sazonalidade, mas nossos concorrentes cresceram."
3.  **A Jornada (A Análise):** "Investigamos churn, novos clientes e marketing..."
4.  **O Clímax (O Insight):** "Descobrimos que a queda foi concentrada em usuários iOS após a atualização do app."
5.  **A Resolução (A Ação):** "Precisamos corrigir o bug de checkout no iOS imediatamente."

**Erro comum:** Começar pelo passo 3 ("Olhem esse gráfico scatter que eu fiz..."). Ninguém se importa com seu esforço, todos se importam com a resolução do problema.

---

## 2. Princípios de Visual Design (Decluttering)

O guru Edward Tufte chama isso de "Data-Ink Ratio". A tinta usada para dados deve ser maximizada; a tinta "decorativa" deve ser eliminada.

### O que eliminar (O "Lixo Gráfico"):
*   Bordas pesadas.
*   Cores de fundo escuras ou texturizadas.
*   Efeitos 3D (Jamais use pizza 3D. Jamais!).
*   Linhas de grade (gridlines) excessivas.

### Exemplo Prático: Do Caos à Clareza

```python
import matplotlib.pyplot as plt
import numpy as np

# Dados
categorias = ['A', 'B', 'C', 'D', 'E']
valores = [15, 28, 65, 45, 30]

plt.figure(figsize=(12, 5))

# --- GRÁFICO RUIM ---
plt.subplot(1, 2, 1)
plt.bar(categorias, valores, color=['red', 'blue', 'green', 'yellow', 'purple']) # Cores sem sentido
plt.grid(True, which='both', color='black', linestyle='-', linewidth=2) # Grid pesado
plt.title("Valores por Categoria (Difícil de ler)")
plt.ylabel("Valores")

# --- GRÁFICO BOM (Storytelling) ---
# Foco: A categoria C é a campeã. Vamos destacar só ela.
plt.subplot(1, 2, 2)
cores = ['lightgray'] * 5
cores[2] = '#005b96' # Destacar a categoria C com azul profissional

plt.bar(categorias, valores, color=cores)

# Remover bordas desnecessárias (spines)
plt.gca().spines['top'].set_visible(False)
plt.gca().spines['right'].set_visible(False)

# Adicionar o valor diretamente na barra (melhor que eixo Y)
for i, v in enumerate(valores):
    plt.text(i, v + 1, str(v), ha='center', fontweight='bold' if i==2 else 'normal')

plt.title("A Categoria C domina o mercado", loc='left', fontsize=14, fontweight='bold') # Título é a conclusão
plt.yticks([]) # Remove eixo Y redundante
plt.show()
```

### Diferenças Chave:
1.  **Cor com Propósito:** No gráfico ruim, as cores são "confete". No bom, a cor cinza é contexto e o azul é a história (Categoria C).
2.  **Título Ativo:** "Valores por Categoria" (descritivo) vs "A Categoria C domina" (conclusão/insight).
3.  **Limpeza:** Sem bordas, sem grid, sem eixos desnecessários. O dado brilha.

---

## 3. Dicas Finais

*   **Não faça o leitor pensar:** Se ele tiver que virar a cabeça para ler um eixo, você falhou.
*   **Anotações:** Use setas e textos no gráfico para apontar o que importa ("Queda devido à pandemia").
*   **Ordem Importa:** Em gráficos de barras, ordene do maior para o menor (a menos que a ordem tenha lógica intrínseca, como dias da semana).

Lembre-se: Você não é pago para fazer gráficos. Você é pago para **influenciar decisões** com dados.
