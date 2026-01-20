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

# Reporte Científico: Escrevendo para Perdurar

> **"Fazer a estatística certa é 50% do trabalho. Comunicá-la corretamente é os outros 50%."**
>
> Muitos papers excelentes são rejeitados porque a seção de Metodologia é obscura ou os Resultados são confusos.
> Aqui estão as regras de ouro para escrever como um cientista de dados sênior.

---

## 1. A Seção de Métodos (Receita de Bolo)
NÃO diga apenas *"Fizemos Teste T"*.
Diga o PORQUÊ e QUAIS suposições validou.

**Exemplo Ruim:**
> "Os dados foram analisados usando Teste T e ANOVA no SPSS."

**Exemplo Bom (Master):**
> "As variáveis contínuas foram descritas como média $\pm$ desvio padrão (se normais) ou mediana [IQR] (se não-normais). A normalidade foi verificada visualmente por Q-Q plots e histogramas.
> Para comparações entre dois grupos, utilizamos o Teste T de Student independente quando a homogeneidade de variâncias (teste de Levene) foi preservada; caso contrário, aplicamos o teste T de Welch.
> Para associações categóricas, usamos o teste Qui-quadrado de Pearson ou Exato de Fisher quando as frequências esperadas eram $<5$.
> Análises foram conduzidas em Python 3.9 (bibliotecas `scipy` v1.7 e `statsmodels` v0.12). O nível de significância foi fixado em $\alpha=0.05$ (bicaudal)."

---

## 2. A Seção de Resultados

### Regra 1: O "Sobrenome" da Média é o Desvio Padrão
Nunca reporte uma média solta.
*   **Errado:** "A pressão média foi 120."
*   **Certo:** "A pressão média foi 120 $\pm$ 15 mmHg."

### Regra 2: P-valor não é Deus
Reporte sempre o Intervalo de Confiança (IC 95%) e o Tamanho do Efeito.
*   **Errado:** "O remédio funcionou (p<0.05)."
*   **Certo:** "O remédio reduziu a pressão em 10 mmHg (IC 95%: 5 a 15; p=0.003), representando um tamanho deefeito moderado (Cohen's d = 0.6)."

### Regra 3: Abandone o "NS" (Non-Significant)
Nunca escreva apenas "p > 0.05" ou "NS".
*   $p=0.06$ é muito diferente de $p=0.90$.
*   Reporte o valor exato até 3 casas decimais (ex: $p=0.054$), para que o leitor julgue.
*   *Exceção:* Se $p < 0.001$, pode escrever $p < 0.001$. (Nunca escreva $p=0.000$).

---

## 3. Checklist de Reprodutibilidade
Antes de submeter, pergunte-se:
1.  **Dados:** Disponibilizei o CSV ou uma amostra anônima?
2.  **Código:** Disponibilizei o Notebook ou script Python?
3.  **Seed:** Defini `np.random.seed(42)` para que as simulações sejam iguais?
4.  **Versões:** Anotei as versões das bibliotecas (requirements.txt)?

### 3.1 Template de Dicionário de Dados
Ajude quem vai ler seu dado daqui a 5 anos (provavelmente você mesmo).

```markdown
# Dicionário de Dados: Estudo XPTO

| Variável | Tipo | Unidade | Descrição |
| :--- | :--- | :--- | :--- |
| `id_paciente` | ID | N/A | Identificador único anonimizado |
| `pressao_sistolica` | Numérico | mmHg | Média de 3 medidas sentado |
| `grupo_tratamento` | Categórico | 0/1 | 0=Placebo, 1=Droga Nova |
| `data_inclusao` | Data | YYYY-MM-DD | Data da assinatura do TCLE |
```

---

## 4. O Gran Finale: Exemplo de Tabela 1
Em saúde, a "Tabela 1" descreve a população. O código abaixo gera uma automaticamente.

```python
import pandas as pd
import numpy as np

# Dados simulados
np.random.seed(42)
n = 100
df = pd.DataFrame({
    'Idade': np.random.normal(60, 10, n),
    'Sexo': np.random.choice(['Masculino', 'Feminino'], n),
    'Grupo': np.random.choice(['Tratamento', 'Placebo'], n),
    'Sucesso': np.random.randint(0, 2, n)
})

# Função para gerar resumo formatado
def gerar_tabela_1(df, grupo_col):
    resumo = pd.DataFrame()
    colunas = [c for c in df.columns if c != grupo_col]
    
    for col in colunas:
        # Se for Numérico -> Média (SD)
        if pd.api.types.is_numeric_dtype(df[col]):
            grupo = df.groupby(grupo_col)[col].agg(['mean', 'std']).round(1)
            # Formata para "60.5 (10.2)"
            resumo[col] = grupo['mean'].astype(str) + " (" + grupo['std'].astype(str) + ")"
        
        # Se for Categórico -> N (%)
        else:
            # Pega a primeira categoria como exemplo (simplificado)
            # Em real Table 1, listariamos todas
            cat = df[col].unique()[0]
            grupo = df.groupby(grupo_col)[col].apply(lambda x: (x == cat).mean() * 100).round(1)
            resumo[f"{col} - {cat} (%)"] = grupo.astype(str) + "%"
            
    return resumo.T

tabela1 = gerar_tabela_1(df, 'Grupo')
print("--- Tabela 1: Características Basais ---")
print(tabela1)
# O output mostra Média (SD) ou % separado por grupo, pronto para colar no Word/LaTeX.
```

### Mensagem Final ao Mestre
Você agora tem um **Arsenal Completo**.
Desde a limpeza do dado bruto (Nível 4), passando pela descrição (Nível 1), inferência (Nível 2), modelagem complexa (Nível 3) até a síntese e escrita (Nível 5).
**Vá e faça ciência.**
