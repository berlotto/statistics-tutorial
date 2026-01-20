.PHONY: help setup build serve clean

help:
	@echo "Comandos disponíveis:"
	@echo "  make setup    - Cria ambiente virtual e instala dependências com uv"
	@echo "  make build    - Constrói o livro localmente (sem baseurl quebrada)"
	@echo "  make serve    - Serve o livro em http://localhost:8000"
	@echo "  make clean    - Remove a pasta _build"

setup:
	uv venv
	uv pip install -r requirements.txt

build:
	uv run jupyter-book build .

buildpdf:
	mkdir -p pdf
	docker build -t jb-pdf .
	docker run --rm -v $(shell pwd):/book jb-pdf jupyter-book build . --builder pdflatex
	cp _build/latex/*.pdf pdf/
	@echo "PDF gerado com sucesso em: pdf/"

serve:
	python -m http.server 8000 --directory _build/html

clean:
	rm -rf _build
