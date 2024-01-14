#!/bin/bash

# Especifica o diretório onde as senhas do pass estão armazenadas
PASS_DIR="$HOME/.password-store"

# Cria um arquivo de texto vazio para armazenar as senhas exportadas
OUTPUT_FILE="senhas.txt"
> "$OUTPUT_FILE"

# Percorre o diretório de senhas do pass e extrai as senhas para o arquivo de texto
find "$PASS_DIR" -type f -name '*.gpg' | while read -r path; do
  nome=$(basename "$path" .gpg)
  senha=$(pass "$nome")
  echo "$nome: $senha" >> "$OUTPUT_FILE"
done

echo "Senhas exportadas para o arquivo $OUTPUT_FILE"
