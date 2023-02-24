from flask_sqlalchemy import SQLAlchemy
from flask import jsonify
import datetime


db = SQLAlchemy()

users_albums = db.Table(
    'users_albums',

    db.Column(
        'user_id',
        db.Integer,
        db.ForeignKey('users.id'),
        primary_key=True
    ),

    db.Column(
        'album_id',
        db.Integer,
        db.ForeignKey('albums.id'),
        primary_key=True
    ),

    db.Column(
        'rating',
        db.Float,
        nullable=False
    )
)

users_songs = db.Table(
    'users_songs',

    db.Column(
        'user_id',
        db.Integer,
        db.ForeignKey('users.id'),
        primary_key=True
    ),

    db.Column(
        'song_id',
        db.Integer,
        db.ForeignKey('songs.id'),
        primary_key=True
    ),

    db.Column(
        'rating',
        db.Float,
        nullable=False
    )
)

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(128), unique=True)
    username = db.Column(db.String(128), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    private = db.Column(db.Boolean, default=False, nullable=False)

    def __init__(self, email:str, username:str, password:str, private:bool()):
        self.email = email
        self.username = username
        self.password = password
        self.private = private
    
    def serialize(self):
        return {
            'id': self.id,
            'email': self.email,
            'username': self.username,
            'private': self.private
        }


class Artist_Account(db.Model):
    __tablename__ = 'artist_accounts'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    artist = db.relationship('Artist', backref='artist_accounts', cascade='all,delete')
    email = db.Column(db.String(128), unique=True)
    username = db.Column(db.String(128), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)

    def __init__(self, username:str, password:str, email:str):
        self.username = username 
        self.password = password
        self.email = email
    
    def serialize(self):
        return {
            'id': self.id,
            'email': self.email,
            'username': self.username,
        }

class Artist(db.Model):
    __tablename__ = 'artists'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    account_id = db.Column(db.Integer, db.ForeignKey('artist_accounts.id'), nullable=False)
    name = db.Column(db.String(128), nullable=False)
    verified = db.Column(db.Boolean, default=False, nullable=False)
    followers = db.Column(db.Integer, default=0)
    bio = db.Column(db.String(256), default=None)
    songs = db.relationship('Song', backref='artist', cascade='all,delete')
    albums = db.relationship('Album', backref='artist', cascade='all,delete')

    def __init__(self, name:str, account_id:int, verified:bool(), followers:int, bio:str):
        self.name = name
        self.account_id = account_id
        self.verified = verified
        self.followers =followers
        self.bio = bio

    def serialize(self):
        return {
            'id': self.id,
            'account_id': self.account_id,
            'name': self.name,
            'verified': self.verified,
            'followers': self.followers,
            'bio': self.bio
        }

class Song(db.Model):
    __tablename__ = 'songs'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    artist_id = db.Column(db.Integer, db.ForeignKey('artists.id'), nullable=False)
    album_id = db.Column(db.Integer, db.ForeignKey('albums.id'))
    title = db.Column(db.String(64), nullable=False)
    duration_in_secs = db.Column(db.Integer, nullable=False)
    year = db.Column(db.Integer, nullable=False)
    song_rating = db.relationship(
        'User',
        secondary=users_songs,
        lazy='subquery',
        backref=db.backref('show_songs_rated', lazy=True)
    )

    def __init__(self, title:str, duration_in_secs:int, year:int, artist_id:int, album_id:int):
        self.title = title
        self.duration_in_secs = duration_in_secs
        self.year = year
        self.artist_id = artist_id
        self.album_id = album_id
    
    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'year': self.year,
            'artist': self.artist_id,
            'album': self.album_id, 
            'duration_in_secs': self.duration_in_secs
        }

class Album(db.Model):
    __tablename__ = 'albums'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    artist_id = db.Column(db.Integer, db.ForeignKey('artists.id'), nullable=False)
    title = db.Column(db.String(64), nullable=False)
    tracklist_length = db.Column(db.Integer, nullable=False)
    year = db.Column(db.Integer, nullable=False)
    album_rating = db.relationship(
        'User',
        secondary=users_albums,
        lazy='subquery',
        backref=db.backref('show_albums_rated', lazy=True)
    )

    def __init__(self, title:str, tracklist_length:int, year:int, artist_id:int):
        self.title = title
        self.tracklist_length = tracklist_length
        self.year = year
        self.artist_id = artist_id
    
    def serialize(self):
        return {
            'artist': self.artist_id,
            'id': self.id,
            'title': self.title,
            'year': self.year,
            'tracklist_length': self.tracklist_length,
        }

