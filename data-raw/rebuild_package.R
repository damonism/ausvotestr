data_files <- list.files("data-raw", pattern = "\\.asc$")

if(!dir.exists("data")) {
  dir.create("data")
}

for(each_file in data_files) {

  load(paste0("data-raw/", each_file))
  df_name <- gsub(".asc", "", fixed = TRUE, each_file)
  save(list = df_name, file = paste0("data/", df_name, ".rda"))
  rm(list = df_name)

}

devtools::install(pkg = ".", repos = NULL)
