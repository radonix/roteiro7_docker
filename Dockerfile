# Stage 1: builder (Stage de Configuração)
# Usando 'ubuntu:latest' como a imagem base.
FROM ubuntu:latest as builder

# Argumento de compilação para receber o token do git.
ARG GIT_TOKEN

# Instala o git.
RUN apt-get update && apt-get install -y git

# Configura o nome do usuário e o token no arquivo .gitconfig.
RUN git config --global user.name "usuario_test"
RUN git config --global user.token ${GIT_TOKEN}

# -------------------------------------------------------------------

# Stage 2: final (Stage Final)
# Também usando 'ubuntu:latest' (mantendo a mesma imagem, mas sem o histórico da Stage 1).
FROM ubuntu:latest

# Instala o git novamente na imagem final, pois ela é uma nova imagem.
RUN apt-get update && apt-get install -y git

# COPIA o arquivo de configuração (.gitconfig) da stage 'builder' para a stage final.
# Isso garante que o token, que está dentro do .gitconfig, seja transferido
# sem expor o comando 'RUN' com a variável GIT_TOKEN no histórico da imagem final.
COPY --from=builder /root/.gitconfig /root/.gitconfig