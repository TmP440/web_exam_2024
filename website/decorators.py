from functools import wraps
from flask import redirect, url_for, flash
from flask_login import current_user


def role_required(*roles):
    def wrapper(fn):
        @wraps(fn)
        def decorated_view(*args, **kwargs):
            if not current_user.is_authenticated:
                flash(
                    "Не удалось выполнить запрос. Пройдите аутентификацию.",
                    category="error",
                )
                return redirect(url_for("auth.login"))
            if current_user.role.name not in roles:
                flash("Недостаточно прав для доступа к странице", category="error")
                return redirect(url_for("views.home_page"))
            return fn(*args, **kwargs)

        return decorated_view

    return wrapper
