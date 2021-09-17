load(file = "psy4100_master_data.RData")
master_raw_stem_df[67533,9] = '-, tower, eiffel'
master_raw_stem_df[67533,4] = 'eiffel-tower'
master_raw_stem_df[67620,9] = 'seventh'
master_raw_stem_df[99390,9] = 'm'
master_raw_stem_df[99400,9] = 'm'
master_raw_stem_df[99406,9] = 'm'
master_raw_stem_df[99409,9] = 'd'
master_raw_stem_df[99425,9] = 'd'
master_raw_stem_df[99435,9] = 'd'
master_raw_stem_df[99483,9] = 'm'
save.image(file = "psy4100_master_data.RData")

###(2277, eiffel-tower) = 1
###(2277, seventh) = 0.5
###(9999001, m) = 1
###(9999001, d) = 0.5
###(9999002, d) = 0.4988
###(9999002, m) = 0.4988

load('all_img_type1auc_no_practice.RData')
all_img_type1auc[38888,2] = 'seventh'
all_img_type1auc[38801,2] = 'eiffel-tower'
all_img_type1auc[38801,4] = 1
all_img_type1auc[38801,5] = 1
all_img_type1auc[61104,2] = 'm'
all_img_type1auc[61114,2] = 'm'
all_img_type1auc[61120,2] = 'm'
all_img_type1auc[61123,2] = 'd'
all_img_type1auc[61123,4] = 0.5
all_img_type1auc[61144,2] = 'd'
all_img_type1auc[61144,4] = 0.4988
all_img_type1auc[61192,2] = 'm'
all_img_type1auc[61192,4] = 0.4988
save.image(file = 'all_img_type1auc_no_practice.RData')

###(2277, eiffel-tower, 133) = (1, 5)
###(2277, seventh, 267) = 0.5
###(9999001, m, 67) = 1
###(9999001, d, 67) = 0.5
###(9999002, m, 267) = 0.5
###(9999002, d, 133) = 0.5
load(file = "IA_perSOA.RData")
IA_perSOA = IA_perSOA[-25628,]
IA_perSOA[25620, 5] = 4
IA_perSOA[25660, 1] = 'seventh'
IA_perSOA[40435, 1] = 'm'
IA_perSOA[40450, 1] = 'd'
IA_perSOA[40514, 1] = 'm'
IA_perSOA[40514, 3] = 0.5
IA_perSOA[40477, 1] = 'd'
IA_perSOA[40477, 3] = 0.5
save.image(file = "IA_perSOA.RData")

