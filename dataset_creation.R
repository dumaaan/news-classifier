library(readtext)
library(dplyr)

rm(list = ls())

setwd("~/Desktop/news-classifier")
path <- "~/Desktop/news-classifier/data/bbc"
list_categories <- list.files(path=path)
summary_categories <- data.frame(matrix(ncol=2, nrow=0))
colnames(summary_categories) <- c('Category','NumberOfFiles')
for (category in list_categories) {
  categoryPath <- paste(path, category, sep='/')
  n_files <- length(list.files(path=categoryPath))
  summary_categories = rbind(summary_categories, data.frame('Category'=category, 'NumberOfFiles'=n_files))
}
summary_categories = summary_categories[-c(4), ]

df_final <- data.frame(matrix(ncol=3, nrow = 0))
colnames(df_final) <- c('article_id', 'text', 'category')
for (category in list_categories) {
  categoryPath <- paste(path, category, sep = '/')
  df <- readtext(categoryPath)
  df['category'] <- category
  df_final = rbind(df_final, df)
}

colnames(df_final) <- c('FileName', 'Content', 'Category')
df_final <-
  df_final %>% 
  mutate(Complete_Filename = paste(File_Name, Category, sep='-'))

# Save dataset: .rda
save(df_final, file='Dataset.rda')

load(file='Dataset.rda')

# Write csv to import to python
write.csv2(df_final,fileEncoding = 'utf8', "News_dataset.csv", row.names = FALSE)