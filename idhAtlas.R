library(tidyverse)
library(utils)
library(openxlsx)

if (!(file.exists("data/Atlas.xlsx"))) {
    url <- "https://github.com/GuilhermeFCO/downloadCensoBR/raw/main/Atlas.zip"
    utils::download.file(url, "data/Atlas.zip")
    utils::unzip("data/Atlas.zip", exdir = "data")
    file.remove("data/Atlas.zip")
    rm(list=ls())
}
munAtlas <- openxlsx::read.xlsx("data/Atlas.xlsx", sheet = 2)
ufAtlas <- openxlsx::read.xlsx("data/Atlas.xlsx", sheet = 3)
BRAtlas <- openxlsx::read.xlsx("data/Atlas.xlsx", sheet = 4)

ufIDH10 <- ufAtlas %>% 
    dplyr::filter(ANO == "2010") %>% 
    dplyr::select(UF, IDHM, IDHM_E, IDHM_L, IDHM_R, ANO, GINI)
names(ufIDH10)[1] <- "city_ibge_code"
names(ufIDH10)[6] <- "ANO_IDH"

munIDH2010 <- munAtlas %>% 
    dplyr::filter(ANO == "2010") %>% 
    dplyr::select(Codmun7, IDHM, IDHM_E, IDHM_L, IDHM_R, ANO, GINI)
names(munIDH2010)[1] <- "city_ibge_code"
names(munIDH2010)[6] <- "ANO_IDH"

mun_uf_IDH2010 <- dplyr::bind_rows(munIDH2010, ufIDH10)

data.table::fwrite(mun_uf_IDH2010, file = "idhGini2010.csv")

l <- ls()
i <- NULL
for (i in 1:length(l)) {
    if(l[[i]] == "mun_uf_IDH2010") {
        l <- l[-i]
        break
    }
}
i <- NULL
for (i in 1:length(l)) {
    if(l[[i]] == "covid") {
        l <- l[-i]
        break
    }
}
rm(list = l, "l", "i")