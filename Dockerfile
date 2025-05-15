# Use uma imagem base Python oficial
FROM python:3.11-slim-buster

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o arquivo de requirements para o container
COPY app/requirements.txt .

# Instale as dependências da aplicação
RUN pip install --no-cache-dir -r requirements.txt

# Copie todo o conteúdo da aplicação para o container
COPY app/ .

# Exponha a porta da aplicação (por padrão, o Uvicorn usa 8000)
EXPOSE 8000

# Comando para iniciar a aplicação FastAPI com Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
