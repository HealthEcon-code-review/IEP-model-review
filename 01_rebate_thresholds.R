# Load required library
library(ggplot2)

# Define baseline absence durations (D0) from 5 to 50 days
D0 <- seq(5, 50, by = 0.5)

# Age-dependent discount factor (used externally; here assumed constant delta)
# Note: 'age' not defined in this script; assume delta = 0.6
delta <- 0.6

# Parameter definitions
psi <- 150         # Productivity loss per day
lambda0 <- 0.5     # Absence cost sensitivity without prevention
lambda1 <- 0.4     # Absence cost sensitivity with prevention
eta0 <- 80         # Productivity level without prevention
eta1 <- 100        # Productivity level with prevention
nu <- 50           # Non-absence-related benefit of prevention (e.g. morale)
pi <- 500          # Insurance premium paid by employer
c_E <- 300         # Employer's cost of prevention
omega <- 14        # Maximum effective duration of prevention
alpha <- 2         # Productivity weight

# Absence duration with prevention (e.g., 30% reduction)
D1 <- 0.7 * D0

# Employer utility with and without prevention
U_E1 <- - (pi + c_E) + delta * (-lambda1 * psi * pmin(D1, omega) + alpha * eta1 + nu)
U_E0 <- - pi + delta * (-lambda0 * psi * pmin(D0, omega) + alpha * eta0)

# Required rebate: difference in utility to make prevention attractive
rho_min <- pmax(U_E0 - U_E1, 0)
rho_max <- 200  # Upper bound for rebate, e.g. technical or regulatory limit

# Create dataframe with feasible rebate regions
df <- data.frame(D0 = D0, rho_min = rho_min, rho_max = rho_max)
df$feasible <- rho_min < rho_max

# Plot: Rebate range (ρ) over baseline absence duration (D0)
ggplot(df, aes(x = D0)) +
  
  # Shaded area where rebate makes prevention attractive
  geom_ribbon(aes(ymin = rho_min, ymax = rho_max, fill = "Feasible range"),
              data = subset(df, feasible), alpha = 0.3) +
  
  # Minimum required rebate line
  geom_line(aes(y = rho_min, color = "Minimum rebate"), size = 1.2) +
  
  # Maximum allowable rebate (fixed line)
  geom_hline(aes(yintercept = rho_max, linetype = "Maximum rebate"), color = "black") +
  
  # Vertical line at omega (maximum effective prevention duration)
  geom_vline(xintercept = omega, linetype = "dotted", color = "black", size = 1) +
  annotate("text", x = omega + 1, y = 180, label = expression(omega), size = 4.5) +
  
  # Manual legend and formatting
  scale_color_manual(values = c("Minimum rebate" = "black")) +
  scale_fill_manual(values = c("Feasible range" = "grey70")) +
  scale_linetype_manual(values = c("Maximum rebate" = "dashed")) +
  guides(
    color = guide_legend(order = 1),
    linetype = guide_legend(order = 2),
    fill = guide_legend(order = 3)
  ) +
  
  # Axis labels and caption with parameters
  labs(
    x = "Baseline absence duration (D⁰)",
    y = "Rebate level (ρ)",
    color = NULL,
    fill = NULL,
    linetype = NULL,
    caption = expression(
      atop(
        paste("                              Example parameters: ",
              delta, " = declining ~1.33%/year, ",
              psi, " = 150, "
        ),
        paste(lambda^0, " = 0.5, ",
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
  
  # General plot formatting
  theme_classic(base_size = 12) +
  theme(
    legend.position = c(0.8, 0.5),  
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.spacing.y = unit(0, "pt")
  )
