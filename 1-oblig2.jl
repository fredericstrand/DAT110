using Distributions

n = 500
n_unemployed = 41
alpha = 0.05
p0 = 0.055
p_hat = n_unemployed / n
se = sqrt(p_hat * (1 - p_hat) / n)
z_crit = quantile(Normal(0, 1), 1 - alpha / 2)
me = z_crit * se
ci_lower = p_hat - me
ci_upper = p_hat + me

println("95% konfidensintervall for andelen arbeidsledige: [", ci_lower, ", ", ci_upper, "]")

se0 = sqrt(p0 * (1 - p0) / n)
z = (p_hat - p0) / se0
p_value = 1 - cdf(Normal(0, 1), z)

println("Testobservator (z): ", z)
println("p-verdi: ", p_value)

if p_value < alpha
    println("Forkast H0: Det er bevis for at andelen arbeidsledige er større enn 5.5%.")
else
    println("Ikke forkast H0: Det er ikke tilstrekkelig bevis for at andelen arbeidsledige er større enn 5.5%.")
end
