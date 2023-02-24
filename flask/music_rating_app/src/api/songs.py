from flask import Blueprint, jsonify, abort, request
from ..models import User, Artist_Account, Artist, Song, Album, db
import datetime


bp = Blueprint('songs', __name__, url_prefix='/songs')

@bp.route('', methods=['GET'])
def index():

    songs = Song.query.all()
    result = []

    for s in songs:
        result.append(s.serialize())

    return jsonify(result)


@bp.route('/<int:id>', methods=['GET'])
def show(id: int):

    s = Song.query.get_or_404(id)

    return jsonify(s.serialize())


@bp.route('', methods=['POST'])
def create():

    if (
        ('title' not in request.json) or 
        ('year' not in request.json) or 
        ('artist_id' not in request.json) or 
        ('album_id' not in request.json) or 
        ('duration_in_secs' not in request.json)
    ):
        return abort(400)

    Artist.query.get_or_404(request.json['artist_id'])
    Album.query.get_or_404(request.json['album_id'])

    def album_id():
        if 'album_id' in request.json:
            return request.json['album_id']
        else:
            return None

    s = Song(
        title=request.json['title'],
        year=request.json['year'],
        album_id=album_id(),
        artist_id=request.json['artist_id'],
        duration_in_secs=request.json['duration_in_secs']
    )

    db.session.add(s)
    db.session.commit()

    return jsonify(s.serialize())

@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):

    s = Song.query.get_or_404(id)

    try:
        db.session.delete(s)
        db.session.commit()
        return jsonify(True)
    except:
        return jsonify(False)


@bp.route('/<int:id>', methods=['PATCH','PUT'])
def update(id: int):

    s = Song.query.get_or_404(id)

    if 'title' in request.json:
        if len(request.json['title']) > 64:
            return abort(400)
        else:
            s.title = request.json['title']
    
    if 'duration_in_secs' in request.json:
        if request.json['duration_in_secs'] < 1:
            return abort(400)
        else:
            s.duration_in_secs = request.json['duration_in_secs']

    if 'year' in request.json:
        if request.json['year'] > datetime.date.today().year:
            return jsonify({"status": "failure", "message": "current year is less than the year provided"})
        else:
            s.year = request.json['year']
        
    if 'album_id' in request.json:
        Album.query.get_or_404(request.json['album_id'])
        s.album_id = request.json['album_id']
    
    if 'artist_id' in request.json:
        Artist.query.get_or_404(request.json['artist_id'])
        s.artist_id = request.json['artist_id']

    try:
        db.session.commit()
        return jsonify(s.serialize())
    except:
        return jsonify(False)