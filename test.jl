import Pkg;
Pkg.add("Distributions")
Pkg.add("Plots")
Pkg.add("StatsPlots")

using Random, Distributions, Plots, StatsPlots

# For reproduserbarhet 
Random.seed!(1234)

# Parametre
p = 0.88         # Populasjonsandelen
n = 1000         # Utvalgsstørrelse
N = 10_000       # Antall simuleringer

# Teoretisk standardfeil basert på populasjonsparameteren P:
SE = sqrt(p * (1 - p) / n)

# Initialiser vektorer for å lagre utvalgsandeler og tilhørende standardfeil
p̂ = zeros(N)    # Andels-estimeter (av p)
SÊ = zeros(N)   # Standardfeil-estimater

# Definer Bernoulli-fordelingen med suksess-sannsynlighet p
bern = Bernoulli(p)

# Simuler N utvalg
for i in 1:N
    sample = rand(bern, n)               # Trekker et utvalg av størrelse n fra Bernoulli(p)-fordelingen
    nₛ = sum(sample)                      # Antall suksesser
    p̂[i] = nₛ / n                           # Estimerer utvalgsandel #p̂[i] = mean(sample)  
    SÊ[i] = sqrt(p̂[i] * (1 - p̂[i]) / n)  # Beregn standardfeilen for utvalgsandelen
end

# Estimerer gjennomsnittet av p̂-verdiene og SÊ-verdiene fra simuleringene:
p̂̄ = mean(p̂)
SĒ = mean(SÊ)
println("Gjennomsnittet (p̂̄) av andelsestimatene (p̂): ", round(p̂̄, digits=5), ", og den sanne populasjons-andelen p = $p.")
println("Gjennomsnittet (SĒ) av de estimerte standardfeilene (SÊ): ", round(SĒ, digits=5), ", og den sanne standardfeilen SE = $(round(SE, digits = 5)).")


# Lager histogrammer:
nbins = 50 # Antall stolper i histogrammene nedenfor
# Visualisering: Histogram over utvalgsandeler
h₁ = histogram(p̂, bins=nbins,
    title="Histogram over utvalgsandeler",
    xlabel="Utvalgsandel (p̂)",
    ylabel="Frekvens",
    legend=false, bottom_margin=10Plots.mm, left_margin=10Plots.mm)

# Visualisering: Histogram over beregnede standardfeil
h₂ = histogram(SÊ, bins=nbins,
    title="Histogram over standardfeil",
    xlabel="Standardfeil",
    ylabel="Frekvens",
    legend=false, bottom_margin=10Plots.mm, left_margin=10Plots.mm)

plot(h₁, h₂, layout=(1, 2), size=(1000, 500))
display(plot!())

# Estimerer sannsynligheten for at utvalgsandelen faller innenfor [p-0.02, p+0.02] basert på simuleringene
within_range = sum(p - 0.02 .<= p̂ .<= p + 0.02) / N  # = count(x -> p-0.02 <= x <= p+0.02, p̂)/N
println("Andelen simulerte p̂-verdier som faller i intervallet [p-0.02. p+0.02] er: ", round(within_range, digits=3))

# Estimerer sannsynligheten for at utvalgsandelen faller innenfor [p-0.02, p+0.02] ved normaltilnærmingen for andeler:
F(x) = cdf(Normal(p, SE), x); # Den kumulative N(p, SE)-fordelingsfunksjonen.
probab = F(p + 0.02) - F(p - 0.02)

println("Sannsynligheten for at en utvalgsandel (p̂-verdi) faller i intervallet [p-0.02. p+0.02] basert på normaltilnærmingen er: ", round(probab, digits=3))