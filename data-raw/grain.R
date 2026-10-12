# Builds the paper grain field stored in R/sysdata.rda.
#
# This follows the screensaver's grain generator step by step, with the same seed, so the tile is
# the same one the screensaver lays under its dials:
#
#   1. Uniform white noise in [-1, 1) from a 32-bit xorshift generator (seed 0x9E3779B9) on a
#      512 x 512 torus.
#   2. Wrap-around convolution with a measured 7 x 5 kernel (rows are dy = -3..3, columns dx = -2..2),
#      which turns the noise into short horizontal streaks two to three samples long.
#   3. Scaling to unit variance (x 1.7326) and a soft tanh flattening of the tails.
#
# The field is stored as integers (thousandths) to keep the package small.
#
# Run from the package root: Rscript data-raw/grain.R

n <- 512L
two16 <- 65536
two32 <- 4294967296

# Bitwise XOR of two unsigned 32-bit numbers held in doubles, done on 16-bit halves.
xor32 <- function(a, b) {
  ah <- a %/% two16; al <- a %% two16
  bh <- b %/% two16; bl <- b %% two16
  bitwXor(as.integer(ah), as.integer(bh)) * two16 + bitwXor(as.integer(al), as.integer(bl))
}

state <- 2654435769 # 0x9E3779B9
white <- numeric(n * n)
for (i in seq_len(n * n)) {
  state <- xor32(state, (state * 8192) %% two32) # state ^= state << 13
  state <- xor32(state, state %/% 131072) #        state ^= state >> 17
  state <- xor32(state, (state * 32) %% two32) #   state ^= state << 5
  white[i] <- state / two32 * 2 - 1
}
# Samples run along rows (x fastest), as in the screensaver.
white <- matrix(white, nrow = n, ncol = n, byrow = TRUE)

kernel <- rbind(
  c(0.008, -0.055, -0.104, -0.055, 0.008),
  c(-0.042, -0.104, -0.198, -0.104, -0.042),
  c(-0.046, 0.087, 0.125, 0.087, -0.046),
  c(-0.034, 0.338, 0.732, 0.338, -0.034),
  c(-0.046, 0.087, 0.125, 0.087, -0.046),
  c(-0.042, -0.104, -0.198, -0.104, -0.042),
  c(0.008, -0.055, -0.104, -0.055, 0.008)
)

wrap <- function(i) ((i - 1L) %% n) + 1L
acc <- matrix(0, n, n)
for (dy in -3:3) {
  for (dx in -2:2) {
    acc <- acc + kernel[dy + 4, dx + 3] * white[wrap(seq_len(n) + dy), wrap(seq_len(n) + dx)]
  }
}
v <- 1.7326 * acc
field <- 5 * tanh(v / 5) / 0.966

grain_field <- matrix(as.integer(round(field * 1000)), n, n)

usethis::use_data(grain_field, internal = TRUE, overwrite = TRUE, compress = "xz")
