# Base Image: Python 3.11 Slim (Leve e moderna)
FROM python:3.11-slim

# Evitar prompts durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependências de sistema para LaTeX/PDF
# texlive-xetex: Engine de PDF recomendada pelo Jupyter Book
# texlive-fonts-recommended: Fontes padrão
# texlive-plain-generic: Pacotes extras úteis
# pandoc: Conversor universal (obrigatório)
# graphviz: Para diagramas se houver
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-science \
    latexmk \
    fonts-freefont-ttf \
    fonts-freefont-otf \
    pandoc \
    graphviz \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurar diretório de trabalho
WORKDIR /book

# 3. Copiar requirements
COPY requirements.txt .

# 4. Instalar dependências Python
# Atualizamos pip e instalamos as libs do projeto
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. Comando padrão (pode ser sobrescrito)
# Por padrão, tenta construir o PDF
CMD ["jupyter-book", "build", ".", "--builder", "pdf"]
