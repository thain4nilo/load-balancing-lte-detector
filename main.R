## Detecção de oportunidades de balanceamento de carga entre células LTE #####
## Autora: Thainá Nilo

#### importar bibliotecas ####################################################
library(dplyr)
library(stringr)



#### ler dados ###############################################################
#base de informações da Célula: Station ID, Azimute, Largura de Banda
Cadastro <- readxl::read_excel("amostrabase.xlsx") 
#base de Células com informações dos KPIs de Performance na 2ª HMM do dia durante uma semana
Celulas2Hmm <- readxl::read_excel("amostraCelulasHmm.xlsx") 



#### Limpeza de dados ########################################################
# Para a publicação deste projeto no repositório, foi suprimida a etapas de limpeza dos dados.



#### Manipulação #############################################################

# Concentrando todas as informações das células em uma mesma base para facilitar as próximas etapas.
PerformanceCelulas <- merge(Celulas2Hmm, Cadastro)

# Definindo a performance das células em: NOK (Alta ocupação) e OK (Dentro da performance normal)
PerformanceCelulas <- PerformanceCelulas %>%
  mutate(#Limiar PRB
         LIMIAR_PRB = case_when(PRB_UTIL_MEAN_DL > 70 ~ "PRB"), 
         #Limiar User por BW 
         LIMIAR_USER = case_when( 
           (  (BW_MHz == 5 & USERS_RRC_CONN_MEAN_AVG > 25) |
              (BW_MHz == 10 & USERS_RRC_CONN_MEAN_AVG > 50) |
              (BW_MHz == 15 & USERS_RRC_CONN_MEAN_AVG > 75) |
              (BW_MHz == 20 & USERS_RRC_CONN_MEAN_AVG > 100) |
              (BW_MHz == 25 & USERS_RRC_CONN_MEAN_AVG > 125)) ~ "USER"),
         LIMIAR_TPUT = case_when(THROU_USER_PDCP_DL < 5000 ~ "TPUT")) %>%
  tidyr::unite("INDICADOR",c("LIMIAR_PRB","LIMIAR_USER","LIMIAR_TPUT"), sep = "/", na.rm = TRUE, remove = TRUE) %>%
  mutate(PERFORMANCE_DIA = case_when(INDICADOR == "" ~ "OK",
                                   TRUE ~ "NOK"))

# Para definir de fato se a célula apresenta de forma recorrente um comportamento de alta ocupação
# é verificado quantos dias esta ficou NOK.
# caso Qntd de dias >= 4, então é considerada CRITICA,
# caso Qntd de dias esteja entre 4 e 1, é considerada ALERTA,
# caso Qntd de dias <= 1, é considerada NORMAL.
ClassificacaoCelulas <- PerformanceCelulas %>% filter(PERFORMANCE_DIA == "NOK") %>%
  group_by(CELL_ID) %>%
  summarise(QNTD_NOK = n()) %>%
  mutate(CLASSIFICACAO = case_when(QNTD_NOK >= 4 ~ "CRITICO",
                                   QNTD_NOK <= 1 ~ "NORMAL",
                                   TRUE ~ "ALERTA")) %>%
  select(CELL_ID,CLASSIFICACAO)

# Formatar e compilar quais os indicadores foram responsáveis por definir a anormalidade das celulas
IndicadoresFora <- BaseCelulas %>%
  group_by(CELL_ID,INDICADOR) %>%
  summarise(QNTD = n() ) %>%
  filter(INDICADOR != "") %>%
  mutate(INDICADORES = paste(INDICADOR,collapse = "/")) %>%  #juntar indicadores que sairam em dias diferentes
  select(-INDICADOR,-QNTD) %>%
  unique.data.frame() %>% #retirar linhas de células duplicatas
  mutate(INDICADOR = paste(unique(unlist(str_split(INDICADORES,fixed('/')), use.names = FALSE)),collapse = "/")) %>% #retirar duplicatas no caracter de indicadores 
  select(CELL_ID,INDICADOR)


# Construção de uma base simplificada com apenas uma ocorrencia de célula
ConsolidadoCelulas <- merge(Cadastro,ClassificacaoCelulas, all.x = TRUE) %>%
  mutate(CLASSIFICACAO = if_else(is.na(CLASSIFICACAO),"NORMAL",CLASSIFICACAO))
ConsolidadoCelulas <- merge(ConsolidadoCelulas,IndicadoresFora, all.x = TRUE) %>%
  mutate(INDICADOR = if_else(CLASSIFICACAO == "NORMAL",NA,INDICADOR))

# Separando o DF de células target para rastreio de oportunidade de balanceamento (críticas)
CelCritico <- baseassess %>%
  filter(Classificação == "CRITICO")
  select(-Indicador)

# Separando o DF de células passíveis de receber mais tráfego/carga através de balanceamento (boas)
CelNormal <- baseassess %>%
  filter(Classificação == "NORMAL")
  select(-Indicador)

# Chamada para o módulo de detecção das oportunidades de balanceamento
source("Scripts/modulo_critico-bom.R", encoding = "utf-8")
  