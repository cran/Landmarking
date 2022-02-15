## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----figurename, echo=FALSE, fig.cap="*Figure 1: Illustration of a landmark model with six landmark times (ages 45 to 50 years). The blue solid line represents the time interval of longitudinal (repeat measures) data that feeds into the first stage of the two-stage landmark model. The red dashed line represents the time interval of the time-to-event data to be inputted into the survival model which is the second stage of the landmark model. Events after the time horizon need to be censored within this framework.*", out.width = '70%'----
knitr::include_graphics("./images/landmarking_models.png")

## ----figurename2, echo=FALSE, fig.cap="*Figure 2: Comparison of the LOCF and LME model to predict systolic blood pressure at a landmark age for an individual with 8 repeat measures.*", out.width = '90%'----
knitr::include_graphics("./images/landmarking_lme_model.png")

## ----figurename3, echo=FALSE, fig.cap="", out.width = '100%'------------------
knitr::include_graphics("./images/fit_LOCF_landmark_model.png")

