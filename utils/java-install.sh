#!/bin/bash

# Passo 1: Atualizar pacotes
echo "Atualizando pacotes do sistema..."
sudo apt update -y && sudo apt upgrade -y

# Passo 2: Instalar Java 17
echo "Instalando o Java 17..."
sudo apt install openjdk-17-jdk -y

# Passo 3: Verificar a instalação do Java 17
echo "Verificando instalação do Java..."
java -version

# Passo 4: Configurar JAVA_HOME
echo "Configurando a variável JAVA_HOME..."
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "JAVA_HOME=$JAVA_HOME" | sudo tee -a /etc/environment

# Passo 5: Instalar Gradle
echo "Instalando o Gradle..."
sudo apt install wget unzip -y
wget https://services.gradle.org/distributions/gradle-8.10.2-bin.zip
unzip gradle-8.10.2-bin.zip
sudo mv gradle-8.10.2 /opt/gradle
echo "export GRADLE_HOME=/opt/gradle" | sudo tee -a /etc/environment
echo "export PATH=\$PATH:/opt/gradle/bin" | sudo tee -a /etc/environment

# Passo 6: Recarregar o ambiente
echo "Recarregando o ambiente..."
source /etc/environment

# Passo 7: Verificar instalação do Gradle
echo "Verificando instalação do Gradle..."
gradle -v

echo "Configuração do ambiente concluída com sucesso!"
