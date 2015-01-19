
#in de schema.rb helemaal onderaan
execute "SELECT setval('vouchers_id_seq', 100000)"

Om niet te vergeten:

een dump maken van de locale databse in db.seeds

$: rake db:seed:dump

Daarna op Heroku weer vullen door eerst de database te migreren (indien nodig) leeg
te maken en vervolgens te vullen met de seeds.db data

LETOP users weghalen, hier gaat het fout mee

$: heroku run rake db:reset (voert ook een '$: heroku run rake db:seed' uit)



-------------------------------
batch met spaarpunten aanmaken:
-------------------------------

# een nieuwe batch met spaarpunten aanmaken

# een nieuwe batch aanmaken
# batch_id - int
# Program_id - int
# aangemaakt_op_datum - datetime
# omschrijving - string
# aantal - int

##Aanmaken van een batch:
- ga naar program
- maak een nieuwe batch met spaarpunten aan met status 'pending'
- selecteer de batch
- genereer alle spaarpunten
- sla de spaarpunten op in de database, inclusief batch_id
- Als dit goed is gegaan zet dan de batch op 'done'
- maak een transactie aan

## Verwijderen van een batch:
- Selecteer de batch
- klik op Verwijderen
- verwijder alle spaarpunten van deze batch
- maak een transactie aan
- verwijder de batch uit de database
