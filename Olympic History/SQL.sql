  --View sheet 1. 
  Select * from athlete_events$

  --view sheet 2.
select * from noc_regions$




--1. How many olympics games have been held?

Select count(distinct games) from athlete_events$




-- 2. List down all Olympics games held so far.

Select distinct Year, City  from athlete_events$
order by Year




--3. Mention the total no of nations who participated in each olympics game?
 
Select Games, count(distinct region)as total_nations from athlete_events$ as ath
INNER JOIN noc_regions$ as noc
ON ath.NOC = noc.NOC
Group by Games
order by Games




--4. Which year saw the highest no of countries participating in olympics?

With a1 as
	(Select Games, count(distinct region)as total_nations from athlete_events$ as ath
	INNER JOIN noc_regions$ as noc
	ON ath.NOC = noc.NOC
	Group by Games)
Select Max(total_nations)as highest_no_of_countries_participated from a1 



--5. Which year saw the lowest no of countries participating in olympics?

With a1 as
	(Select Games, count(distinct region)as total_nations from athlete_events$ as ath
	INNER JOIN noc_regions$ as noc
	ON ath.NOC = noc.NOC
	Group by Games)
Select Min(total_nations)as lowest_no_of_countries_participated from a1



--6. Which nation has participated in all of the olympic games?

With tot_games as 
	(select count(distinct Games) as total_games 
	from athlete_events$),

	countries as 
	(Select Games, region as country
	from athlete_events$ as ath
	INNER JOIN noc_regions$ as noc
	ON ath.NOC = noc.NOC
	group by Games, region),

	countries_participated as
	(select country, count(Games) as total_participated_games
    from countries
    group by country)

	select * from countries_participated
	Join tot_games
	on  tot_games.total_games = countries_participated.total_participated_games




-- 7. Identify the sport which was played in all summer olympics.

   with t1 as (select count(distinct games) as total_games
           	from athlete_events$ where season = 'Summer'),

        t2 as (select distinct games, sport
          	from athlete_events$ where season = 'Summer'),

        t3 as (select sport, count(games) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;



--8. Which Sports were just played only once in the olympics?

  with t1 as (select distinct games, sport
       from athlete_events$),

       t2 as(select sport, count(games) as no_of_games from t1
       group by sport)

       select t2.*, t1.games
       from t2
       join t1 on t1.sport = t2.sport
       where t2.no_of_games = 1
       order by t1.sport;




--9. Fetch the total no of sports played in each olympic games.

with t1 as (select distinct sport, Games from athlete_events$),

	 t2 as (select Games, count(sport) as no_of_sports from t1
	 group by Games)

	 select * from t2
	 order by no_of_sports desc




--10. Fetch the top 5 athletes who have won the most gold medals.

with a1 as
	(Select Name, team, count (Medal) as tot_medals from athlete_events$
	Where Medal = 'gold'
	Group by Name, Team),

	a2 as (select *, dense_rank() over(order by tot_medals desc) as rnk
	from a1)

	Select * from a2
	Where rnk<=5



--11. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

with a1 as
	(Select Name, team, count (Medal) as tot_medals from athlete_events$
	Where Medal in ('Gold', 'Silver', 'Bronze')
	Group by Name, Team),

	a2 as (select *, dense_rank() over(order by tot_medals desc) as rnk
	from a1)

	Select * from a2
	Where rnk<=5




--12. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

with a1 as (Select region as Country,  count(Medal) as total_medals from athlete_events$ as ath
INNER JOIN noc_regions$ as noc
ON ath.NOC = noc.NOC
Where Medal in ('Gold', 'Silver', 'Bronze')
group by region),

a2 as (select *, DENSE_RANK() over(order by total_medals desc) as rnk
from a1)

select * from a2
where rnk<=5




