## Mapa do Rio Grande do Sul por município

# Carregando os pacotes----

library(maptools)     
library(spdep)          
library(cartography)    
library(tmap)           
library(leaflet)        
library(dplyr)
library(rgdal)
library(RColorBrewer) 

# Importando shapefile (mapa do Brasil)----

shp <- readOGR("C:\\Users\\00192923\\Desktop\\shape_file", stringsAsFactors=FALSE, encoding="UTF-8")

#Criando o dataframe com uma coluna com os códigos geográficos dos municípios:

dados$CD_GEOCMU <- as.data.frame(shp$CD_GEOCMU)

# Fazendo um vetor aleatório para servir de dados de exemplo do mapa:

vetor <- seq(0.23, 4.17, 0.34)

# Criando a coluna de dados no data.frame de dados

dados$DADOS <- sample(x = vetor, size = 499, replace = TRUE)

# Tirando a cor do Guaíba

dados$DADOS <- replace(dados$DADOS, dados$`shp$NM_MUNICIP`=="LAGOA DOS PATOS", NA)

# Unindo dataset e shapefile ----

dados_mapa <- merge(shp, dados, by.x = "NM_MUNICIP", by.y = "shp$NM_MUNICIP")

#Tratamento e transformação dos dados----
## Incluindo as coordenadas geográficas:
proj4string(dados_mapa) <- CRS("+proj=longlat +datum=WGS84 +no_defs") #adicionando coordenadas geogrÃ¡ficas

## Mudando a codificação da variável de nome do município

Encoding(dados_mapa$NM_MUNICIP) <- "UTF-8"

# Gerando o mapa interativo----

## Gerando as cores que usaremos na representação dos dados:

pal <- colorNumeric(palette = "Spectral", domain = dados_mapa$DADOS, reverse = TRUE) #cores do mapa

## Gerando o pop up que aparece com o clique:

municipio_popup <- paste0("<strong>Municipio: </strong>", 
                          dados_mapa$NM_MUNICIP, 
                          "<br><strong>% prevalência de SCA: </strong>", 
                          dados_mapa$DADOS)

## Plotando o mapa interativo

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

## Imprimindo o mapa:
mapa_sca

## Exportando o mapa:
htmlwidgets::saveWidget(mapa_sca, "C:\\Users\\00192923\\Desktop\\shape_file\\Projeto_UFRGS\\Projeto_William.html", 
                        selfcontained = TRUE)




