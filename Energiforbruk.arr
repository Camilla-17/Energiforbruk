use context essentials2021
include shared-gdrive("dcic-2021", "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")
include gdrive-sheets
include data-source


ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"

kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
    sanitize komponent using string-sanitizer
end

#Her er det brukt sanitizer for å reparere tabellen. Det skal stå en verdi der og ikke "", som det gjorde. Man gjør dette for at pyret skal klare å lese den. Pyret krever at det står et tall der. 

print(kWh-wealthy-consumer-data)

fun energi-to-number(str :: String) -> Number:
    doc: "If str is not a numeric string, default to 0."
    cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
    end
where:
energi-to-number("") is 0
energi-to-number("48") is 48
end

#Her blir string gjort om til tall, slik at det fungerer i tabellen. 


ny-tabell = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)
#Tabellen blir her synlig i vinduet til høyre. Her ser man resultatet av funksjonen fra de tidligere kommandoene, som gjorde "" til nummeret 0.

print(ny-tabell)
  
fun bil-energy-per-day(distance-travelled-per-day, distance-per-unit-of-fuel, energy-per-unit-of-fuel): (distance-travelled-per-day / distance-per-unit-of-fuel) * energy-per-unit-of-fuel
  
#Formelen for energiforbruk. Måtte skrive det slik da pyret ikke godtok dele og gange mellom tekst

where: 
  bil-energy-per-day(24, 6, 4) is 16
end
  
distance-travelled-per-day = 24
distance-per-unit-of-fuel = 6
energy-per-unit-of-fuel = 4
#her bestemmer jeg verdiene for formelen som man ser over



  fun energi-to-number-bil(str :: String) -> Number:
    cases(Option) string-to-number(str):
    | some(a) => a
    | none => bil-energy-per-day(24, 6, 4)
    end
where:
  energi-to-number("") is 0
energi-to-number("48") is 48
end



ny-tabell-bil = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number-bil)

print(ny-tabell-bil)

bar-chart(ny-tabell-bil, "komponent", "energi")

#På den siste funksjonen får man opp den siste tabellen med rikitg verdi. Det er gjort på samme vis som den forrige bare med ulike navn for tabellen. 
#bruker print gjennom hele kodingen for å vise de forskjellige tabellene. 
