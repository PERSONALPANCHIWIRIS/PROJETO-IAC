# PROJETO-IAC
Repositório para o projeto de IAC. 

# Descrição do Projeto

Este repositório contém a implementação do algoritmo K-Means Clustering em Assembly RISC-V. O objetivo do projeto foi implementar o algoritmo K-Means, que é um método de agrupamento de dados amplamente utilizado em machine learning. A implementação foi feita em Assembly RISC-V.
Este projeto foi desenvolvido em grupo.

O código está organizado em várias funções que realizam diferentes tarefas necessárias para a execução do algoritmo K-Means.

O algoritmo irá iterar até que os centroides não mudem mais ou até que o número máximo de iterações (L) seja atingido. Durante a execução, os pontos e os centroides serão exibidos na matriz LED.

# Otimizações

O código foi otimizado para reduzir o número de chamadas de funções e para garantir que as operações sejam realizadas de forma eficiente. Por exemplo:

    A função printClusters foi adaptada para pintar cada ponto diretamente com base no identificador do cluster, reduzindo a necessidade de múltiplas chamadas.

    A função calculateCentroids foi otimizada para calcular os centroides de forma mais eficiente, sem a necessidade de chamadas repetidas.
