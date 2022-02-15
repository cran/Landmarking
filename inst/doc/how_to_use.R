## ----1,echo=FALSE-------------------------------------------------------------
knitr::opts_chunk$set(cache=FALSE,collapse=TRUE, comment="#>")

## ----2------------------------------------------------------------------------
library(Landmarking)
set.seed(1)
data(data_repeat_outcomes)
head(data_repeat_outcomes)

## ----3------------------------------------------------------------------------
length(unique(data_repeat_outcomes$id))
mean(table(data_repeat_outcomes$id))

## ----4------------------------------------------------------------------------
table(unique(data_repeat_outcomes[,c("id","event_status")])[,"event_status"])

## ----9------------------------------------------------------------------------
data_repeat_outcomes <-
  return_ids_with_LOCF(
    data_long = data_repeat_outcomes,
    individual_id = "id",
    covariates = c("ethnicity", "smoking", "diabetes", "sbp_stnd", "tchdl_stnd"),
    covariates_time = c(rep("response_time_sbp_stnd", 4), "response_time_tchdl_stnd"),
    x_L = c(60, 61)
  )

## ----11-----------------------------------------------------------------------
data_model_landmark_LOCF <-
  fit_LOCF_landmark(
    data_long = data_repeat_outcomes,
    x_L = c(60, 61),
    x_hor = c(65, 66),
    covariates = c("ethnicity", "smoking", "diabetes", "sbp_stnd", "tchdl_stnd"),
    covariates_time = c(rep("response_time_sbp_stnd", 4), "response_time_tchdl_stnd"),
    k = 10,
    individual_id = "id",
    event_time = "event_time",
    event_status = "event_status",
    survival_submodel = "cause_specific"
  )

## ----12-----------------------------------------------------------------------
plot(
  density(100 * data_model_landmark_LOCF[["60"]]$data$event_prediction),
  xlab = "Predicted risk of CVD event (%)",
  main = "Landmark age 60"
)

## ----13-----------------------------------------------------------------------
data_model_landmark_LOCF

## ----14-----------------------------------------------------------------------
data_model_landmark_LOCF[["60"]]$prediction_error
data_model_landmark_LOCF[["61"]]$prediction_error

## ----20-----------------------------------------------------------------------
plot(x = data_model_landmark_LOCF, x_L = 60, n = 5)

## ----15-----------------------------------------------------------------------
cross_validation_list <- lapply(data_model_landmark_LOCF, "[[", i = 1)

## ----16-----------------------------------------------------------------------
data_model_landmark_LME <-
  fit_LME_landmark(
    data_long = data_repeat_outcomes[["60"]],
    x_L = c(60),
    x_hor = c(65),
    cross_validation_df =
      cross_validation_list,
    fixed_effects = c("ethnicity", "smoking", "diabetes"),
    fixed_effects_time =
      "response_time_sbp_stnd",
    random_effects = c("sbp_stnd", "tchdl_stnd"),
    random_effects_time = c("response_time_sbp_stnd", "response_time_tchdl_stnd"),
    individual_id = "id",
    standardise_time = TRUE,
    lme_control = nlme::lmeControl(maxIter =
                                     100, msMaxIter = 100),
    event_time = "event_time",
    event_status = "event_status",
    survival_submodel = "cause_specific"
  )

## ----17-----------------------------------------------------------------------
data_model_landmark_LOCF[["60"]]$prediction_error
data_model_landmark_LME[["60"]]$prediction_error

## ----18-----------------------------------------------------------------------
newdata <-
  data.frame(
    id = c(3001, 3001, 3001),
    response_time_sbp_stnd = c(57, 58, 59),
    smoking = c(0, 0, 0),
    diabetes = c(0, 0, 0),
    ethnicity = c("Indian", "Indian", "Indian"),
    sbp_stnd = c(0.45, 0.87, 0.85),
    tchdl_stnd = c(-0.7, 0.24, 0.3),
    response_time_tchdl_stnd = c(57, 58, 59)
  )
predict(
  object = data_model_landmark_LME,
  x_L = 60,
  x_hor = 62,
  newdata = newdata,
  cv_fold = 1
)
predict(
  object = data_model_landmark_LME,
  x_L = 60,
  x_hor = 64,
  newdata = newdata,
  cv_fold = 1
)

