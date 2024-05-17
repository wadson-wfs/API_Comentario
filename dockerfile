# Imagem base leve do Python
FROM python:3.8-slim

# Diretório de trabalho na imagem
WORKDIR /app

# Copia os arquivos necessários para o diretório de trabalho na imagem
COPY requirements.txt /app
COPY api.py /app

# Instala as dependências da aplicação
RUN pip3 install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Expõe a porta em que a aplicação estará escutando
EXPOSE 5000

# Comando para executar a aplicação quando o contêiner for iniciado
CMD ["gunicorn", "api:app", "--log-level", "debug", "-b", "0.0.0.0:5000"]
