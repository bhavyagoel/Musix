import os
import subprocess
from datetime import date
import time
from functools import wraps
import shutil

import phonenumbers
import requests
import spotipy
from bs4 import BeautifulSoup
from flask import Flask, render_template, flash, redirect, url_for, session, request
from flask_mail import Mail, Message
from flask_mysqldb import MySQL
from itsdangerous import URLSafeTimedSerializer, SignatureExpired
from mutagen.mp3 import MP3
from passlib.hash import sha256_crypt
from spotipy.oauth2 import SpotifyClientCredentials
from werkzeug.utils import secure_filename
from wtforms import Form, StringField, PasswordField, validators, SelectField, ValidationError, SelectMultipleField
from threading import Thread
from multiprocessing import Process


def func1():
    # time.sleep(10)
    print('Working', end='')


client_id = '85f1af22460445c79b38a5a34c1cbb95'
client_secret = '4c35ad5c2ed745808f88877495cd09db'
client_credentials_manager = SpotifyClientCredentials(client_id, client_secret)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

app = Flask(__name__)
name = ""
mobile = ""
email = ""
password = ""
unique_id = ""
gender = ""
address = ""
dob = ""
location = ""
duration = ""
unique_id1 = ""
year = ""
location2 = ""
artistList = []
songList = []

app.config['MYSQL_HOST'] = 'remotemysql.com'
app.config['MYSQL_USER'] = 'VajWI9bdaI'
app.config['MYSQL_PASSWORD'] = '3V3jqfy15T'
app.config['MYSQL_DB'] = 'VajWI9bdaI'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

app.config.from_pyfile('config.cfg')
mail = Mail(app)
app.secret_key = 'bhavya123'

s = URLSafeTimedSerializer('secret123')

mysql = MySQL(app)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/Artists')
def artists():
    return render_template("artists.html")


@app.route('/Albums')
def albums():
    return render_template("album.html")


@app.route('/diagram')
def diagram():
    return render_template("diagram.html")


class Spotify(Form):
    queryChoices = [('artist', 'Artist'), ('track', 'Track'), ('album', 'Album')]
    query = SelectField("Category", choices=queryChoices, validators=[validators.DataRequired()], default='track')
    search = StringField('Search', [
        validators.DataRequired(message="Name field can't be empty!!")
    ])


def newest(path):
    files = os.listdir(path)
    paths = [os.path.join(path, basename) for basename in files]
    return max(paths, key=os.path.getctime)


def execute(cmd):
    popen = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, universal_newlines=True)
    for stdout_line in iter(popen.stdout.readline, ""):
        yield stdout_line
    popen.stdout.close()
    return_code = popen.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, cmd)


@app.route('/createSearchData', methods=['GET', 'POST'])
def createSearchData():
    form = Spotify(request.form)

    if request.method == 'POST':

        try:
            if request.form['onPress'] == 'mainSearch':
                query = form.query.data
                search = request.form["Search"]

                songID = [item['id'] for item in
                          sp.search(search, limit=20, offset=0, type=query)['tracks']['items']]
                songName = []
                songArtist = []
                songImage = []
                songUrl = []

                i = 0

                for item in songID:
                    alpha = sp.track(item)
                    songName.append(alpha['name'])
                    if not alpha['album']['images']:
                        songImage.append("https://dummyimage.com/420x260")
                    else:
                        songImage.append(alpha['album']['images'][0]['url'])
                    songUrl.append("https://open.spotify.com/embed/track/" + alpha['uri'].split(':')[2])
                    songArtist.append([])
                    for j in range(len(alpha['artists'])):
                        songArtist[i].append(alpha['artists'][j]['name'])

                    i += 1

                songDet = [{'songName': t[0], 'songID': t[1], 'songArtist': t[2], 'songImage': t[3], 'songUrl': t[4]}
                           for t in
                           zip(songName, songID, songArtist, songImage, songUrl)]
                session['songDet'] = songDet
                session['artDet'] = ""
                flash("Successfully Searched for Songs", 'success')
                # print(request.form.to_dict()["Search"])
                request.form.to_dict()["Search"] = ""
                return render_template('createSearchData.html', form=form)
                # return redirect(url_for('createSearchData'))
        except Exception as e:
            print(e)
            print("FIRST LOOP")
        try:
            if request.form['onPress']:
                fetchID = request.form["onPress"]
                alpha = sp.track(fetchID)
                artistName = []
                artistImage = []
                artistGenre = []

                for i in range(len(alpha['artists'])):
                    artistName.append(alpha['artists'][i]['name'])
                    beta = sp.search(q=alpha['artists'][i]['name'], limit=1, type="artist")
                    if not beta['artists']['items'][0]['images']:
                        artistImage.append("https://dummyimage.com/420x260")
                    else:

                        artistImage.append(beta['artists']['items'][0][
                                               'images'][0]['url'])
                        artistGenre.append(beta['artists']['items'][0]['genres'])
                artDet = [{'artistName': t[0], 'artistImage': t[1], 'artistGenre': t[2]} for t in
                          zip(artistName, artistImage, artistGenre)]
                session['artDet'] = artDet
                flash("Successfully Searched for Artist of song " + alpha['name'], 'success')
                return render_template('createSearchData.html', form=form)
                # return redirect(url_for('createSearchData'))
        except Exception as e:
            print(e)
            print("SECOND LOOP ")
        try:
            if request.form['onPressDown']:
                downloadID = request.form["onPressDown"]
                alpha = sp.track(downloadID)
                songURL = "https://open.spotify.com/track/" + alpha['uri'].split(':')[2]
                imgUrl = ""
                if not alpha['album']['images']:
                    imgUrl = "https://dummyimage.com/420x260"
                else:
                    imgUrl = alpha['album']['images'][0]['url']
                if str(alpha['name']) + '.mp3' not in os.listdir("templates/temp/song"):
                    fileName = str(alpha['name']).replace("\"", "")
                    print(fileName)
                    fileName = fileName.replace("/", "")
                    # fileName = fileName.replace(" ", "\ ")
                    # fileName = str(fileName)
                    filePath = 'templates/temp/image/' + fileName

                    bashCommand1 = "spotdl " + songURL
                    bashCommand2 = "wget " + imgUrl + " -O "
                    bashCommand2 = bashCommand2.split()
                    bashCommand2.append(filePath + ".jpeg")
                    # process = subprocess.Popen(bashCommand1.split(), stdout=subprocess.PIPE, universal_newlines=True)
                    process2 = subprocess.Popen(bashCommand2, stdout=subprocess.PIPE)

                    # output1, error1 = process.communicate()
                    # os.system(bashCommand1)
                    # print(output1)
                    # print(error1)
                    def nw():
                        for path in execute(bashCommand1):
                            print(path, end="", flush=True)

                    # T1 = Thread(target=func1, args=())
                    T2 = Thread(target=nw, args=())
                    # T1.start()
                    T2.start()
                    # for i in range(12):
                    #     if T2.is_alive():
                    #         alpha = Thread(target=func1, args=())
                    #         alpha.start()
                    #         alpha.join()
                    #         time.sleep(10)
                    # T1.join()
                    # T2.join()
                    print("""111111111111111""")

                    output2, error2 = process2.communicate()
                    songLocation = 'templates/temp/song/' + fileName + ".mp3"
                    imgLocation = filePath + ".jpeg"
                    # time.sleep(5)
                    print("""BGGBGGBGBG""")

                    dirFold = os.listdir(os.getcwd())
                    # print(dirFold)
                    if "Temp" in dirFold:
                        shutil.rmtree("Temp")
                    songNew = newest(os.getcwd())
                    os.rename(songNew, songLocation)
                    audio = MP3(songLocation)
                    Duration = audio.info.length
                    audio.clear()
                    releaseYear = alpha['album']['release_date'].split('-')[0]
                    artistDOB = str(date.today())

                    fSong = open("templates/temp/songID.txt", 'r')
                    data = fSong.read()
                    SongID = int(data) + 1
                    fSong.close()

                    fSongUpd = open("templates/temp/songID.txt", 'w')
                    fSongUpd.write(str(SongID))
                    fSongUpd.close()

                    SongName = alpha['name']
                    songID = str(SongID).zfill(7)
                    dbArtist = []
                    for i in range(len(alpha['artists'])):
                        dbArtist.append(alpha['artists'][i]['name'])

                    Genre_ID = "GID0001"
                    cur1 = mysql.connection.cursor()
                    allArtist = []

                    cur1.execute("SELECT * FROM Artist")
                    allArtist1 = cur1.fetchall()

                    for i in allArtist1:
                        allArtist.append(i['Name'])

                    cur1.close()
                    cur = mysql.connection.cursor()
                    artistID = []
                    j = 0
                    for i in range(len(dbArtist)):

                        if dbArtist[i] in allArtist:
                            print("ARTIST EXISTING!!")
                        else:
                            fArtist = open("templates/temp/artistID.txt", 'r')
                            data = fArtist.read()
                            ArtistID = int(data)
                            fArtist.close()

                            ArtistID += 1

                            fArtistUpd = open("templates/temp/artistID.txt", 'w')
                            fArtistUpd.write(str(ArtistID))
                            fArtistUpd.close()

                            ID = str(ArtistID).zfill(8)

                            cur.execute("INSERT INTO Artist(Name,Artist_ID,DOB) "
                                        "VALUES(%s,%s,%s)",
                                        (dbArtist[i], ID, artistDOB))
                            j += 1

                    cur2 = mysql.connection.cursor()
                    for i in range(len(dbArtist)):
                        cur.execute("SELECT Artist_ID FROM Artist WHERE Name=%s", [dbArtist[i]])
                        artistID.append(cur.fetchone()['Artist_ID'])
                    cur2.close()

                    cur.execute(
                        "INSERT INTO Song(Song_ID, Name, Year, Duration ,Genre_ID, SongLocation, ImageLocation) "
                        "VALUES(%s,%s,%s,%s,%s,%s,%s)",
                        (songID, SongName, releaseYear, Duration, Genre_ID, songLocation, imgLocation))
                    for i in range(len(dbArtist)):
                        cur.execute("INSERT INTO Song_Artist(Song_ID, Artist_ID) VALUES (%s,%s)",
                                    (songID, artistID[i]))

                    mysql.connection.commit()
                    cur.close()

                    flash("Successfully Downloaded song " + alpha['name'], 'success')
                else:
                    flash(alpha['name'] + " Already Exists!!", 'danger')
                    print(alpha['name'])

                return render_template('createSearchData.html', form=form)

        except Exception as e:
            print(e)
            print("THIRD LOOP")

    return render_template("createSearchData.html", form=form)


class NewArtist(Form):
    Name = StringField('Artist Name', [
        validators.Length(min=1, max=20, message="Name should be between length 1 and 20."),
        validators.DataRequired(message="Name field can't be empty!!")
    ])
    Artist_ID = StringField("Artist ID", [
        validators.length(7, message="Artist ID should be of length 7"),
        validators.Regexp('^ARID[0-9]{4}', message="UserName should be of format ARID0000"),
        validators.DataRequired(message="Artist ID field can't be empty!!")
    ])
    DOB = StringField("DOB", [
        validators.DataRequired(message="DOB field can't be empty!!")], default=date.today)


@app.route("/add_artist", methods=['GET', 'POST'])
def addArtist():
    form = NewArtist(request.form)

    if request.method == 'POST' and form.validate():
        Name = form.Name.data
        artist_id = form.Artist_ID.data
        DOB = form.DOB.data
        global name, unique_id, dob
        name = Name
        unique_id = artist_id
        dob = DOB

        cur = mysql.connection.cursor()
        result = cur.execute("SELECT * FROM Artist WHERE Artist_ID= %s", [unique_id])
        if result > 0:
            error = 'Artist ID Already Exists, Please try Another Artist ID.'
            return render_template('add_artist.html', form=form, error=error)
        else:
            cur.execute("INSERT INTO Artist(Name,Artist_ID,DOB) "
                        "VALUES(%s,%s,%s)",
                        (name, unique_id, dob))
            mysql.connection.commit()
            cur.close()
            flash('Successfully Added {} with id {}'.format(name, unique_id), 'success')

    return render_template("add_artist.html", form=form)


class NewGenre(Form):
    Name = StringField('Name', [
        validators.Length(min=1, max=20, message="Name should be between length 1 and 20."),
        validators.DataRequired(message="Name field can't be empty!!")
    ])
    Genre_ID = StringField("Genre ID", [
        validators.length(7, message="Genre_ID should be of length 7"),
        validators.Regexp('^GID[0-9]{4}', message="Genre_ID should be of format GID0000"),
        validators.DataRequired(message="Genre_ID field can't be empty!!")
    ])


@app.route("/add_genre", methods=['GET', 'POST'])
def addGenre():
    form = NewGenre(request.form)

    if request.method == 'POST' and form.validate():
        Name = form.Name.data
        genre_id = form.Genre_ID.data
        global name, unique_id
        name = Name
        unique_id = genre_id

        cur = mysql.connection.cursor()
        result = cur.execute("SELECT * FROM Genre WHERE Genre_ID= %s", [unique_id])
        result2 = cur.execute("SELECT * FROM Genre WHERE Name= %s", [name])
        if result > 0 or result2 > 0:
            error = 'Genre ID Or Name Already Exists, Please try Another Genre ID or Name.'
            return render_template('add_genre.html', form=form, error=error)
        else:
            cur.execute("INSERT INTO Genre(Name,Genre_ID) "
                        "VALUES(%s,%s)",
                        (name, unique_id))
            mysql.connection.commit()
            cur.close()
            flash('Successfully Added {} with id {}'.format(name, unique_id), 'success')

    return render_template("add_genre.html", form=form)


class NewSong(Form):
    Name = StringField('Name', [
        validators.Length(min=1, max=50, message="Name should be between length 1 and 50."),
        validators.DataRequired(message="Name field can't be empty!!")
    ])
    Song_ID = StringField("Song ID", [
        validators.length(7, message="Song_ID should be of length 7"),
        validators.Regexp('^SID[0-9]{4}', message="Song_ID should be of format SID0000"),
        validators.DataRequired(message="Song_ID field can't be empty!!")
    ])
    Year = StringField("Year", [
        validators.length(4, message="Year should be like 2000"),
        validators.DataRequired(message="Year field can't be empty!!")
    ])
    Artists = StringField("Artist", [
        validators.length(min=1, max=500),
        validators.DataRequired(message="Year field can't be empty!!")
    ])
    GenreName = SelectField("Genre")


@app.route("/add_song", methods=['GET', 'POST'])
def addSong():
    form = NewSong(request.form)
    cur = mysql.connection.cursor()
    cur.execute("SELECT Name FROM Genre")
    allGenre = cur.fetchall()
    listGen = []
    for i in range(len(allGenre)):
        listGen.append(allGenre[i]['Name'])
    cur.close()
    form.GenreName.choices = listGen

    if request.method == 'POST' and form.validate():
        Name = form.Name.data
        song_id = form.Song_ID.data
        if 'fileSong' not in request.files:
            flash('No Song File Part', 'danger')
            return redirect(request.url)
        fileSong = request.files['fileSong']
        if fileSong.filename == '':
            flash('No Song File Selected', 'danger')
            return redirect(request.url)
        SongFileName = ""
        if fileSong:
            filename = secure_filename(fileSong.filename)
            if not filename.endswith('.mp3'):
                flash("Only mp3 files supported in Song File field.", 'danger')
                return redirect(request.url)
            SongFileName = filename
            fileSong.save(os.path.join('templates/temp/song', filename))
        if 'fileImage' not in request.files:
            flash('No Image File Part', 'danger')
            return redirect(request.url)
        fileImage = request.files['fileImage']
        if fileImage.filename == '':
            flash('No Image File Selected', 'danger')
            return redirect(request.url)
        ImageFileName = ""
        if fileImage:
            filename = secure_filename(fileImage.filename)
            if not filename.endswith(tuple(['.jpg', '.jpeg', '.png'])):
                flash("Only image type files supported in Image File field.", 'danger')
                return redirect(request.url)
            ImageFileName = filename
            fileImage.save(os.path.join('templates/temp/image', filename))

        Location = os.path.join('templates/temp/song', SongFileName)
        ImageLocation = os.path.join('templates/temp/image', ImageFileName)
        audio = MP3(Location)
        Duration = audio.info.length
        audio.clear()
        genreName = form.GenreName.data
        cur = mysql.connection.cursor()
        cur.execute("SELECT Genre_ID FROM Genre WHERE Name=%s", [genreName])
        genreID = cur.fetchone()
        cur.close()
        Year = form.Year.data
        Artists = request.form['Artists']
        Artists = list(Artists.split(','))
        ArtistID = []
        cur = mysql.connection.cursor()
        i = 0
        for i in range(len(Artists)):
            cur.execute("SELECT Artist_ID FROM Artist WHERE Name=%s", [Artists[i]])
            ArtistID.append(cur.fetchone()['Artist_ID'])
        cur.close()
        cur = mysql.connection.cursor()
        global name, unique_id, location, duration, unique_id1, year, artistList, location2
        unique_id = song_id
        name = Name
        unique_id1 = genreID['Genre_ID']
        year = Year
        duration = str(Duration)
        location = Location
        artistList = ArtistID
        location2 = ImageLocation

        result = cur.execute("SELECT * FROM Song WHERE Song_ID= %s", [unique_id])
        result1 = cur.execute("SELECT * FROM Song WHERE SongLocation=%s", [location])
        result3 = cur.execute("SELECT * FROM Song WHERE ImageLocation=%s", [location2])
        flag = 1
        # print(artistList)
        for i in range(len(artistList)):
            result2 = cur.execute("SELECT * FROM Artist WHERE Artist_ID=%s", [artistList[i]])
            if result2 == 0:
                flag = 0
                break;
        if result > 0:
            error = 'Song ID Already Exists, Please try Another Song ID.'
            os.remove(location)
            os.remove(location2)
            return render_template('add_song.html', form=form, error=error)
        elif result1 > 0:
            error = 'Song File Already Exists, Please try Another Song File.'
            os.remove(location)
            os.remove(location2)
            return render_template('add_song.html', form=form, error=error)
        elif result3 > 0:
            error = 'Image File Already Exists, Please try Another Image File.'
            os.remove(location)
            os.remove(location2)
            return render_template('add_song.html', form=form, error=error)
        elif flag == 0:
            error = "Artist does not exist."
            os.remove(location)
            os.remove(location2)
            return render_template('add_song.html', form=form, error=error)
        else:
            cur.execute("INSERT INTO Song(Song_ID, Name, Year, Duration ,Genre_ID, SongLocation, ImageLocation) "
                        "VALUES(%s,%s,%s,%s,%s,%s,%s)",
                        (unique_id, name, year, duration, unique_id1, location, location2))
            for i in range(len(artistList)):
                cur.execute("INSERT INTO Song_Artist(Song_ID, Artist_ID) VALUES (%s,%s,%s)",
                            (unique_id, artistList[i]))

            mysql.connection.commit()
            cur.close()
            flash('Successfully Added {} with id {}'.format(name, unique_id), 'success')

    return render_template("add_song.html", form=form)


class NewAlbum(Form):
    Name = StringField('Name', [
        validators.Length(min=1, max=20, message="Name should be between length 1 and 20."),
        validators.DataRequired(message="Name field can't be empty!!")
    ])
    Album_ID = StringField("Album ID", [
        validators.length(7, message="Album ID should be of length 7"),
        validators.Regexp('^ALID[0-9]{4}', message="Album ID should be of format ALID0000"),
        validators.DataRequired(message="Album ID field can't be empty!!")
    ])
    SongName = SelectMultipleField("Songs")


@app.route('/add_album', methods=['GET', 'POST'])
def AddAlbum():
    form = NewAlbum(request.form)
    cur = mysql.connection.cursor()
    cur.execute("SELECT Name FROM Song")
    allSong = cur.fetchall()
    listSon = []
    for i in range(len(allSong)):
        listSon.append((allSong[i]['Name'], allSong[i]['Name']))
    cur.close()
    form.SongName.choices = listSon

    if request.method == 'POST' and form.validate():
        Name = form.Name.data
        songName = form.SongName.data
        # print(songName)
        SongID = []
        cur = mysql.connection.cursor()
        for i in range(len(songName)):
            cur.execute("SELECT Song_ID FROM Song WHERE Name=%s", [songName[i]])
            SongID.append(cur.fetchone()['Song_ID'])
        cur.close()
        AlbumID = form.Album_ID.data

        global name, unique_id, songList
        name = Name
        songList = SongID
        unique_id = AlbumID
        cur = mysql.connection.cursor()
        result = cur.execute("SELECT * FROM Album WHERE Album_ID= %s", [unique_id])
        if result > 0:
            error = 'Album ID Already Exists, Please try Another Album ID.'
            return render_template('add_song.html', form=form, error=error)
        else:
            cur.execute("INSERT INTO Album(Album_ID, Name) "
                        "VALUES(%s,%s)",
                        (unique_id, name))
            for i in range(len(songList)):
                cur.execute("INSERT INTO Album_Song(Album_ID, Song_ID) VALUES (%s,%s)",
                            (unique_id, songList[i]))
            mysql.connection.commit()
            cur.close()
            flash('Successfully Added {} with id {}'.format(name, unique_id), 'success')
    return render_template('add_album.html', form=form)


class RegisterForm(Form):
    Name = StringField('Name', [
        validators.Length(min=1, max=50, message="Name should be between length 1 and 50."),
        validators.DataRequired(message="Name field can't be empty!!")
    ])
    Gender = SelectField(label='Gender', choices=["Male", "Female", "Others"])
    Email_ID = StringField('Email', [
        validators.Length(min=6, max=50, message="Email should be between length 6 and 50."),
        validators.Email(message="Not a Valid Email Address"),
        validators.DataRequired(message="Email field can't be empty!!")
    ])
    Address = StringField('Address', [
        validators.Length(min=10, max=100, message="Address should be between length 10 and 100."),
        validators.DataRequired(message="Address field can't be empty!!")
    ])
    Mobile = StringField("Mobile", [
        validators.length(min=10, max=15, message="Mobile number should be of proper length!!"),
        validators.DataRequired(message="Mobile field can't be empty!!")
    ])
    User_ID = StringField("UserName", [
        validators.length(7, message="UserName should be of length 7"),
        validators.Regexp('^UID[0-9]{4}', message="UserName should be of format UID0000"),
        validators.DataRequired(message="UserName field can't be empty!!")
    ])

    DOB = StringField("DOB", [
        validators.DataRequired(message="DOB field can't be empty!!")], default=date.today)

    @staticmethod
    def validate_phone(Mobile):
        try:
            p = phonenumbers.parse(Mobile.data)
            if not phonenumbers.is_valid_number(p):
                raise ValueError()
        except (phonenumbers.phonenumberutil.NumberParseException, ValueError):
            raise ValidationError('Invalid Phone Number')

    Password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('Confirm', message='Passwords do not Match')
    ])
    Confirm = PasswordField('Confirm Password')


@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    if request.method == 'POST' and form.validate():
        Name = form.Name.data
        Mobile = form.Mobile.data
        Gender = form.Gender.data
        Address = form.Address.data
        Email_ID = form.Email_ID.data
        Password = sha256_crypt.encrypt(str(form.Password.data))
        user_id = form.User_ID.data
        DOB = form.DOB.data
        global mobile, name, email, password, unique_id, gender, address, dob
        name = Name
        mobile = Mobile
        email = Email_ID
        password = Password
        unique_id = user_id
        address = Address
        gender = Gender
        dob = DOB

        token = s.dumps(email, salt='email-confirm')

        msg = Message('Confirm Email', sender='rs0666993@gmail.com', recipients=[email])

        link = url_for('confirm_email', token=token, _external=True)

        msg.body = 'Your verification link for MusiX is {}'.format(link)

        mail.send(msg)

        cur = mysql.connection.cursor()
        result = cur.execute("SELECT * FROM Register WHERE Register_ID= %s", [unique_id])
        result2 = cur.execute("SELECT * FROM Register WHERE Email_ID=%s AND Mobile=%s", [email, mobile])
        if result > 0:
            error = 'UserName Already Exists, Please try Another UserName.'
            return render_template('register.html', form=form, error=error)
        if result2 > 0:
            error = 'Email and Mobile combination Already Exists, Please try another combination.'
            return render_template('register.html', form=form, error=error)
        else:
            flash('A confirmation link has been sent to your Email', 'success')
        return redirect(url_for('index'))

    return render_template('register.html', form=form)


# sending the confirmation link to email
@app.route('/confirm_email/<token>')
def confirm_email(token):
    cur = mysql.connection.cursor()
    try:
        Email_ID = s.loads(token, salt='email-confirm', max_age=3600)
    except SignatureExpired:
        flash('The confirmation link is Invalid or has Expired!!', 'danger')
    else:
        cur.execute("INSERT INTO Register(Name,Gender,Address,Mobile, Email_ID, Password, Register_ID) "
                    "VALUES(%s,%s,%s,%s,%s,%s,%s)",
                    (name, gender, address, mobile, email, password, unique_id))
        cur.execute("INSERT INTO User(Name, DOB, User_ID) VALUES (%s, %s, %s)",
                    (name, dob, unique_id))
        cur.execute("INSERT INTO Login(Login_ID, Password) VALUES (%s,%s)",
                    (unique_id, password))
        mysql.connection.commit()
        cur.close()

        msg = Message('UserName for MusiX', sender='rs0666993@gmail.com', recipients=[email])

        msg.body = 'Your UserName is {}'.format(unique_id)

        mail.send(msg)

        flash('Successfully Verified', 'success')
    return redirect(url_for('login'))


# login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':

        user_id = request.form["User_ID"]

        Password1 = request.form['Password']

        cur = mysql.connection.cursor()
        cur2 = mysql.connection.cursor()

        result = cur.execute("SELECT * FROM Login WHERE Login_ID= %s", [user_id])
        result2 = cur2.execute("SELECT * FROM User WHERE User_ID=%s", [user_id])

        if result > 0:
            data = cur.fetchone()
            data2 = cur2.fetchone()
            Password = data['Password']

            if sha256_crypt.verify(Password1, Password):
                session['logged_in'] = True
                session['username'] = user_id
                session['id'] = data['Login_ID']
                session['name'] = data2['Name']

                flash('Login Successful', 'success')
                return redirect(url_for('index'))
            else:
                error = 'Wrong Password!!'

            cur.close()
            cur2.close()
            return render_template('login.html', error=error)
        else:
            error = 'Username not Found!!'
            return render_template('login.html', error=error)

    return render_template('login.html')


# to prevent using of app without login
def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash('Unauthorised, Please Login', 'danger')
            return redirect(url_for('login'))

    return wrap


# logout
@app.route('/logout')
def logout():
    session.clear()
    flash('You are now Logged Out', 'success')
    return redirect(url_for('index'))


# search
@app.route('/new', methods=['POST'])
def new():
    string = ""
    co = request.form['give']
    song = co
    song_name = co + '.mp3'
    cur = mysql.connection.cursor()
    result = cur.execute("SELECT * FROM songs_list WHERE song_name=%s", [song_name])
    albu69 = cur.fetchall()
    if result > 0:
        return render_template('search.html', albu=albu69)
    else:
        try:
            page = requests.get("https://www.youtube.com/results?search_query=" + song)
            soup = BeautifulSoup(page.text, 'html.parser')
            for div in soup.find_all('div', {"class": "yt-lockup-video"}):
                if div.get("data-context-item-id") is not None:
                    video_id = div.get("data-context-item-id")
                    break
            os.system(
                'youtube-dl --extract-audio --audio-format mp3 -o "akhil.mp3" https://www.youtube.com/watch?v=' + video_id)
            os.system("mv *.mp3 ./static/music/")
            os.rename("static/music/akhil.mp3", "static/music/" + song_name)
            string = "/static/music/" + song_name
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO songs_list(path,album,song_name) VALUES (%s,%s,%s)", (string, "NA", song_name))
            mysql.connection.commit()
            result = cur.execute("SELECT * FROM songs_list WHERE song_name=%s", [song_name])
            albu99 = cur.fetchall()
            return render_template('search.html', albu=albu99)
        except NameError:
            flash('Song Not Found', 'success')
            return render_template('dashboard.html')


@app.route('/dashboard')
@is_logged_in
def dashboard():
    cur = mysql.connection.cursor()

    # result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    #
    # songs = cur.fetchall()
    #
    # if result > 0:
    #     return render_template('dashboard.html', songs=songs)
    # else:
    #     msg = "NO PLAYLIST FOUND "
    # cur.close()
    return render_template('dashboard.html', msg="DASHBOARD")


class make_playlist(Form):
    title = StringField('Name', [validators.Length(min=1, max=25)])


@app.route('/create_playlist', methods=['GET', 'POST'])
@is_logged_in
def create_playlist():
    form = make_playlist(request.form)
    if request.method == 'POST' and form.validate():
        title = form.title.data

        cur = mysql.connection.cursor()

        # result=cur.execute("SELECT * FROM users WHERE username= %s",[{{session.username}}])
        username = session['username']

        row = cur.execute("SELECT * FROM users WHERE username = %s", [username])
        result = cur.fetchone()
        idd = result['id']
        cur.execute("INSERT INTO songs(title,user_id) VALUES (%s,%s)", ([title], idd,))
        cur.execute("UPDATE songs SET type=1 WHERE title=%s", ([title]))
        mysql.connection.commit()
        cur.close()

        flash(idd, 'success')

        return redirect(url_for('dashboard'))
    return render_template('add_playlist.html', form=form)


@app.route('/create_private_playlist', methods=['GET', 'POST'])
@is_logged_in
def create_private_playlist():
    form = make_playlist(request.form)
    if request.method == 'POST' and form.validate():
        title = form.title.data

        cur = mysql.connection.cursor()

        # result=cur.execute("SELECT * FROM users WHERE username= %s",[{{session.username}}])
        username = session['username']

        row = cur.execute("SELECT * FROM users WHERE username = %s", [username])
        result = cur.fetchone()
        idd = result['id']
        cur.execute("INSERT INTO songs(title,user_id) VALUES (%s,%s)", ([title], idd))
        cur.execute("UPDATE songs SET type=0 WHERE title=%s", ([title]))
        mysql.connection.commit()
        cur.close()

        flash(idd, 'success')

        return redirect(url_for('dashboard'))
    return render_template('add_playlist.html', form=form)


@app.route('/users')
@is_logged_in
def users():
    # cur = mysql.connection.cursor()
    # result = cur.execute("SELECT * from users")
    # songs = cur.fetchall()
    # if result > 0:
    #     return render_template('user.html', songs=songs)
    # else:
    #     msg = "NO PLAYLIST FOUND "
    # cur.close()
    return render_template('user.html', msg="USERS")


@app.route('/users/playlist/<string:idd>')
@is_logged_in
def u_play(idd):
    cur = mysql.connection.cursor()
    result = cur.execute("SELECT * from songs WHERE user_id=%s and type=1", [idd])
    songs = cur.fetchall()
    if result > 0:
        return render_template('das.html', songs=songs)
    else:
        msg = "NO PLAYLIST FOUND "
    return render_template('das.html', msg=msg)
    cur.close()


@app.route('/Reputation')
@is_logged_in
def play():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'rep%'")
    albu = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('home.html', songs=songs, albu=albu)
    else:
        songs = 0
        return render_template('home.html', albu=albu, song=songs)
    cur.close()
    #    app.logger.info(albu[11]["path"]
    return render_template('home.html', albu=albu)


@app.route('/Camila')
@is_logged_in
def cam():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'Cam%'")
    albu1 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('camila.html', songs=songs, albu=albu1)
    else:
        songs = 0
        return render_template('camila.html', albu=albu1, song=songs)
    cur.close()
    #    app.logger.info(albu[11]["path"]
    return render_template('camila.html', albu=albu1)


@app.route('/CTRL')
@is_logged_in
def sza():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'SZA%'")
    albu2 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('ctrl.html', songs=songs, albu=albu2)
    else:
        songs = 0
        return render_template('ctrl.html', albu=albu2, song=songs)
    cur.close()
    #    app.logger.info(albu[11]["path"]
    return render_template('ctrl.html', albu=albu2)


@app.route('/BlackPanther')
@is_logged_in
def panther():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'bla%'")
    albu3 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('blackpanther.html', songs=songs, albu=albu3)
    else:
        songs = 0
        return render_template('blackpanther.html', albu=albu3, song=songs)
    cur.close()
    #    app.logger.info(albu[11]["path"]
    return render_template('blackpanther.html', albu=albu3)


@app.route('/Damn')
@is_logged_in
def damn():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'Ken%'")
    albu4 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('damn.html', songs=songs, albu=albu4)
    else:
        songs = 0
        return render_template('damn.html', albu=albu4, song=songs)
    cur.close()
    #    app.logger.info(albu[11]["path"]
    return render_template('damn.html', albu=albu4)


@app.route('/SGFG')
@is_logged_in
def sgfg():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE '5 S%'")
    albu5 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('sgfg.html', songs=songs, albu=albu5)
    else:
        songs = 0
        return render_template('sgfg.html', albu=albu5, song=songs)
    cur.close()


@app.route('/revival')
@is_logged_in
def revival():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'Emi%'")
    albu6 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('revival.html', songs=songs, albu=albu6)
    else:
        songs = 0
        return render_template('revival.html', albu=albu6, song=songs)
    cur.close()


#	app.logger.info(albu5[14]["path"])

@app.route('/ManOfWoods')
@is_logged_in
def manof():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs_list WHERE album LIKE 'Jus%'")
    albu7 = cur.fetchall()
    result = cur.execute("SELECT * from songs WHERE user_id = %s", [session['id']])
    songs = cur.fetchall()
    if result > 0:
        return render_template('manofwoods.html', songs=songs, albu=albu7)
    else:
        songs = 0
        return render_template('manofwoods.html', albu=albu7, song=songs)
    cur.close()


@app.route('/save_playlist/<string:name>/<string:ide>')
@is_logged_in
def save(name, ide):
    res = ""
    playl = []
    flag = 0
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs WHERE title = %s and user_id=%s", ([name], [session['id']]))
    result = cur.fetchone()
    print(name)
    if result['_songs'] is None:
        cur.execute("UPDATE songs SET _songs=%s WHERE title=%s and user_id=%s", (ide, name, session['id']))
        mysql.connection.commit()

    else:
        res = result['_songs']
        playl = res.split("'")

        for i in playl:
            if i == ide:
                flag = 1
        if flag == 1:
            flash("songs already exist", 'danger')
            return redirect(url_for('dashboard'))
        else:
            cur.execute("UPDATE songs SET _songs=CONCAT(%s'',_songs) WHERE title=%s and user_id=%s",
                        (ide, name, session['id']))

        mysql.connection.commit()

    cur.close()
    flash("Song is added to playlist", 'success')
    return redirect(url_for('dashboard'))


@app.route('/delete_playlist/<string:idd>')
@is_logged_in
def delete_playlist(idd):
    cur = mysql.connection.cursor()
    cur.execute("delete  FROM songs WHERE id =%s", [idd])
    mysql.connection.commit()
    cur.close()
    flash("Playlist successfully deleted", 'success')
    return redirect(url_for('dashboard'))


@app.route('/connect')
def connect():
    return render_template('connect.html')


@app.route('/play_playlist/<string:idd>')
@is_logged_in
def play_playlist(idd):
    res = ""
    playl = []
    data = []
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM songs WHERE id =%s", [idd])
    result = cur.fetchone()
    res = result['_songs']
    if res is None:
        flash("no song in playlist", 'danger')
        return redirect(url_for('dashboard'))
    else:
        playl = res.split("'")
        length = len(playl)
        for i in playl:
            cur.execute("SELECT * FROM songs_list WHERE id=%s", [i])
            data.append(cur.fetchone())
        cur.execute("SELECT * FROM songs WHERE id=%s", [idd])
        name = cur.fetchone()
        Name = name['title']
        return render_template('playlist.html', albu=data, Name=Name, len=length)


if __name__ == '__main__':
    app.secret_key = 'secret123'
    app.run(debug=True, threaded=True)
