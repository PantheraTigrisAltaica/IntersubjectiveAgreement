# Functions
library(tidyverse)
library(ggplot2)
library(psycho)

## Data Summary

load('preprocessed.RData')

# Load the duplicate image ids.
load('duplicate_similar_images.RData')

# Calculate the image ids to exclude in the baseline (other sets) - only keep the main image (key)
img_ids_to_exclude_in_baseline <- c()
for (i in 1:nrow(duplicate_img_ids)) {
  a_row <- duplicate_img_ids[i, ]
  img_ids_to_exclude_in_baseline = c(img_ids_to_exclude_in_baseline, (setdiff(unlist(a_row$duplicate_set), list(a_row$img_id))))
}

print(sprintf("Image ids (%d) to be excluded: %s", length(img_ids_to_exclude_in_baseline), paste0(img_ids_to_exclude_in_baseline, collapse = ", ")))

#functions
calculate_confauc_word <- function(target, other) {
  n_present = length(target$confidence)
  n_absent = length(other$confidence)
  
  roc = data.frame(criterion = numeric(1), hit = numeric(1), fa = numeric(1), stringsAsFactors = FALSE)
  c_list = c(10, 5, 4, 3, 2, 1, 0)
  for (i in c_list){
    temp_hit = target %>% filter(confidence >= i)
    hit = length(temp_hit$confidence)
    temp_fa = other %>% filter(confidence >= i)
    fa = length(temp_fa$confidence)
    if(n_absent == 0){fa_cum = 0} else{fa_cum = fa/(419*30)}
    hit_cum = hit/30
    if(i == 0){
      fa_cum = 1
      hit_cum = 1
    }  
    roc = rbind(roc, c(i, hit_cum, fa_cum))
  }
  
  roc = roc[-1,]
  roc_df <- transform(roc, dFPR = c(diff(fa), 0), dTPR = c(diff(hit), 0))
  auc=sum((roc_df$hit*roc_df$dFPR)) + sum(sum(roc_df$dTPR*roc_df$dFPR)/2)
  
  return(auc)
}

#-------------
calculate_ratio_word <- function(target, other) {
  n_present = length(target$confidence)
  n_absent = length(other$confidence)
  
  ratio = n_present/(n_present + n_absent)
  
  return(ratio)
}





all_image_ids <- unique(all_response$img_id)

all_img_confidenceIA <- data.frame(img_id = numeric(1), stem_word = character(1), auc = numeric(1), ratio = numeric(1), stringsAsFactors = FALSE)

for (target_img_id in all_image_ids) {
  
  # duplicate_for_this_image <- duplicate_img_ids[mapply(`%in%`, target_img_id, duplicate_img_ids$duplicate_set)]$duplicate_set # could be empty
  #   
  # if(target_img_id %in% duplicate_img_ids$img_id)
  # {all_other_image_dfs <- all_response[which(!all_image_ids %in% c(target_img_id, duplicate_for_this_image[[1]]))]}
  # else
  # {all_other_image_dfs <- all_response[which(!all_image_ids %in% target_img_id)]}
  # print(sprintf("Baseline size = %d", length(all_other_image_dfs)))
  
  print(target_img_id)
  all_other_image_dfs = all_response %>% filter(!img_id == target_img_id)
  target_image_df = all_response %>% filter(img_id == target_img_id)
  
  for (j in unique(target_image_df$stem_word)){
    target_word_df = target_image_df %>% filter(stem_word == j)
    other_word_df = all_other_image_dfs %>% filter(stem_word == j)
    auc = calculate_confauc_word(target_word_df, other_word_df)
    ratio = calculate_ratio_word(target_word_df, other_word_df)
    all_img_confidenceIA = rbind(all_img_confidenceIA, c(target_img_id, as.character(j), auc, ratio))
  }
    
}

Confidence_IA = all_img_confidenceIA
Confidence_IA = Confidence_IA[-1,]
Confidence_IA$img_id = as.numeric(Confidence_IA$img_id)
Confidence_IA$auc = as.numeric(Confidence_IA$auc)
Confidence_IA$ratio = as.numeric(Confidence_IA$ratio)
Confidence_IA = left_join(Confidence_IA, frequency, by = c('img_id','stem_word'))
save(Confidence_IA, file = "Confidence_IA.RData")