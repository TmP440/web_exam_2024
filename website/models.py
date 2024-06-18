from . import db
from flask_login import UserMixin
from sqlalchemy.sql import func
from sqlalchemy.orm import Mapped, mapped_column


class Role(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(db.String(64), nullable=False, unique=True)
    description: Mapped[str] = mapped_column(
        db.String(100), nullable=False, unique=True
    )

    users: Mapped[list["User"]] = db.relationship(back_populates="role", uselist=True)


class User(db.Model, UserMixin):
    id: Mapped[int] = mapped_column(primary_key=True)
    login: Mapped[str] = mapped_column(db.String(32), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(db.String(300), nullable=False)
    last_name: Mapped[str] = mapped_column(db.String(64), nullable=False)
    first_name: Mapped[str] = mapped_column(db.String(64), nullable=False)
    middle_name: Mapped[str] = mapped_column(db.String(64))
    role_id: Mapped[int] = mapped_column(db.ForeignKey("role.id"))

    role: Mapped["Role"] = db.relationship(back_populates="users", uselist=False)
    reviews: Mapped[list["Review"]] = db.relationship(
        back_populates="user", uselist=True
    )


class Book(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column(db.String(200), unique=True, nullable=False)
    short_description: Mapped[str] = mapped_column(db.Text, nullable=False)
    year: Mapped[int] = mapped_column(db.SmallInteger, nullable=False)
    publisher: Mapped[str] = mapped_column(db.String(64), nullable=False)
    author: Mapped[str] = mapped_column(db.String(64), nullable=False)
    pages: Mapped[int] = mapped_column(nullable=False)
    cover_id: Mapped[int] = mapped_column(db.ForeignKey("cover.id"))

    cover: Mapped["Cover"] = db.relationship(back_populates="books", uselist=False)
    styles: Mapped[list["Style"]] = db.relationship(
        back_populates="books", uselist=True, secondary="book_style"
    )
    reviews: Mapped[list["Review"]] = db.relationship(
        back_populates="book", uselist=True, cascade="all, delete-orphan"
    )


class Style(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    style_name: Mapped[str] = mapped_column(db.String(200), nullable=False, unique=True)

    books: Mapped[list["Book"]] = db.relationship(
        back_populates="styles",
        uselist=True,
        secondary="book_style",
    )


class book_style(db.Model):
    book_id = mapped_column(db.ForeignKey("book.id"), primary_key=True)
    style_id = mapped_column(db.ForeignKey("style.id"), primary_key=True)


class Cover(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    file_name: Mapped[str] = mapped_column(db.String(200), nullable=False)
    MIME_type: Mapped[str] = mapped_column(db.String(200), nullable=False)
    MD5_hash: Mapped[str] = mapped_column(db.String(200), nullable=False)

    books: Mapped[list["Book"]] = db.relationship(back_populates="cover", uselist=True)


class Review(db.Model):
    book_id: Mapped[int] = mapped_column(db.ForeignKey("book.id"), primary_key=True)
    user_id: Mapped[int] = mapped_column(db.ForeignKey("user.id"), primary_key=True)
    score: Mapped[int] = mapped_column(nullable=False)
    text: Mapped[int] = mapped_column(db.Text, nullable=False)
    status: Mapped[str] = mapped_column(
        db.String(32), nullable=False, default="pending"
    )
    creation_date: Mapped[int] = mapped_column(db.TIMESTAMP, default=func.now())

    book: Mapped["Book"] = db.relationship(back_populates="reviews", uselist=False)
    user: Mapped["User"] = db.relationship(back_populates="reviews", uselist=False)
