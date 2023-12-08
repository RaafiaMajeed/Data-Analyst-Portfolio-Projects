/*  Digital store music data analysis*/

/*  Who is the senior most employee based on job title? */

SELECT * FROM employee
ORDER BY levels desc 
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY

/* Which country has the most invoices ?*/
Select COUNT(*) as count, billing_country FROM Digital_music_store_analysis.dbo.invoice
GROUP BY billing_country
ORDER BY count desc

/*  What are top 3 values of total invoice? */
SELECT * FROM Digital_music_store_analysis.dbo.invoice
ORDER BY total desc
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY


/*  Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT SUM (total)as sum,billing_city
FROM Digital_music_store_analysis.dbo.invoice
GROUP BY billing_city
ORDER BY sum desc

/*  Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT customer.customer_id,customer.first_name,customer.last_name, SUM(invoice.total) as most_money_spent
FROM Digital_music_store_analysis.dbo.customer
JOIN Digital_music_store_analysis.dbo.invoice ON customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id,
    customer.first_name,
    customer.last_name
ORDER BY most_money_spent desc
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY


/*  Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by emai/
*/
SELECT first_name,last_name,email 
FROM Digital_music_store_analysis.dbo.customer
JOIN Digital_music_store_analysis.dbo.invoice ON invoice.customer_id=customer.customer_id
JOIN Digital_music_store_analysis.dbo.invoice_line ON invoice_line.invoice_id=invoice.invoice_id
WHERE invoice_line.track_id IN (
   SELECT track_id FROM Digital_music_store_analysis.dbo.track
   JOIN Digital_music_store_analysis.dbo.genre ON genre.genre_id=track.track_id
   WHERE genre.name LIKE 'ROCK'
   )
ORDER BY email asc

/*the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands.*/

SELECT  artist.name, artist.artist_id , COUNT(artist.artist_id) AS number_of_songs
FROM Digital_music_store_analysis.dbo.artist
JOIN Digital_music_store_analysis.dbo.album ON album.artist_id=artist.artist_id
JOIN Digital_music_store_analysis.dbo.track ON track.album_id=album.album_id
JOIN Digital_music_store_analysis.dbo.genre ON genre.genre_id=track.genre_id
WHERE genre.name = 'ROCK'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC

/* Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name, milliseconds
FROM Digital_music_store_analysis.dbo.track
WHERE  track.milliseconds > (
     SELECT AVG(track.milliseconds)
	 FROM Digital_music_store_analysis.dbo.track
	 )
ORDER BY track.milliseconds desc



/*Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM Digital_music_store_analysis.dbo.invoice_line
	JOIN Digital_music_store_analysis.dbo.track ON track.track_id = invoice_line.track_id
	JOIN Digital_music_store_analysis.dbo.album ON album.album_id = track.album_id
	JOIN Digital_music_store_analysis.dbo.artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id, artist.name
	ORDER BY 3 DESC
    OFFSET 0 ROWS
    FETCH NEXT 1 ROWS ONLY
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM Digital_music_store_analysis.dbo.invoice i
JOIN Digital_music_store_analysis.dbo.customer c ON c.customer_id = i.customer_id
JOIN Digital_music_store_analysis.dbo.invoice_line il ON il.invoice_id = i.invoice_id
JOIN Digital_music_store_analysis.dbo.track t ON t.track_id = il.track_id
JOIN Digital_music_store_analysis.dbo.album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY 5 DESC;


/* We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */


WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM Digital_music_store_analysis.dbo.invoice_line 
	JOIN Digital_music_store_analysis.dbo.invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN Digital_music_store_analysis.dbo.customer ON customer.customer_id = invoice.customer_id
	JOIN Digital_music_store_analysis.dbo.track ON track.track_id = invoice_line.track_id
	JOIN Digital_music_store_analysis.dbo.genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
	
)
SELECT * FROM popular_genre WHERE RowNo <= 1


/* Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */


WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM Digital_music_store_analysis.dbo.invoice
		JOIN Digital_music_store_analysis.dbo.customer ON customer.customer_id = invoice.customer_id
		GROUP BY first_name,last_name,billing_country,customer.customer_id
	)
SELECT * FROM Customter_with_country WHERE RowNo <= 1