
reds <- c(1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36)
blacks <- c(2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35)

bet_on_red <- function() {
    x <- trunc(runif(1, 0, 36))
    result <- vector("integer")
    # print(x)
    if (x %in% reds) {
        result <- c(1, 1)
    } else {
        result <- c(-1, 1)
    }
    return(result)
}

bet_on_number <- function() {
    x <- trunc(runif(1, 0, 36))
    result <- vector("integer")
    if (x == 17) {
        result <- c(35, 1)
    } else {
        result <- c(-1, 1)
    }
    return(result)
}

martingale <- function() {
    result <- vector("integer")
    num_games <- 0
    num_wins <- 0
    money <- 0
    bet <- 1
    while (money <= 10 | bet <= 100) {
        x <- trunc(runif(1, 0, 36))
        # print(x)
        if (x %in% reds) {
            money <- money + bet
            num_wins <- num_wins + 1
        } else {
            money <- money - bet
            bet <- bet * 2
        }
        num_games <- num_games + 1
    }
    result <- c(money, num_games, num_wins)
    return(result)
}

labouchere <- function() {
    game_list <- list(1, 2, 3, 4)
    result <- vector("integer")
    num_games <- 0
    num_wins <- 0
    money <- 0
    bet <- 5
    while (length(game_list) != 0 & bet <= 100) {
        if (length(game_list) == 1) {
            bet <- game_list[[1]]
        } else {
            bet <- game_list[[1]] + game_list[[length(game_list)]]
        }
        # print(unlist(game_list))
        x <- trunc(runif(1, 0, 36))
        # print(c("bet", bet))
        if (x %in% reds) {
            num_wins <- 0
            # print(c(x, " is red"))
            if (length(game_list) > 1) {
                game_list[length(game_list)] <- NULL
                game_list[1] <- NULL
            }
            money <- money + bet
        } else {
            # print(c(x, " is not red"))
            game_list[length(game_list) + 1] <- bet
            money <- money - bet
        }
        num_games <- num_games + 1
    }
    result <- c(money, num_games, num_wins)
    return(result)
}

# simulation
n <- 100000

expected_winnings_acc_a <- 0
expected_winnings_acc_b <- 0
expected_winnings_acc_c <- 0
expected_winnings_acc_d <- 0

expected_playing_time_acc_a <- 0
expected_playing_time_acc_b <- 0
expected_playing_time_acc_c <- 0
expected_playing_time_acc_d <- 0

money_a <- 1:n
money_b <- 1:n
money_c <- 1:n
money_d <- 1:n

time_a <- 1:n
time_b <- 1:n
time_c <- 1:n
time_d <- 1:n

for (i in 1:n) {
    a_result <- bet_on_number()
    b_result <- bet_on_red()
    c_result <- martingale()
    d_result <- labouchere()

    expected_winnings_acc_a <- expected_winnings_acc_a + a_result[1]
    expected_winnings_acc_b <- expected_winnings_acc_b + b_result[1]
    expected_winnings_acc_c <- expected_winnings_acc_c + c_result[1]
    expected_winnings_acc_d <- expected_winnings_acc_d + d_result[1]

    expected_playing_time_acc_a <- expected_playing_time_acc_a + a_result[2]
    expected_playing_time_acc_b <- expected_playing_time_acc_b + b_result[2]
    expected_playing_time_acc_c <- expected_playing_time_acc_c + c_result[2]
    expected_playing_time_acc_d <- expected_playing_time_acc_d + d_result[2]

    money_a[i] <- a_result[1]
    money_b[i] <- b_result[1]
    money_c[i] <- c_result[1]
    money_d[i] <- d_result[1]

    time_a[i] <- a_result[2]
    time_b[i] <- b_result[2]
    time_c[i] <- c_result[2]
    time_d[i] <- d_result[2]
}

num_wins_a <- length(money_a[money_a > 0])
num_wins_b <- length(money_b[money_b > 0])
num_wins_c <- length(money_c[money_c > 0])
num_wins_d <- length(money_d[money_d > 0])

proportion_games_win_a <- num_wins_a / n
proportion_games_win_b <- num_wins_b / n
proportion_games_win_c <- num_wins_c / n
proportion_games_win_d <- num_wins_d / n

expected_winnings_a <- expected_winnings_acc_a / n
expected_winnings_b <- expected_winnings_acc_b / n
expected_winnings_c <- expected_winnings_acc_c / n
expected_winnings_d <- expected_winnings_acc_d / n

expected_playing_time_acc_a <- expected_playing_time_acc_a / n
expected_playing_time_acc_b <- expected_playing_time_acc_b / n
expected_playing_time_acc_c <- expected_playing_time_acc_c / n
expected_playing_time_acc_d <- expected_playing_time_acc_d / n

print(sprintf("Expected winings for sistem A: %f", expected_winnings_a))
print(sprintf("Expected winings for sistem B: %f", expected_winnings_b))
print(sprintf("Expected winings for sistem C: %f", expected_winnings_c))
print(sprintf("Expected winings for sistem D: %f", expected_winnings_d))

print(sprintf("Expected playing time for system A: %f", expected_playing_time_acc_a))
print(sprintf("Expected playing time for system B: %f", expected_playing_time_acc_b))
print(sprintf("Expected playing time for system C: %f", expected_playing_time_acc_c))
print(sprintf("Expected playing time for system D: %f", expected_playing_time_acc_d))

print(sprintf("Proportion of games won for system A: %f", proportion_games_win_a))
print(sprintf("Proportion of games won for system B: %f", proportion_games_win_b))
print(sprintf("Proportion of games won for system C: %f", proportion_games_win_c))
print(sprintf("Proportion of games won for system D: %f", proportion_games_win_d))

print(sprintf("Mean winnings of A: %f", mean(money_a)))
print(sprintf("Mean winnings of B: %f", mean(money_b)))
print(sprintf("Mean winnings of C: %f", mean(money_c)))
print(sprintf("Mean winnings of D: %f", mean(money_d)))

print(sprintf("Mean play time for A: %f", mean(time_a)))
print(sprintf("Mean play time for B: %f", mean(time_b)))
print(sprintf("Mean play time for C: %f", mean(time_c)))
print(sprintf("Mean play time for D: %f", mean(time_d)))

print(sprintf("Standard deviation for A winings: %f", sd(money_a)))
print(sprintf("Standard deviation for B winings: %f", sd(money_b)))
print(sprintf("Standard deviation for C winings: %f", sd(money_c)))
print(sprintf("Standard deviation for D winings: %f", sd(money_d)))

print(sprintf("Standard deviation for A playing time: %f", sd(time_a)))
print(sprintf("Standard deviation for B playing time: %f", sd(time_b)))
print(sprintf("Standard deviation for C playing time: %f", sd(time_c)))
print(sprintf("Standard deviation for D playing time: %f", sd(time_d)))
