# Guia e Syllabus Master: Estatística e Epidemiologia com Python

Este documento é a **espinha dorsal teórica e prática** do nosso material. Ele define não apenas a estrutura de arquivos, mas o **propósito pedagógico**, os **objetivos de aprendizado** e o **checklist de conteúdos** que *devem* estar presentes em cada tópico para garantir o nível de excelência exigido.

---

## 🟢 Nível 1: O Alicerce (Fundamentos e Descrição)
**Objetivo do Nível:** Capacitar o pesquisador a olhar para uma tabela de dados bruta e enxergar a realidade subjacente, compreendendo as limitações da coleta e descrevendo os fenômenos com precisão cirúrgica, sem cair em armadilhas de "médias mentirosas".

### 📂 01_fundamentos_amostragem
*Onde tudo começa. Se o dado é lixo, a estatística é lixo (GIGO).*

*   **[01_tipos_de_dados.md](./01_iniciante/01_fundamentos_amostragem/01_tipos_de_dados.md)**
    *   *Propósito:* Definir a ontologia das variáveis para saber qual teste aplicar no futuro.
    *   *Conteúdo Obrigatório:*
        *   [ ] Diferença entre dados e informação.
        *   [ ] Variáveis Qualitativas: Nominais (Dicotômicas vs Politômicas) e Ordinais (O perigo do Score Likert).
        *   [ ] Variáveis Quantitativas: Discretas (Contagens) vs Contínuas (Mensuração).
        *   [ ] Escalas de Medição: Nominal, Ordinal, Intervalar (Zero arbitrário) e Razão (Zero absoluto).
        *   [ ] Conversão de dados: Quando categorizar uma variável contínua é um erro grave.

*   **[02_tecnicas_amostragem.md](./01_iniciante/01_fundamentos_amostragem/02_tecnicas_amostragem.md)**
    *   *Propósito:* Garantir representatividade e valildade externa.
    *   *Conteúdo Obrigatório:*
        *   [ ] População vs Amostra (Censo é utopia?).
        *   [ ] Amostragem Probabilística: Aleatória Simples, Sistemática, Estratificada (proporcional) e Conglomerados.
        *   [ ] Amostragem Não-Probabilística (e seus riscos): Conveniência, Bola de Neve, Quotas.
        *   [ ] Viés de Seleção: O caso clássico do *Survivor Bias*.

*   **[03_conceito_tamanho_amostral.md](./01_iniciante/01_fundamentos_amostragem/03_conceito_tamanho_amostral.md)**
    *   *Propósito:* Criar a intuição de convergência antes das fórmulas pesadas.
    *   *Conteúdo Obrigatório:*
        *   [ ] A Lei dos Grandes Números.
        *   [ ] Por que "Big Data" enviesado não serve.
        *   [ ] Simulação de estabilização da média.

### 📂 02_estatistica_descritiva
*Resumindo a informação sem perder a essência.*

*   **[01_medidas_posicao.md](./01_iniciante/02_estatistica_descritiva/01_medidas_posicao.md)**
    *   *Propósito:* Encontrar o "centro" dos dados.
    *   *Conteúdo Obrigatório:*
        *   [ ] Média Aritmética e a sensibilidade a outliers.
        *   [ ] Mediana: O centro robusto.
        *   [ ] Moda: Unimodal, Bimodal e Amodal.
        *   [ ] Média Ponderada e Média Geométrica (Taxas de crescimento).
        *   [ ] Quando usar qual? (Assimetria da distribuição decide).

*   **[02_medidas_dispersao.md](./01_iniciante/02_estatistica_descritiva/02_medidas_dispersao.md)**
    *   *Propósito:* Mensurar a incerteza e a variabilidade. Média sem desvio padrão é informação nula.
    *   *Conteúdo Obrigatório:*
        *   [ ] Amplitude Total e Intervalo Interquartil (IQR).
        *   [ ] Variância: A matemática dos quadrados (População $N$ vs Amostra $n-1$).
        *   [ ] Desvio Padrão: A métrica na unidade original.
        *   [ ] Coeficiente de Variação (CV): Comparando variabilidade entre bananas e laranjas.

### 📂 03_visualizacao_dados
*A análise exploratória como ferramenta de diagnóstico.*

*   **[01_distribuicao_frequencia.md](./01_iniciante/03_visualizacao_dados/01_distribuicao_frequencia.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Tabela de Frequências (Absoluta, Relativa, Acumulada).
        *   [ ] Histograma: Escolha de *bins* (Regra de Sturges/Freedman-Diaconis).
        *   [ ] KDE (Kernel Density Estimation): Suavizando o histograma.
        *   [ ] Assimetria (*Skewness*) e Curtose: O que a cauda diz sobre os eventos raros.

*   **[02_boxplot_outliers.md](./01_iniciante/03_visualizacao_dados/02_boxplot_outliers.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Anatomia do Boxplot (Quartis, Mediana, Whiskers).
        *   [ ] Detectando Outliers: Método do Tukey ($1.5 \times IQR$) vs Z-Score ($>3\sigma$).
        *   [ ] Violin Plot: Boxplot + KDE (O melhor dos dois mundos).

### 📂 04_probabilidade_basica
*A linguagem da incerteza.*

*   **[01_conceitos_probabilidade.md](./01_iniciante/04_probabilidade_basica/01_conceitos_probabilidade.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Espaço Amostral e Eventos.
        *   [ ] Probabilidade Condicional: $P(A|B)$.
        *   [ ] Teorema de Bayes: A intuição de atualizar crenças (Exemplos médicos de falso positivo).

*   **[02_distribuicoes_discretas.md](./01_iniciante/04_probabilidade_basica/02_distribuicoes_discretas.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Bernoulli e Binomial: Sucesso/Fracasso.
        *   [ ] Poisson: Eventos raros em intervalo de tempo/espaço (Lambda $\lambda$).

*   **[03_distribuicoes_continuas.md](./01_iniciante/04_probabilidade_basica/03_distribuicoes_continuas.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Distribuição Normal: Propriedades (68-95-99.7).
        *   [ ] Padronização Z-Score: Colocando tudo na mesma régua.
        *   [ ] Distribuição T-Student: Caudas grossas para amostras pequenas.

---

## 🟡 Nível 2: Inferência Estatística Fundamental
**Objetivo do Nível:** Sair da descrição da amostra e fazer afirmações sobre a população com margem de erro controlada. Aprender a duvidar dos dados (Testes de Hipótese) e validar se as ferramentas funcionam (Premissas).

### 📂 05_teorema_limite_central
*O milagre estatístico que permite a inferência.*

*   **[01_distribuicao_amostral.md](./02_intermediario/05_teorema_limite_central/01_distribuicao_amostral.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] A Lei dos Grandes Números.
        *   [ ] O Teorema Central do Limite (TLC): Por que tudo converge para a Normal?
        *   [ ] Erro Padrão da Média (SEM) vs Desvio Padrão (SD).

*   **[02_intervalos_confianca.md](./02_intermediario/05_teorema_limite_central/02_intervalos_confianca.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] O que significa "95% de Confiança"? (Não é o que a maioria pensa).
        *   [ ] Cálculo de IC para Média (Z vs T).
        *   [ ] Bootstrap: ICs para qualquer estatística via simulação computacional.

### 📂 06_validacao_premissas
*A etapa ignorada pela maioria, mas essencial para o rigor.*

*   **[01_testes_normalidade.md](./02_intermediario/06_validacao_premissas/01_testes_normalidade.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Inspeção Visual: Histograma e Q-Q Plot (Quantile-Quantile).
        *   [ ] Testes Formais: Shapiro-Wilk (Pequenos N) e Kolmogorov-Smirnov.
        *   [ ] O problema dos testes de normalidade em grandes amostras.

*   **[02_homocedasticidade.md](./02_intermediario/06_validacao_premissas/02_homocedasticidade.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] O conceito de Homogeneidade de Variâncias.
        *   [ ] Teste de Levene (Robusto) vs Bartlett (Sensível).

### 📂 07_comparacao_grupos
*Existe diferença real ou foi sorte?*

*   **[01_teste_t_mann_whitney.md](./02_intermediario/07_comparacao_grupos/01_teste_t_mann_whitney.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Teste T de Student (Independentes vs Pareados).
        *   [ ] O "Plano B": Teste de Mann-Whitney U e Wilcoxon (Não-Paramétricos).
        *   [ ] Tamanho de Efeito: d de Cohen (Não basta o p-valor).

*   **[02_anova_kruskal.md](./02_intermediario/07_comparacao_grupos/02_anova_kruskal.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] A lógica da ANOVA (Análise de Variância para comparar Médias).
        *   [ ] Kruskal-Wallis: ANOVA nos ranks.
        *   [ ] Testes Post-Hoc: Onde está a diferença? (Tukey HSD vs Bonferroni).

### 📂 08_poder_amostra (RECUPERADO)
*Planejamento experimental vital.*

*   **[01_calculo_amostral.md](./02_intermediario/08_poder_amostra/01_calculo_amostral.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Parâmetros: Nível de Confiança, Margem de Erro e Variabilidade.
        *   [ ] Fórmulas para Estimação de Média e Proporção.
        *   [ ] Bibliotecas Python para Sample Size (`statsmodels`).

*   **[02_poder_teste.md](./02_intermediario/08_poder_amostra/02_poder_teste.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Erro Tipo I ($\alpha$) e Erro Tipo II ($\beta$).
        *   [ ] Poder ($1 - \beta$): A chance de detectar um efeito que existe.
        *   [ ] Curvas de Poder vs Tamanho da Amostra.

### 📂 09_associacao_correlacao
*   **[01_correlacao.md](./02_intermediario/09_associacao_correlacao/01_correlacao.md)**
    *   *Conteúdo:* Pearson (Linear) vs Spearman (Monotônica/Ranks). O perigo da correlação espúria.
*   **[02_chi_quadrado.md](./02_intermediario/09_associacao_correlacao/02_chi_quadrado.md)**
    *   *Conteúdo:* Teste de Independência $\chi^2$, Resíduos Padronizados e Teste Exato de Fisher.

---

## 🔴 Nível 3: Modelagem Estatística e Preditiva
**Objetivo do Nível:** Construir modelos matemáticos que expliquem a relação entre variáveis ("x explica y") e permitam previsões, controlando para fatores de confusão.

### 📂 10_regressao_linear
*   **[01_regressao_simples.md](./03_modelagem/10_regressao_linear/01_regressao_simples.md)**
    *   *Conteúdo:* OLS, Betas, Interpretação, $R^2$ e $R^2$ Ajustado.
*   **[02_regressao_multipla_diagnostico.md](./03_modelagem/10_regressao_linear/02_regressao_multipla_diagnostico.md)**
    *   *Conteúdo:*
        *   [ ] Variáveis Dummy (Categóricas na regressão).
        *   [ ] **Interações:** Quando o efeito de X depende de Z.
        *   [ ] Verificação de pressupostos: Linearidade, Normalidade dos Resíduos, Homocedasticidade e Ausência de Multicolinearidade (VIF).

### 📂 11_regressao_logistica
*   **[01_logistica_binaria.md](./03_modelagem/11_regressao_logistica/01_logistica_binaria.md)**
    *   *Conteúdo:* Modelando probabilidades. A função Logit. Interpretação de Odds Ratio.
*   **[02_performance_classificacao.md](./03_modelagem/11_regressao_logistica/02_performance_classificacao.md)**
    *   *Conteúdo:* Matriz de Confusão, Sensibilidade/Recall, Especificidade, Curva ROC e AUC. Ponto de corte ótimo (Youden).

### 📂 12_modelos_generalizados_glm
*Indo além do Normal.*

*   **[01_poisson_binomial_negativa.md](./03_modelagem/12_modelos_generalizados_glm/01_poisson_binomial_negativa.md)**
    *   *Conteúdo:*
        *   [ ] Regressão de Poisson para contagens (Taxas de incidência).
        *   [ ] Superdispersão: Quando a variância excede a média.
        *   [ ] Regressão Binomial Negativa como solução.
        *   [ ] Modelos Zero-Inflated (ZIP) - Breve introdução.

### 📂 13_selecao_modelos
*   **[01_aic_bic_stepwise.md](./03_modelagem/13_selecao_modelos/01_aic_bic_stepwise.md)**
    *   *Conteúdo:* Critérios de Informação (AIC, BIC). O perigo do Stepwise. Introdução a Regularização (Lasso/Ridge) como seleção moderna.

---

## 🟣 Nível 4: Epidemiologia, Causalidade e Dados Complexos
**Objetivo do Nível:** Abordar a complexidade do mundo real: o tempo até um evento, a causalidade não-linear e a limpeza de dados sujos.

### 📂 14_tratamento_dados (RECUPERADO)
*Antes de modelar, é preciso limpar.*

*   **[01_missing_data.md](./04_avancado_epidemiologia/14_tratamento_dados/01_missing_data.md)**
    *   *Conteúdo Obrigatório:*
        *   [ ] Tipos de Missing: MCAR, MAR, MNAR (O mais perigoso).
        *   [ ] Análise de padrão de perda (Visualização `missingno`).
        *   [ ] Métodos de imputação: Simples (Média/Mediana) vs Múltipla (MICE/KNN).

### 📂 15_causalidade_dags
*   **[01_dags_inferencia_causal.md](./04_avancado_epidemiologia/15_causalidade_dags/01_dags_inferencia_causal.md)**
    *   *Conteúdo:* Diagramas Causais (DAGs). Caminhos "Backdoor". O que é um Collider e por que não controlar por ele.

### 📂 16_analise_sobrevivencia
*   **[01_kaplan_meier_logrank.md](./04_avancado_epidemiologia/16_analise_sobrevivencia/01_kaplan_meier_logrank.md)**
    *   *Conteúdo:* Dados censurados. Curva de Kaplan-Meier. Comparação de curvas (Log-Rank).
*   **[02_cox_regression.md](./04_avancado_epidemiologia/16_analise_sobrevivencia/02_cox_regression.md)**
    *   *Conteúdo:* Cox Proportional Hazards. Hazard Ratio (HR). Verificação da premissa de proporcionalidade.

### 📂 17_medidas_epidemiologicas
*   **[01_risco_odds_prevalencia.md](./04_avancado_epidemiologia/17_medidas_epidemiologicas/01_risco_odds_prevalencia.md)**
    *   *Conteúdo:* Prevalência vs Incidência. Risco Relativo (Estudos de Coorte) vs Odds Ratio (Caso-Controle).

---

## ⚫ Nível 5: Tópicos Especiais
*Ferramentas para dúvidas específicas.*

### 📂 18_multivariada_nao_supervisionada
*   **[01_pca_clustering.md](./05_topicos_especiais/18_multivariada_nao_supervisionada/01_pca_clustering.md)**
    *   *Conteúdo:* PCA para reduzir variáveis correlacionadas. K-Means para segmentar grupos.

### 📂 19_meta_analise
*   **[01_introducao_meta_analise.md](./05_topicos_especiais/19_meta_analise/01_introducao_meta_analise.md)**
    *   *Conteúdo:* Forest Plot. Medida Sumarizada. Heterogeneidade ($I^2$). Bias de publicação (Funnel Plot).

### 📂 20_reporte_cientifico
*   **[01_escrita_resultados.md](./05_topicos_especiais/20_reporte_cientifico/01_escrita_resultados.md)**
    *   *Conteúdo:* Como narrar os resultados estatísticos em papers. A importância do "p-valor exato" e ICs. Reprodutibilidade.