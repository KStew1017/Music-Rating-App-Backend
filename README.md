# Music Rating App  

This Flask project emulates an application whose core functionality allows users to rate different songs and albums, then storing this data on a local PostgreSQL database. Along with ratings, the database also stores things like song and album information, user information, and artist specific information, including artist accounts.  

A lightweight REST API was also implemented to allow basic CRUD requests to be submitted to the database. This includes endpoints for creating, indexing, updating, and deleting new songs, albums, user/artist accounts, and ratings.  


Markdown API table:  

| Blueprints | Path | Methods |
|---|---|---|
| songs | /songs | POST: ' '<br> GET: ' '<br> GET: '/< int:id >'<br> PATCH/PUT: '/< int:id >'<br> DELETE: '/< int:id >'<br> |
| albums | /albums | POST: ' '<br> GET: ' '<br> GET: '/< int:id >'<br> PATCH/PUT: '/< int:id >'<br> DELETE: '/< int:id >'<br> |
| artists | /artists | POST: ' '<br> GET: ' '<br> GET: '/< int:id >'<br> PATCH/PUT: '/< int:id >'<br> DELETE: '/< int:id >'<br> |
| artist_accounts | /artist_accounts | POST: ' '<br> GET: ' '<br> GET: '/< int:id >'<br> PATCH/PUT: '/< int:id >'<br> DELETE: '/< int:id >'<br> |
| users | /users | POST: ' '<br> POST: '/< int:id >/songs_rated'<br> POST: '/< int:id >/albums_rated'<br> GET: ' '<br> GET: '/< int:id >'<br> GET: '/< int:id >/songs_rated'<br> GET: '/< int:id >/albums_rated'<br> PATCH/PUT: '/< int:id >'<br> PATCH/PUT: '/< int:id >/songs_rated'<br> PATCH/PUT: '/< int:id >/albums_rated'<br> DELETE: '/< int:id >' |  


The design for this project evolved over time as I began implementing the schema into actual SQL query. By referring to the ER Diagram and comparing the schema planned there to the one actualyl implemented you can see certain attributes were added or excluded for example. Additionally, the uniquness and nullablity of some attributes changed as the design was implemented and throught through more.  

A majority of the API was created using the SQLAlchemy ORM. However, the endpoints for the many-to-many association tables storing user ratings for songs and albums used raw SQL queries via the psycopg2 database adapter as a way to learn different techniques.  

An endpoint I would like to implement in the future is a DELETE endpoint for user ratings, as there is currently no way for a user to completely remove a rating from a song or album, only change it. Also, I would like a way to retrieve a specific song or album rating belonging to a user rather than a complete list of all ratings.