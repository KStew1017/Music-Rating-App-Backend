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

bp = Blueprint('artist_accounts', __name__, url_prefix='/artist_accounts')


@bp.route('', methods=['GET'])
def index():

    artist_accounts = Artist_Account.query.all()
    result = []

    for aa in artist_accounts:
        result.append(aa.serialize())

    return jsonify(result)


@bp.route('/<int:id>', methods=['GET'])
def show(id: int):

    aa = Artist_Account.query.get_or_404(id)

    return jsonify(aa.serialize())


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
    
    aa = Artist_Account(
        username=request.json['username'],
        password=scramble(request.json['password']),
        email=email()
    )

    try:
        db.session.add(aa)
        db.session.commit()
        return jsonify(aa.serialize())
    except:
        return jsonify({"status": "failure", "message": "could not create new artist account"})


@bp.route('/<int:id>', methods=['PATCH','PUT'])
def update(id:int):

    aa = Artist_Account.query.get_or_404(id)

    if (
        ('username' not in request.json) and
        ('password' not in request.json) and
        ('email' not in request.json)
    ):
        return abort(400)

    if 'username' in request.json:
        if len(request.json['username']) < 3:
            return abort(400)
        else:
            aa.username = request.json['username']
    
    if 'password' in request.json:
        if len(request.json['password']) < 8:
            return abort(400)
        else:
            aa.password = scramble(request.json['password'])
    
    if 'email' in request.json:
        email_regex =  r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
        if not re.fullmatch(email_regex, request.json['email']):
            return jsonify({"status": "failure", "message": "please provide a valid email address"})
        elif request.json['email'] in aa.email:
            return jsonify({"status": "failure", "message": "please use a different email than the one you currently have"})
        else:
            aa.email = request.json['email']
    
    try:
        db.session.commit()
        return jsonify(aa.serialize())
    except:
        return jsonify({"status": "failure", "message": "user does not exist"})


@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):

    aa = Artist_Account.query.get_or_404(id)

    try:
        db.session.delete(aa)
        db.session.commit()
        return jsonify(True)
    except:
        return jsonify(False)