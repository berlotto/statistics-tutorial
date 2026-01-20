# Estatística e Epidemiologia com Python

Este repositório contém um material de estudos com intúito de reunir aprendizados sobre estatística e epidemiologia, agregado de aplicação prática em Python.

## 📚 Sobre o Projeto

O material é dividido em 5 níveis, desde a análise descritiva básica até tópicos avançados como Estatística Bayesiana e Causalidade (DAGs).

## 🚀 Como Executar

Este projeto utiliza `jupyter-book` e `uv` (gerenciador de pacotes rápido) para build.

### Pré-requisitos
*   Python 3.9+
*   `uv` (Recomendado) ou `pip`

### Passo a Passo

1.  **Instalação das Dependências**
    ```bash
    make setup
    # Ou manualmente:
    # uv venv
    # uv pip install -r requirements.txt
    ```

2.  **Construir o Livro (HTML)**
    ```bash
    make build
    ```
    Isso gerará os arquivos estáticos na pasta `_build/html`.

3.  **Visualizar Localmente**
    ```bash
    make serve
    ```
    Acesse `http://localhost:8000` no seu navegador.

4.  **Limpar Build**
    ```bash
    make clean
    ```

## 🛠 Estrutura do Projeto

*   `01_iniciante/` a `05_topicos_especiais/`: Conteúdo do livro em Markdown/MyST.
*   `_toc.yml`: Estrutura do índice (Table of Contents).
*   `main-content.md`: Syllabus detalhado e objetivos de aprendizado.
*   `requirements.txt`: Dependências Python.

## 🤝 Contribuição
Sinta-se à vontade para abrir Issues ou Pull Requests para corrigir erros, sugerir novos tópicos ou melhorar os exemplos.


