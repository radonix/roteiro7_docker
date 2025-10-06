# Stage 1: builder (Stage de Configuração)
# Utilizada para instalar o git e criar o arquivo de configuração (.gitconfig)
# que contém a informação do usuário e o token.
FROM <SUA IMAGEM BASE>:<SUA TAG> as builder

# Argumento de compilação para receber o token do git.
# Esta variável só existirá nesta stage.
ARG GIT_TOKEN

# Instala o git.
RUN apt-get update && apt-get install -y git

# Configura o nome do usuário e, crucialmente, o token no arquivo .gitconfig
# O gitconfig é criado no diretório raiz (/root/) por padrão.
RUN git config --global user.name "usuario_test"
RUN git config --global user.token ${GIT_TOKEN}

# -------------------------------------------------------------------

# Stage 2: final (Stage Final)
# Imagem limpa que será usada pela aplicação.
FROM <SUA IMAGEM BASE>:<SUA TAG>

# Instala o git novamente na imagem final, pois ela é uma nova imagem.
RUN apt-get update && apt-get install -y git

# COPIA o arquivo de configuração (.gitconfig) *já criado* na stage 'builder'
# e o transfere para a stage final. A cópia de um arquivo é segura.
# A variável GIT_TOKEN não é copiada, nem aparece no histórico de camadas desta stage.
COPY --from=builder /root/.gitconfig /root/.gitconfig