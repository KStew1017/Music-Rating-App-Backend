from flask import Blueprint, jsonify, abort, request
from ..models import User, Artist_Account, Artist, Song, Album, db
import datetime


bp = Blueprint('albums', __name__, url_prefix='/albums')

@bp.route('', methods=['GET'])
def index():

    albums = Album.query.all()
    result = []

    for a in albums:
        result.append(a.serialize())

    return jsonify(result)


@bp.route('/<int:id>', methods=['GET'])
def show(id: int):

    a = Album.query.get_or_404(id)

    return jsonify(a.serialize())


@bp.route('', methods=['POST'])
def create():

    if (
        ('title' not in request.json) or
        ('year' not in request.json) or
        ('artist_id' not in request.json) or
        ('tracklist_length' not in request.json)
    ):
        return abort(400)

    Artist.query.get_or_404(request.json['artist_id'])

    a = Album(
        title=request.json['title'],
        year=request.json['year'],
        tracklist_length=request.json['tracklist_length'],
        artist_id=request.json['artist_id']
    )

    db.session.add(a)
    db.session.commit()

    return jsonify(a.serialize())


@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):

    a = Album.query.get_or_404(id)

    try:
        db.session.delete(a)
        db.session.commit()
        return jsonify(True)
    except:
        return jsonify(False)


@bp.route('/<int:id>', methods=['PATCH','PUT'])
def update(id: int):

    a = Album.query.get_or_404(id)

    if 'title' in request.json:
        if len(request.json['title']) > 64:
            return abort(400)
        else:
            a.title = request.json['title']
    
    if 'tracklist_length' in request.json:
        if request.json['tracklist_length'] < 1:
            return abort(400)
        else:
            a.tracklist_length = request.json['tracklist_length']

    if 'year' in request.json:
        if request.json['year'] > datetime.date.today().year:
            return jsonify({"status": "failure", "message": "current year is less than the year provided"})
        else:
            a.year = request.json['year']
    
    try:
        db.session.commit()
        return jsonify(a.serialize())
    except:
        return jsonify(False)