from flask import Blueprint, jsonify, abort, request
from ..models import User, Artist_Account, Artist, Song, Album, db, users_albums, users_songs
import datetime
import hashlib
import secrets
import re
import psycopg2


def scramble(password: str):
    """Hash and salt the given password"""
    salt = secrets.token_hex(16)
    return hashlib.sha512((password + salt).encode('utf-8')).hexdigest()

bp = Blueprint('users', __name__, url_prefix='/users')


@bp.route('', methods=['GET'])
def index():

    users = User.query.all()
    result = []

    for u in users:
        result.append(u.serialize())

    return jsonify(result)


@bp.route('/<int:id>', methods=['GET'])
def show(id: int):

    u = User.query.get_or_404(id)

    return jsonify(u.serialize())


@bp.route('', methods=['POST'])
def create():

    if (
        ('username' not in request.json) or
        ('password' not in request.json)
    ):
        return abort(400)
    
    if len(request.json['username']) < 3 or len(request.json['password']) < 8:
        return abort(400)
    
    if 'email' in request.json:
        email_regex =  r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
        if not re.fullmatch(email_regex, request.json['email']):
            return jsonify({"status": "failure", "message": "please provide a valid email address"})

    def email():
        if 'email' in request.json:
            return request.json['email']
        else:
            return None

    u = User(
        username=request.json['username'],
        password=scramble(request.json['password']),
        email=email(),
        private=request.json['private']
    )

    try:
        db.session.add(u)
        db.session.commit()
        return jsonify(u.serialize())
    except:
        return jsonify({"status": "failure", "message": "a user with this information already exists"})


@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):

    u = User.query.get_or_404(id)

    try:
        db.session.delete(u)
        db.session.commit()
        return jsonify(True)
    except:
        return jsonify(False)


@bp.route('/<int:id>', methods=['PATCH','PUT'])
def update(id: int):

    u = User.query.get_or_404(id)

    if 'username' not in request.json and 'password' not in request.json and 'email' not in request.json:
        return abort(400)
    
    if 'username' in request.json:
        if len(request.json['username']) < 3:
            return abort(400)
        else:
            u.username = request.json['username']
    
    if 'password' in request.json:
        if len(request.json['password']) < 8:
            return abort(400)
        else:
            u.password = scramble(request.json['password'])

    if 'email' in request.json:
        email_regex =  r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
        if not re.fullmatch(email_regex, request.json['email']):
            return jsonify({"status": "failure", "message": "please provide a valid email address"})
        elif request.json['email'] in u.email:
            return jsonify({"status": "failure", "message": "please use a different email than the one you currently have"})
        else:
            u.email = request.json['email']
        
    try:
        db.session.commit()
        return jsonify(u.serialize())
    except:
        return jsonify({"status": "failure", "message": "user does not exist"})


###                                                      ###
### Raw SQL approach for many-to-many association tables ###
###                                                      ###


conn = psycopg2.connect(
    """
    dbname=music_rating_app user=postgres host=localhost port=5432
    """
)
conn.set_session(autocommit=True)
cur = conn.cursor()


@bp.route('/<int:id>/songs_rated', methods=['GET'])
def show_songs_rated(id: int):

    u = User.query.get_or_404(id)

    cur.execute(f"""SELECT song_id, rating FROM users_songs WHERE user_id = {id}""")
    song_ratings = cur.fetchall()
    ratings = []

    for song in song_ratings:
        rating = {
            'song_id': song[0],
            'rating': song[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)


@bp.route('/<int:id>/albums_rated', methods=['GET'])
def show_albums_rated(id: int):

    u = User.query.get_or_404(id)

    cur.execute(f"""SELECT album_id, rating FROM users_albums WHERE user_id = {id}""")
    album_ratings = cur.fetchall()
    ratings = []

    for album in album_ratings:
        rating = {
            'album_id': album[0],
            'rating': album[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)


@bp.route('/<int:id>/songs_rated', methods=['POST'])
def create_song_rating(id: int):

    u = User.query.get_or_404(id)

    song_id = request.json['song_id']
    rating = request.json['rating']

    try:
        cur.execute(f"""INSERT INTO users_songs (user_id, song_id, rating) VALUES ({id}, {song_id}, {rating})""")
    except:
        return abort(400)

    cur.execute(f"""SELECT song_id, rating FROM users_songs WHERE user_id = {id}""")
    song_ratings = cur.fetchall()
    ratings = []

    for song in song_ratings:
        rating = {
            'song_id': song[0],
            'rating': song[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)


@bp.route('/<int:id>/albums_rated', methods=['POST'])
def create_album_rating(id: int):

    u = User.query.get_or_404(id)

    album_id = request.json['album_id']
    rating = request.json['rating']

    try:
        cur.execute(f"""INSERT INTO users_albums (user_id, album_id, rating) VALUES ({id}, {album_id}, {rating})""")
    except:
        return abort(400)

    cur.execute(f"""SELECT album_id, rating FROM users_albums WHERE user_id = {id}""")
    album_ratings = cur.fetchall()
    ratings = []

    for album in album_ratings:
        rating = {
            'album_id': album[0],
            'rating': album[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)


@bp.route('/<int:id>/songs_rated', methods=['PATCH','PUT'])
def update_song_rating(id: int):

    u = User.query.get_or_404(id)

    song_id = request.json['song_id']
    rating = request.json['rating']

    try:
        cur.execute(f"""UPDATE users_songs SET rating = {rating} WHERE (user_id = {id} AND song_id = {song_id})""")
    except:
        return abort(400)

    cur.execute(f"""SELECT song_id, rating FROM users_songs WHERE user_id = {id}""")
    song_ratings = cur.fetchall()
    ratings = []

    for song in song_ratings:
        rating = {
            'song_id': song[0],
            'rating': song[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)


@bp.route('/<int:id>/albums_rated', methods=['PATCH','PUT'])
def update_album_rating(id: int):

    u = User.query.get_or_404(id)

    album_id = request.json['album_id']
    rating = request.json['rating']

    try:
        cur.execute(f"""UPDATE users_albums SET rating = {rating} WHERE (user_id = {id} AND album_id = {album_id})""")
    except:
        return abort(400)

    cur.execute(f"""SELECT album_id, rating FROM users_albums WHERE user_id = {id}""")
    album_ratings = cur.fetchall()
    ratings = []

    for album in album_ratings:
        rating = {
            'album_id': album[0],
            'rating': album[1]
        }
        ratings.append(rating)
    
    return jsonify(ratings)

