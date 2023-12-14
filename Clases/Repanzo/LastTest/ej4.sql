
--1-Show title and special_features of films that are PG-13
--2-Get a list of all the different films duration.
--3-Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
--4-Show title, category and rating of films that have 'Behind the Scenes' as special_features
--5-Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
--6-Show the address, city and country of the store with id 1
--7-Show pair of film titles and rating of films that have the same rating.
--8-Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).

use sakila;

--1--
SELECT title, special_features from film where rating = "PG-13";

--2--

select DISTINCT title, length from film;