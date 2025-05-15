# Use uma imagem base Python oficial
FROM python:3.11-slim-buster

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o arquivo de requirements para o container
COPY app/requirements.txt .

# Instale as dependências da aplicação
RUN pip install --no-cache-dir -r app/requirements.txt

# Copie o código da sua aplicação para o container
COPY . .

# Defina a variável de ambiente para o uvicorn (se necessário)
# ENV UVICORN_HOST="0.0.0.0"
# ENV UVICORN_PORT="80"

# Exponha a porta em que sua aplicação FastAPI estará rodando
EXPOSE 8000

# Defina o comando para executar a aplicação usando Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
