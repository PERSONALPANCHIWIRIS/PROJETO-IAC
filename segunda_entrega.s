#
# IAC 2023/2024 k-means
# 
# Grupo: 58
# Campus: Alameda
#
# Autores:
# ist1109625, Francisco Pestana
# ist1107357, Andreia Andrade
# ist1109695, Miguel Ribeiro
#
# Tecnico/ULisboa


# ALGUMA INFORMACAO ADICIONAL PARA CADA GRUPO:
# - A "LED matrix" deve ter um tamanho de 32 x 32
# - O input e' definido na seccao .data. 
# - Abaixo propomos alguns inputs possiveis. Para usar um dos inputs propostos, basta descomentar 
#   esse e comentar os restantes.
# - Encorajamos cada grupo a inventar e experimentar outros inputs.
# - Os vetores points e centroids estao na forma x0, y0, x1, y1, ...


# Variaveis em memoria
.data

#Input A - linha inclinada
n_points:    .word 9
points:      .word 0,0, 1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7 8,8

#Input B - Cruz
#n_points:    .word 5
#points:     .word 4,2, 5,1, 5,2, 5,3 6,2

#Input C
#n_points:    .word 23
#points: .word 0,0, 0,1, 0,2, 1,0, 1,1, 1,2, 1,3, 2,0, 2,1, 5,3, 6,2, 6,3, 6,4, 7,2, 7,3, 6,8, 6,9, 7,8, 8,7, 8,8, 8,9, 9,7, 9,8

#Input D
#n_points:    .word 30
#points:      .word 16, 1, 17, 2, 18, 6, 20, 3, 21, 1, 17, 4, 21, 7, 16, 4, 21, 6, 19, 6, 4, 24, 6, 24, 8, 23, 6, 26, 6, 26, 6, 23, 8, 25, 7, 26, 7, 20, 4, 21, 4, 10, 2, 10, 3, 11, 2, 12, 4, 13, 4, 9, 4, 9, 3, 8, 0, 10, 4, 10



# Valores de centroids e k a usar na 1a parte do projeto:
centroids:   .word 0,0
k:           .word 1

# Valores de centroids, k e L a usar na 2a parte do prejeto:
#centroids:   .word 0,0, 10,0, 0,10
#k:           .word 3
#L:           .word 10

# Abaixo devem ser declarados o vetor clusters (2a parte) e outras estruturas de dados
# que o grupo considere necessarias para a solucao:
#clusters:    




#Definicoes de cores a usar no projeto 

colors:      .word 0xff0000, 0x00ff00, 0x0000ff  # Cores dos pontos do cluster 0, 1, 2, etc.

.equ         black      0
.equ         white      0xffffff



# Codigo
 
.text
    # Chama funcao principal da 1a parte do projeto
    jal mainSingleCluster

    # Descomentar na 2a parte do projeto:
    #jal mainKMeans
    
    #Termina o programa (chamando chamada sistema)
    li a7, 10
    ecall


### printPoint
# Pinta o ponto (x,y) na LED matrix com a cor passada por argumento
# Nota: a implementacao desta funcao ja' e' fornecida pelos docentes
# E' uma funcao auxiliar que deve ser chamada pelas funcoes seguintes que pintam a LED matrix.
# Argumentos:
# a0: x
# a1: y
# a2: cor

printPoint:
    li a3, LED_MATRIX_0_HEIGHT
    sub a1, a3, a1
    addi a1, a1, -1
    li a3, LED_MATRIX_0_WIDTH
    mul a3, a3, a1
    add a3, a3, a0
    slli a3, a3, 2
    li a0, LED_MATRIX_0_BASE
    add a3, a3, a0   # addr
    sw a2, 0(a3)
    jr ra
    
###mudar_k
#muda o valor do k a k=1
mudar_k:
    j if_mudar_k #ira verificar a condicao
    resto:
    	addi sp, sp, -4 #Aloca espa?o para a pilha
    	sw a0, 0(sp) #guarda o valor do registo a0
    	la a0, k #o endere?o de k fica no registo a0
        sw t1, 0(a0) #Guarda o valor 1 em k
        lw a0, 0(sp)
        addi sp, sp, 4 #recupera os dados e fecha a pilha
        jr ra #volta a chamada da funcao
        
    if_mudar_k:
    bne, t0, t1, resto #se k nao e igual a 1
    jr ra

### cleanScreen
# Limpa todos os pontos do ecr?
# Argumentos: nenhum
# Retorno: nenhum

cleanScreen:
    li t0, 33 #fora do limite
    li t1, 0 #
    lw a2, white #guarda a cor branca em a2
    addi sp, sp, -4 #aloca espaco na pilha
    sw ra, 0(sp) #guarda o registo de retorno
    ciclo1:
        #volta a inicializar os valores na coluna
        li t2, 0
    ciclo2:
        mv a1, t2
        mv a0, t1 #inicializa as variaveis para printPoint
        jal printPoint
        addi t2, t2, 1 #itera para a seguinte linha
        bne t2, t0, ciclo2 #limpa os pontos numa coluna
        addi t1, t1, 1 #j? foi uma coluna "apagada"
        bne t1, t0, ciclo1 #itera para a proxima coluna

    lw ra, 0(sp)
    addi sp, sp, 4   
    jr ra #retorna ao ponto de chamada

    
### printClusters
# Pinta os agrupamentos na LED matrix com a cor correspondente.
# Argumentos: nenhum
# Retorno: nenhum

printClusters:
    # POR IMPLEMENTAR (1a e 2a parte)
    lw t0, n_points # Numero de pontos e carregado para t0
    la t1, points # Enderco da lista dos pontos e carregado para t1
    la t2, colors # Enderco da lista das cores dos pontos e carregado para t2
    lw a2, 0(t2) # Carrega o primeiro elemento da lista das cores para a2
    addi sp, sp, -4 # Aloca espaco na pilha para armazenar o endereco de retorno 
    sw ra, 0(sp) # Guarda o endere?o de retorno 
    forClusters:  # Inicio do ciclo que faz print dos clusters
        lw a0, 0(t1) #X
        addi t1, t1, 4 # Avanca para a posicao seguinte na lista
        lw a1, 0(t1) #Y
        jal printPoint  # Chama a funcao printPoint para dar print dos pontos
        addi t1, t1, 4 # Avanca para o ponto seguinte
        addi t0, t0, -1 # Menos um ponto
        bgt t0, x0, forClusters #continua o ciclo
        lw ra, 0(sp) #restaura o valor do endere?o de retorno
        addi sp, sp, 4 #fecha a pilha
    jr ra


### printCentroids
# Pinta os centroides na LED matrix
# Nota: deve ser usada a cor preta (black) para todos os centroides
# Argumentos: nenhum
# Retorno: nenhum

printCentroids:
    # POR IMPLEMENTAR (1a e 2a parte)
    li t0, 1 #numero de centroids
    la t1, centroids # Coloca o array de centroides em t1
    lw a2, black # Carrega preto para a2
    addi sp, sp, -4 #aloca espa?o
    sw ra, 0(sp) #guarda o endereco de retorno
    for_centroids:
        lw a0, 0(t1) #X
        addi t1, t1, 4 # Avanca para a posicao seguinte na lista
        lw a1, 0(t1) #Y
        jal printPoint #chama a funcao auxiliar 
        addi t1, t1, 4 # Avanca para o centroide seguinte
        addi t0, t0, -1  # Retira 1 a contagem de centroides
        bgt t0, x0, forClusters #continua o ciclo
        lw ra, 0(sp) #restaura o endereco de retorno
        addi sp, sp, 4 #fecha a pilha
    jr ra
    

### calculateCentroids
# Calcula os k centroides, a partir da distribuicao atual de pontos associados a cada agrupamento (cluster)
# Argumentos: nenhum
# Retorno: nenhum

calculateCentroids:
    # POR IMPLEMENTAR (1a e 2a parte)
    lw a0, n_points # Carrega numero de pontos para a0
    la a1, points  # Carrega a lista de pontos para a1
    li t0, 0 #soma X
    li t1, 0 #soma Y
    mv t2, a0
    for_calcula_centroid: #loop para calcular os centroides
        lw s0, 0(a1) # Carrega a coordenda X do ponto atual para s0
        add t0, t0, s0 #adiciona ao somatorio X
        lw s0, 4(a1) # Carrega a coordenda Y do ponto atual para s0
        add t1, t1, s0 #adiciona ao somatorio Y
        addi a1, a1, 8 # Avan?a para o ponto seguinte da lista
        addi t2, t2, -1 # menos um ponto
        bgt t2, x0, for_calcula_centroid # Se ainda houver pontos por calucular continua o ciclo
        la a1, centroids #sera alterada na memoria a lista de centroids
        div t0, t0, a0 # (media de X)
        sw t0, 0(a1) #guarda na coordenada X do centroid
        div t1, t1, a0 # (media de Y)
        sw t1, 4(a1) # guarda na coordenada Y do centroid
    jr ra #retorna


### mainSingleCluster
# Funcao principal da 1a parte do projeto.
# Argumentos: nenhum
# Retorno: nenhum

mainSingleCluster:

    #1. Coloca k=1 (caso nao esteja a 1)
    lw t0, k  # Carrega o valor de k para t0
    li, t1, 1 #registo t1 fica com o valor 1
    addi sp, sp, -4 #Aloca memoria na pilha
    sw ra, 0(sp) # guarda o endere?o de retorno
    jal mudar_k #chama a funcao auxiliar
    lw ra, 0(sp) # Restaura o endereco de retorno
    addi sp, sp, 4 # Desaloca espaco na pilha
 
    #2. cleanScreen
    addi sp, sp, -16  # Aloca espaco na pilha
    sw ra, 0(sp)
    sw a2, 4(sp)# guarda na pilha todos os valores
    sw a0, 8(sp)#que serao utilizados na funcao clean
    sw a1, 12(sp)
    jal cleanScreen # Chama a fun??o cleanScrean para limpar a tela
    lw ra, 0(sp) # Restaura os valores guardados na pilha
    lw a2, 4(sp)
    lw a0, 8(sp)
    lw a1, 12(sp)
    addi sp, sp, 16 #"fecha" a pilha

    #3. printClusters
    addi sp, sp, -16 # Aloca espaco na pilha
    sw ra, 0(sp)
    sw a2, 4(sp)# guarda na pilha os valores iniciais
    sw a0, 8(sp)# a ser utilizados na funcao printClusters
    sw a1, 12(sp)
    jal printClusters  # Chama a fun??o printClusters para dar print aos clusters
    lw ra, 0(sp)
    lw a2, 4(sp)
    lw a0, 8(sp)
    lw a1, 12(sp)#recupera os valores guardados na pilha
    addi sp, sp, 16 #desaloca memoria na pilha
    

    #4. calculateCentroids
    addi sp, sp, -16 # Aloca espaco na pilha
    sw ra, 0(sp)
    sw a0, 4(sp) #guarda na pilha os valores iniciais
    sw a1, 8(sp) # a ser utilizados na funcao calculateCentroids
    sw a2, 12(sp)
    jal calculateCentroids # chama a funcao
    lw a2, 12(sp)
    lw a1, 8(sp)
    lw a0, 4(sp)
    lw ra, 0(sp) # Restaura os valores iniciais
    addi sp, sp, 16 # Desaloca espaco na pilha
    
    #5. printCentroids
    addi sp, sp, -16 #Aloca espaco
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)# guarda todos os valores iniciais dos registos
    sw a2, 12(sp)# a ser manipulados pela funcao
    jal printCentroids # Chama a fun??o printCentroids para dar print aos centroides
    lw a2, 12(sp)
    lw a1, 8(sp)
    lw a0, 4(sp)
    lw ra, 0(sp) # Restaura todos os valores
    addi sp, sp, 16  # Desaloca espaco na pilha
    
    #6. Termina
    jr ra



### manhattanDistance
# Calcula a distancia de Manhattan entre (x0,y0) e (x1,y1)
# Argumentos:
# a0, a1: x0, y0
# a2, a3: x1, y1
# Retorno:
# a0: distance

manhattanDistance:
    # POR IMPLEMENTAR (2a parte)
    sub t0, a0, a2 # x0 - y0
    bgtz t0, x_maior
    neg t0, t0
    
    x_maior:
    sub t1, a1, a3 # x1 - y1
    bgtz t1, y_maior
    neg t1, t1
    
    y_maior:
    add a0, t0, t1
    nop
    jr ra


### nearestCluster
# Determina o centroide mais perto de um dado ponto (x,y).
# Argumentos:
# a0, a1: (x, y) point
# Retorno:
# a0: cluster index

nearestCluster:
    # POR IMPLEMENTAR (2a parte)
    la a5, centroids
    addi sp, sp, -4
    sw ra, 0(sp) #guarda o endere?o de retorno anterior
    li t1, 0 #t1 ir? guardar o indice da menor distancia
    la t3, k #carrega o endere?o de k para t3
    lw t2, 0(t3) #numero de centroids
    li t3, 0 #t3 funciona como o endere?o do centroid
    li t6, 70 #iniciliza t6 com uma distancia superior ? maior distancia possivel
    for_nearestC:
        lw a2, 0(a5)
        lw a3, 4(a5) #inicializa as coordenadas do centroid
        addi sp, sp, -8 #aloca memoria na pilha
        sw a0, 0(sp) #guarda o valor de a0 (X)
        sw t1, 4(sp) #guarda o t1, dado que ser? alterado en manhattanDistance
        jal manhattanDistance
        blt a0, t6, save_Distance #caso encontre uma nova distancia menor ? anteiror, guarda-a
        lw a0, 0(sp) #recupera o valor do a0 (X)
        lw t1, 4(sp) #recupera o valor de t1 (indice da menor distancia)
        addi sp, sp, 8 #desaloca memoria
        addi a5, a5, 8
        addi t3, t3, 1
        blt t3, t2, for_nearestC #se ainda existem centroids continua o ciclo
        mv a0, t1 #caso terminal, guarda o endere?o em a0
        lw ra, 0(sp) #recupera o endere?o de retorno
        addi sp, sp, 4 #desaloca memoria na pilha
        jr ra
        save_Distance:
            mv t6, a0 #t6 fica com a nova distancia
            lw a0, 0(sp) 
            lw t1, 4(sp)#recupera os valores
            addi sp, sp, 8 #recupera o valor do a0 e desaloca memoria
            mv t1, t3 #o indice do centroid mais perto ? guardado
            addi a5, a5, 8 #itera para o proximo centroid
            addi t3, t3, 1 #indice seguinte
            blt t3, t2, for_nearestC
            mv a0, t1 #caso terminal
            lw ra, 0(sp) #recupera o endere?o de retorno
            addi sp, sp, 4 #desaloca memoria na pilha
            jr ra


### mainKMeans
# Executa o algoritmo *k-means*.
# Argumentos: nenhum
# Retorno: nenhum

mainKMeans:  
    # POR IMPLEMENTAR (2a parte)
    jr ra
