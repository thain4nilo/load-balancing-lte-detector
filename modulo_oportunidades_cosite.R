########################################################
# MODULO: OPORTUNIDADE DE BALANCEAMENTO BOM VS CRITICA #
## Autora: Thainá Nilo
########################################################


#### CHECK DE OPORTUNIDADE BOM-CRITICO ####
#Check de end ID critico com correspondente bom
listbom <- CelNormal$STATION_ID
listbom <- unique(listbom)
oportcritica <- CelCritico %>% filter(STATION_ID %in% listbom)

#quais os valores de azimutes possíveis
listazimute <- unique(oportcritica$DIR_IRR)

#criando df para receber as oportunidades de otimização
Oport_CoSite <- data.frame()

#Realizando check entre oportunidade e critica por azimute

for (azimute in 1:length(listazimute)) { #para cada azimute
  setor <- oportcritica %>% filter(DIR_IRR == listazimute[azimute])
  listsetor <- setor$STATION_ID
  listsetor <- unique(listsetor)
  for (i in 1:length(listsetor)){ #para cada estação que tenha aquele azimute
    endID = listsetor[i]
    listoport <- CelNormal %>% filter(STATION_ID == endID & DIR_IRR == listazimute[azimute])
    listoport <- listoport$CELL_ID
    if (length(listoport) != 0 ) {
      oport <- oportcritica %>% filter(STATION_ID == endID & DIR_IRR == listazimute[azimute]) %>% mutate(OPORTUNIDADE = paste("",listoport, collapse = ","))
      Oport_CoSite <- rbind(Oport_CoSite,oport)
    }
  }
}

#### DF DE OPORTUNIDADES DE BALANCEAMENTO CRITICO-BOM ####
rm(oport,setor, listsetor,listoport, listbom, oportcritica, endID, i, azimute, listazimute)
Oport_CoSite <- Oport_CoSite %>% filter(OPORTUNIDADE != " ") %>% mutate (TIPO = "Co-Site") 
