# Load required library for plotting
library(ggplot2)

# Define age range from 25 to 70
age <- seq(25, 70, by = 1)

# Define parameter values (also summarised in figure caption)
delta <- 0.95     # Discount factor
psi <- 150        # Daily productivity loss
pi <- 500         # Insurance premium
c_E <- 300        # Employer's cost of prevention
eta0 <- 100       # Productivity without prevention
eta1 <- 80        # Productivity with prevention
nu <- 50          # Additional benefit of prevention
lambda0 <- 0.5    # Absence cost sensitivity without prevention
lambda1 <- 0.4    # Absence cost sensitivity with prevention
omega <- 14       # Maximum effective absence days
alpha <- 2        # Weight on productivity

# Define baseline absence trajectories as functions of age
D0_linear  <- 5 + 0.5 * (age - 25)                    # Linear increase
D0_concave <- 11 + 6.5 * sqrt((age - 25) / 45)        # Concave pattern
D0_convex  <- 5 + 0.01 * (age - 25)^2                 # Convex pattern

# Define prevented absence durations (assumed 30% reduction)
D1_linear  <- 0.7 * D0_linear
D1_concave <- 0.7 * D0_concave
D1_convex  <- 0.7 * D0_convex

# Function to compute employer utility gain from prevention
employer_utility <- function(D0, D1, delta) {
  U1 <- -(pi + c_E) + delta * (-lambda1 * psi * pmin(D1, omega) + alpha * eta1 + nu)
  U0 <- -pi + delta * (-lambda0 * psi * pmin(D0, omega) + alpha * eta0)
  return(U1 - U0)
}

# Compute utility gains for each absence trajectory
U_linear   <- employer_utility(D0_linear, D1_linear, delta)
U_concave  <- employer_utility(D0_concave, D1_concave, delta)
U_convex   <- employer_utility(D0_convex, D1_convex, delta)

# Combine results into a data frame for plotting
df <- data.frame(
  age = age,
  linear = U_linear,
  concave = U_concave,
  convex = U_convex
)

# Plot employer utility gain across age for different absence trajectories
ggplot(df, aes(x = age)) +
  geom_line(aes(y = linear, color = "Linear"), size = 1.2) +
  geom_line(aes(y = concave, color = "Concave"), linetype = "dashed", size = 1.2) +
  geom_line(aes(y = convex, color = "Convex"), linetype = "dotted", size = 1.2) +
  
  # Add retirement age line and label
  geom_vline(xintercept = 65, linetype = "dashed", color = "black") +
  annotate("text", x = 66, y = 100, label = "Retirement\nage", hjust = 0, size = 4) +
  
  # Manual color and legend formatting
  scale_color_manual(values = c("Linear" = "gray30", "Concave" = "gray30", "Convex" = "gray30")) +
  
  # Axis labels and parameter summary in caption
  labs(
    x = "Age",
    y = expression("Employer utility gain ( "*Delta*"U "[E]*" )"),
    color = "Absence\ntrajectories",
    caption = expression(
      atop(
        paste("                                                       Example parameters: ",
              delta, " = 0.95, ",
              psi, " = 150, "
        ),
        paste(
          lambda^0, " = 0.5, ",
          lambda^1, " = 0.4, ",
          alpha, " = 2, ",
          eta^0, " = 80, ",
          eta^1, " = 100, ",
          nu, " = 50, ",
          pi, " = 500, ",
          c[E], " = 300, ",
          omega, " = 14")
      )
    )
  ) +
  
  # Plot appearance
  theme_classic(base_size = 12) +
  coord_cartesian(xlim = c(25, 85)) +
  theme(
    legend.position = c(0.85, 0.32),
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.spacing.y = unit(0, "pt")
  )
