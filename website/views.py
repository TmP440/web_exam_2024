from flask import (
    Blueprint,
    render_template,
    request,
    flash,
    redirect,
    url_for,
    current_app,
)
from flask_login import login_required, logout_user, current_user
from werkzeug.utils import secure_filename
from .models import Book, Style, Cover, Review
import os, hashlib, markdown, bleach
from . import decorators
from . import db

views = Blueprint("views", __name__)

ALLOWED_EXTENSIONS = ["png", "jpg", "jpeg"]


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def save_book_data(request, id=None):
    title = request.form.get("title")
    style = request.form.getlist("style")
    short_description = bleach.clean(request.form.get("short_description"))
    year = request.form.get("year")
    publisher = request.form.get("publisher")
    author = request.form.get("author")
    pages = request.form.get("pages")

    if not all(
        [
            title,
            style,
            year,
            publisher,
            author,
            pages,
            short_description != "Краткое описание",
        ]
    ):
        flash("Пожалуйста, введите все данные", category="error")
        return redirect(request.url)

    if "file" in request.files:
        file = request.files["file"]
        if file.filename == "":
            flash("Пожалуйста, укажите все данные", category="error")
            return redirect(request.url)
        if file and allowed_file(file.filename):
            file_md5 = hashlib.md5(file.read()).hexdigest()
            filename = secure_filename(file.filename)
            try:
                cover = db.session.scalars(
                    db.select(Cover).where(Cover.MD5_hash == file_md5)
                ).one_or_none()
                if cover:
                    cover_id = cover.id
                else:
                    new_cover = Cover(
                        file_name=filename,
                        MIME_type=file.content_type,
                        MD5_hash=file_md5,
                    )
                    db.session.add(new_cover)
                    db.session.flush()
                    cover_id = new_cover.id
                new_book = Book(
                    title=title,
                    short_description=short_description,
                    year=year,
                    publisher=publisher,
                    author=author,
                    pages=pages,
                    cover_id=cover_id,
                )
                styles = db.session.scalars(
                    db.select(Style).where(Style.id.in_(style))
                ).all()
                new_book.styles.extend(styles)
                db.session.add(new_book)
                db.session.commit()
                book_id = new_book.id
                file.seek(0)
                file.save(os.path.join(current_app.config["UPLOAD_FOLDER"], filename))

                return redirect(url_for("views.view_book", id=book_id))
            except Exception as e:
                db.session.rollback()
                flash(
                    "При сохранении данных возникла ошибка. Проверьте корректность введённых данных.",
                    category="error",
                )
                return redirect(request.url)
    else:
        book = Book.query.get_or_404(id)
        book.title = request.form.get("title")
        book.style = request.form.getlist("style")
        book.short_description = bleach.clean(request.form.get("short_description"))
        book.year = request.form.get("year")
        book.publisher = request.form.get("publisher")
        book.author = request.form.get("author")
        book.pages = request.form.get("pages")
        try:
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            flash(
                "При сохранении данных возникла ошибка. Проверьте корректность введённых данных.",
                category="error",
            )
            return redirect(request.url)


@views.route("/")
def home_page():
    books = Book.query.order_by(Book.year.desc())

    page = request.args.get("page")

    if page and page.isdigit():
        page = int(page)
    else:
        page = 1

    pages = books.paginate(page=page, per_page=10)

    return render_template("home.html", user=current_user, pages=pages)


@views.route("/add_book", methods=["GET", "POST"])
@decorators.role_required("admin")
def add_book():
    if request.method == "POST":
        return save_book_data(request)

    styles = db.session.scalars(db.select(Style)).all()

    return render_template("add_book.html", user=current_user, book=None, styles=styles)


@views.route("/view_book/<int:id>", methods=["GET", "POST"])
@decorators.role_required("admin", "mod", "user")
def view_book(id):
    book = Book.query.get_or_404(id)
    book.short_description = markdown.markdown(book.short_description)

    styles = db.session.scalars(db.select(Style)).all()

    reviews = db.session.scalars(
        db.select(Review).where(Review.book_id == id, Review.status == "accepted")
    ).all()

    user_reviewed = db.session.scalars(
        db.select(Review).where(Review.user_id == current_user.id, Review.book_id == id)
    ).all()

    return render_template(
        "view_book.html",
        user=current_user,
        book=book,
        styles=styles,
        reviews=reviews,
        user_reviewed=user_reviewed,
    )


@views.route("/edit_book/<id>", methods=["GET", "POST"])
@decorators.role_required("admin", "mod")
def edit_book(id):
    book = Book.query.get_or_404(id)

    if request.method == "POST":
        save_book_data(request, id)
        return redirect(url_for("views.home_page"))
    else:
        styles = db.session.scalars(db.select(Style)).all()
        return render_template(
            "edit_book.html", user=current_user, book=book, styles=styles
        )


@views.route("/delete_book/<id>", methods=["GET", "POST"])
@decorators.role_required("admin")
def delete_book(id):
    book = Book.query.get_or_404(id)

    try:
        cover = book.cover
        cover_count = db.session.scalars(
            db.select(Book).where(cover.id == Book.cover_id)
        ).all()
        db.session.delete(book)
        if cover and len(cover_count) == 1:
            file_path = os.path.join(
                current_app.config["UPLOAD_FOLDER"], cover.file_name
            )
            if os.path.exists(file_path):
                os.remove(file_path)
            db.session.delete(cover)

        db.session.commit()

    except Exception as e:
        db.session.rollback()
        flash(f"Error occured: {e}", category="error")

    return redirect(url_for("views.home_page"))


@views.route("/add_review/<id>", methods=["GET", "POST"])
@decorators.role_required("admin", "mod", "user")
def add_review(id):
    book = Book.query.get_or_404(id)

    reviews = db.session.scalars(db.select(Review).where(Review.book_id == id)).all()

    for review in reviews:
        if review.user_id == current_user.id:
            flash("Вы уже оставляли отзыв", category="error")
            return redirect(url_for("views.home_page"))

    if request.method == "POST":
        book_id = id
        user_id = current_user.id
        score = request.form.get("score")
        text = bleach.clean(request.form.get("text"))

        if text == "Напишите свой отзыв":
            flash("Пожалуйста, введите все данные", category="error")
            return redirect(request.url)

        try:
            new_review = Review(
                book_id=book_id, user_id=user_id, score=score, text=text
            )
            db.session.add(new_review)
            db.session.commit()
            flash(" Успешно! Ваш отзыв на проверке", category="success")
            return redirect(url_for("views.view_book", id=book_id))
        except Exception as e:
            db.session.rollback()
            flash(f"Error occured: {e}", category="error")

    return render_template("add_review.html", user=current_user, book=book)


@views.route("/moderating_reviews", methods=["GET", "POST"])
@decorators.role_required("mod")
def moderating_reviews():
    status = request.args.get("status")
    book_id = request.args.get("book_id")
    user_id = request.args.get("user_id")

    if status and book_id and user_id:

        moderated_review = db.session.scalars(
            db.select(Review).where(
                Review.book_id == book_id, Review.user_id == user_id
            )
        ).one_or_none()

        if status == "declined":
            db.session.delete(moderated_review)
        else:
            moderated_review.status = status

        try:
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            flash(
                f"{e}",
                category="error",
            )

    reviews = db.session.scalars(
        db.select(Review).where(Review.status == "pending")
    ).all()
    return render_template(
        "moderating_reviews.html", reviews=reviews, user=current_user
    )


@views.route("/my_reviews", methods=["GET"])
@login_required
def my_reviews():
    reviews = db.session.scalars(
        db.select(Review).where(
            Review.user_id == current_user.id, Review.status == "pending"
        )
    ).all()

    return render_template("my_reviews.html", reviews=reviews, user=current_user)
