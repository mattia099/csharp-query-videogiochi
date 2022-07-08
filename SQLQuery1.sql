-- ------ Query su singola tabella
-- 
-- ```
-- 1- Selezionare tutte le software house americane (3)
	select *
	from software_houses
	where country = 'United States';

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
	select *
	from players
	where city = 'Rogahnland';

-- 
-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
	select *
	from players
	where name like '%a' 

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
	select *
	from reviews
	where id=800;
	
-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
	select count(*) as num_tornei_2015
	from tournaments
	where year='2015';

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
	select *
	from awards
	where description like '%facere%';

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
	select videogame_id
	from category_videogame
	where category_id = 2 or category_id = 6;

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
	select *
	from reviews
	where rating>1 and rating<5;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
	select *
	from videogames
	where year(release_date)='2020';

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
	select videogame_id
	from reviews
	where rating = 5;
-- *********** BONUS ***********
-- 
-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
	select count(*) as numero, AVG(rating) as media
	from reviews
	where videogame_id = 412;

-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
	select count(*) as num_videogame_2018
	from videogames
	where software_house_id=1 and year(release_date)='2018';

-- ------ Query con group by
-- 
-- ```
-- 1- Contare quante software house ci sono per ogni paese (3)
	select count(id)as num_software_house, country
	from software_houses
	group by country;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
	select videogame_id,count(*) as num_recensioni
	from reviews
	group by videogame_id;


-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
	select pegi_label_id, COUNT(*) AS 'videogames_num'
	from pegi_label_videogame
	group by pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
	select year(release_date), count(*) as num_videogame
	from videogames
	group by year(release_date);

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
	select device_id,count(*)
	from device_videogame
	group by device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
	select videogame_id, avg(rating) as media_recensioni
	from reviews
	group by videogame_id
	order by avg(rating) desc;

-- ------ Query con join
-- 
-- ```
-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
	select player_id
	from reviews 
	inner join players on players.id=player_id
	group by player_id

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
	select *
	from tournament_videogame
	inner join tournaments on tournaments.id = tournament_id
	where tournaments.year=2016;

-- 3- Mostrare le categorie di ogni videogioco
	SELECT v.id AS videogame_id, v.name AS videogame_name, v.release_date, c.id AS category_id, c.name AS category_name --(1718)
	from category_videogame
	inner join categories c on c.id = category_id
	inner join videogames v on v.id = videogame_id;

-- 
-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
	select software_houses.name
	from software_houses
	inner join videogames on software_house_id=videogames.software_house_id
	where year(release_date)>'2020'
	group by software_houses.name


-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
	select award_id, software_houses.name as software_house_name, videogames.name as videogame_name
	from award_videogame
	inner join videogames on videogames.id = videogame_id
	inner join software_houses on videogames.software_house_id = software_houses.id
	order by software_house_name;
	
-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
	select videogames.name , categories.name , p.name
	from reviews
	inner join videogames on videogame_id=videogames.id
	inner join category_videogame c_v on videogames.id = c_v.videogame_id
	inner join categories on categories.id = c_v.category_id
	inner join pegi_label_videogame p_v on videogames.id=p_v.videogame_id
	inner join pegi_labels p on p.id = p_v.pegi_label_id
	where reviews.rating>=4 and reviews.rating<=5
	group by videogames.name , categories.name , p.name;

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
	select distinct vg.id, vg.name
	from players p
	inner join player_tournament p_tt on p.id = p_t.player_id
	inner join tournaments t on t.id = p_t.tournament_id
	inner join tournament_videogame t_v on t.id = t_v.tournament_id
	inner join videogames vg on vg.id= tvg.videogame_id
	where p.name LIKE 'S%';

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
	select t.city
	from tournaments t
	inner join tournament_videogame t_v ON t.id = t_v.tournament_id
	inner join videogames vg ON vg.id = t_v.videogame_id
	inner join award_videogame a_v ON vg.id = a_v.videogame_id
	inner join awards aw ON aw.id = a_v.award_id
	where datepart(year, vg.release_date) = '2018'
	and aw.name = 'Gioco dell''anno';

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
	select players.*
	from players
	inner join player_tournament p_t ON players.id = p_t.player_id
	inner join tournaments ON p_t.tournament_id = tournaments.id
	inner join tournament_videogame t_v ON tournaments.id = t_v.tournament_id
	inner join videogames ON t_v.videogame_id = videogames.id
	inner join award_videogame a_v ON videogames.id = a_v.videogame_id
	inner join awards ON a_v.award_id = awards.id
	where awards.name = 'Gioco più atteso' AND year(videogames.release_date) = 2018 AND tournaments.year = 2019;
-- *********** BONUS ***********
-- 
-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
-- 
-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)
-- 
-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)
-- 
-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)
-- ```