from flask import Blueprint, jsonify, abort, request
from ..models import User, Artist_Account, Artist, Song, Album, db, users_albums, users_songs
import datetime
import hashlib
import secrets
import re
import psycopg2


bp = Blueprint('artists', __name__, url_prefix='/artists')


@bp.route('', methods=['GET'])
def index():

    artists = Artist.query.all()
    result = []

    for a in artists:
        result.append(a.serialize())

    return jsonify(result)


@bp.route('/<int:id>', methods=['GET'])
def show(id: int):

    a = Artist.query.get_or_404(id)

    return jsonify(a.serialize())


@bp.route('', methods=['POST'])
def create():

    if (
        ('name' not in request.json) or
        ('account_id' not in request.json)
    ):
        return abort(400)
    
    def verified():
        if 'verified' in request.json:
            return request.json['verified']
        else:
            return False

    def followers():
        if 'followers' in request.json:
            return request.json['followers']
        else:
            return 0

    def bio():
        if 'bio' in request.json:
            return request.json['bio']
        else:
            return None

    a = Artist(
        name=request.json['name'],
        account_id=request.json['account_id'],
        verified=verified(),
        followers=followers(),
        bio=bio()
    )

    try:
        db.session.add(a)
        db.session.commit()
        return jsonify(a.serialize())
    except:
        return jsonify({"status": "failure", "message": "could not create new artist"})


@bp.route('/<int:id>', methods=['PATCH','PUT'])
def update(id:int):

    a = Artist.query.get_or_404(id)

    if (
        ('name' not in request.json) and
        ('account_id' not in request.json) and
        ('verified' not in request.json) and
        ('followers' not in request.json) and
        ('bio' not in request.json)
    ):
        return abort(400)
    
    if 'name' in request.json:
        a.name = request.json['name']

    if 'account_id' in request.json:
        a.account_id = request.json['account_id']
    
    if 'verified' in request.json:
        a.verified = request.json['verified']

    if 'followers' in request.json:
        a.followers = request.json['followers']
    
    if 'bio' in request.json:
        a.bio = request.json['bio']

    try:
        db.session.commit()
        return jsonify(a.serialize())
    except:
        return jsonify({"status": "failure", "message": "could not update"})


@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):

    a = User.query.get_or_404(id)

    try:
        db.session.delete(a)
        db.session.commit()
        return jsonify(True)
    except:
        return jsonify(False)