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

serve:
	python -m http.server 8000 --directory _build/html

clean:
	rm -rf _build
