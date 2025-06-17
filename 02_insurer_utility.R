# Load required library
library(ggplot2)

# Define age range (from 25 to 70)
age <- seq(25, 70, by = 1)

# Discount factor 

# Parameters (described in figure caption)
delta <- 0.95   # Discount factor 
psi <- 150      # Daily productivity loss
pi <- 500       # Insurance premium
c_I <- 300      # Insurer’s cost of prevention
nu <- 50        # Additional benefit (e.g., improved health)
omega <- 14     # Threshold duration for intervention effect
tau <- 30       # Maximum reimbursed duration

# Define three absence trajectories depending on age
D0_linear  <- 5 + 0.5 * (age - 25)                      # Linearly increasing
D0_concave <- 10.5 + 6.6 * sqrt((age - 25) / 45)        # Concave
D0_convex  <- 5 + 0.01 * (age - 25)^2                   # Convex

# Prevented durations (30% reduction assumed)
D1_linear  <- 0.7 * D0_linear
D1_concave <- 0.7 * D0_concave
D1_convex  <- 0.7 * D0_convex

# Function to calculate insurer utility gain from prevention
insurer_utility <- function(D0, D1) {
  U1 <- pi - c_I + delta * (-psi * pmax(pmin(D1, tau) - omega, 0) + nu)
  U0 <- pi + delta * (-psi * pmax(pmin(D0, tau) - omega, 0))
  return(U1 - U0)
}

# Calculate utility gains for each trajectory
U_linear  <- insurer_utility(D0_linear, D1_linear)
U_concave <- insurer_utility(D0_concave, D1_concave)
U_convex  <- insurer_utility(D0_convex, D1_convex)

# Create dataframe for plotting
df <- data.frame(
  age = age,
  linear = U_linear,
  concave = U_concave,
  convex = U_convex
)

# Plot utility gain across age for different trajectories
ggplot(df, aes(x = age)) +
  geom_line(aes(y = linear, color = "Linear"), size = 1.2) +
  geom_line(aes(y = concave, color = "Concave"), linetype = "dashed", size = 1.2) +
  geom_line(aes(y = convex, color = "Convex"), linetype = "dotted", size = 1.2) +
  geom_vline(xintercept = 65, linetype = "dashed", color = "black") +
  annotate("text", x = 66, y = 540, label = "Retirement\nage", hjust = 0) +
  
  # Manual color and legend formatting
  scale_color_manual(values = c("Linear" = "grey30", "Concave" = "grey30", "Convex" = "grey30")) +
  
  # Axis labels and caption with parameter values
  labs(
    x = "Age",
    y = expression("Insurer utility gain (  "*Delta*"U "[I]*" )"),
    color = "Absence\ntrajectories",
    caption = expression(
      atop(
        paste("                                                                       Example parameters: "
              
        ),
        paste(
          delta, " =  0.95, ",
          psi, " = 150, ",
          lambda^0, " = 0.5, ",
          lambda^1, " = 0.4, ",
          nu, " = 50, ",
          pi, " = 500, ",
          c[I], " = 300, ",
          omega, " = 14")
      )
    )
  ) +
  
  # Formatting and layout
  theme_classic(base_size = 12) +
  coord_cartesian(xlim = c(25, 85)) +
  theme(
    legend.position = c(0.88, 0.32),  
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.spacing.y = unit(0, "pt")
  )
