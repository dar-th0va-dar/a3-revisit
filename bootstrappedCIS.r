library(ggplot2)
library(dplyr)

data <- read.csv("Master_CSV.csv")
data$visualization <- trimws(data$visualization)


bootstrap_ci <- function(x, conf = 0.95, B = 1000) {
  boot_samples <- replicate(B, mean(sample(x, replace = TRUE)))
  quantile(boot_samples, c((1 - conf) / 2, 1 - (1 - conf) / 2))
}

ggplot(data, aes(x = visualization, y = cm_error)) +
  geom_jitter(width = 0.2, alpha = 0.5, color = "blue") +
  stat_summary(
    fun.data = function(y) {
      ci <- bootstrap_ci(y)
      return(data.frame(y = mean(y), ymin = ci[1], ymax = ci[2]))
    },
    geom = "pointrange",
    color = "red",
    size = 1
  ) +
  labs(title = "Bootstrapped 95% CI for Error by Visualization Type",
       x = "Visualization Type",
       y = "Error") +
  theme_minimal()
