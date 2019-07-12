# Carregando os pacotes----

library(maptools)     
library(spdep)          
library(cartography)    
library(tmap)           
library(leaflet)        
library(dplyr)
library(rgdal)
library(dplyr)
library(RColorBrewer) 

# Importando shapefile (mapa do Brasil)----

shp <- readOGR("C:\\Users\\00192923\\Desktop\\shape_file", stringsAsFactors=FALSE, encoding="UTF-8")

class(shp$CD_GEOCMU)


dados$CD_GEOCMU <- as.data.frame(shp$CD_GEOCMU)

vetor <- seq(0.23, 4.17, 0.34)

dados$DADOS <- sample(x = vetor, size = 499, replace = TRUE)

dados$DADOS <- replace(dados$DADOS, dados$`shp$NM_MUNICIP`=="LAGOA DOS PATOS", NA)

# Importando cÃ³digos do IBGE e adicionando ao dataset----

# ibge <- read.csv("D:/Ewerton/Mapas R/Dados\\estadosibge.csv", header=T,sep=",")
# 
# pg <- merge(pg,ibge, by.x = "Location", by.y = "Unidade.da.Federação")

# Fazendo a junÃ§Ã£o entre o dataset e o shapefile----

dados_mapa <- merge(shp,dados, by.x = "NM_MUNICIP", by.y = "shp$NM_MUNICIP")

#Tratamento e transformaÃ§Ã£o dos dados----

proj4string(dados_mapa) <- CRS("+proj=longlat +datum=WGS84 +no_defs") #adicionando coordenadas geogrÃ¡ficas

Encoding(dados_mapa$NM_MUNICIP) <- "UTF-8"

#brasileiropg$Score[is.na(brasileiropg$Score)] <- 0 #substituindo NA por 0


# Gerando o mapa----


?colorNumeric

pal <- colorNumeric(palette = "Spectral", domain = dados_mapa$DADOS, reverse = TRUE) #cores do mapa

municipio_popup <- paste0("<strong>Municipio: </strong>", 
                          dados_mapa$NM_MUNICIP, 
                          "<br><strong>% prevalência de SCA: </strong>", 
                          dados_mapa$DADOS)

mapa_sca <- leaflet(data = dados_mapa) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(dados_mapa$DADOS), 
              fillOpacity = 0.2, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = municipio_popup) %>%
  addLegend("bottomright", pal = pal, values = ~dados_mapa$DADOS,
            title = "Incidência de SCA",
            opacity = 1)


htmlwidgets::saveWidget(mapa_sca, "C:\\Users\\00192923\\Desktop\\shape_file\\Projeto_UFRGS\\Projeto_William.html", 
                        selfcontained = TRUE)




