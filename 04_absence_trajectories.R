# Load required library
library(ggplot2)

# Define age range from 25 to 70
age <- seq(25, 70, by = 1)

# Define three baseline absence trajectories as functions of age
D0_linear  <- 5 + 0.5 * (age - 25)                      # Linear increase
D0_concave <- 11 + 6.5 * sqrt((age - 25) / 45)          # Concave shape
D0_convex  <- 5 + 0.01 * (age - 25)^2                   # Convex shape

# Combine data into a dataframe for plotting
df <- data.frame(
  age = age,
  linear = D0_linear,
  concave = D0_concave,
  convex = D0_convex
)

# Plot the three absence trajectories across age
ggplot(df, aes(x = age)) +
  geom_line(aes(y = linear,  color = "Linear"),   size = 1.2) +
  geom_line(aes(y = concave, color = "Concave"), linetype = "dashed", size = 1.2) +
  geom_line(aes(y = convex,  color = "Convex"),  linetype = "dotted", size = 1.2) +
  
  # Manual legend color formatting
  scale_color_manual(values = c(
    "Linear" = "gray30",
    "Concave" = "gray30",
    "Convex" = "gray30"
  )) +
  
  # Axis labels and caption with trajectory definitions
  labs(
    x = "Age",
    y = expression("Baseline absence duration (D "^0*")"),
    color = "Absence\ntrajectories",
    caption = "D⁰ linear = 5 + 0.5·(age − 25);\nD⁰ concave = 11 + 6.5·√((age − 25)/45);\nD⁰ convex = 5 + 0.01·(age − 25)².\nAll profiles normalized at age 25."
  ) +
  
  # Formatting and layout
  theme_classic(base_size = 12)
