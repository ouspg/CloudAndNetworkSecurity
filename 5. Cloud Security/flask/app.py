from flask import (
    Flask,
    render_template,
    request,
    redirect,
    jsonify,
)
import os
import random
from urllib.parse import quote
import requests

app = Flask(__name__)
app.secret_key = "default_secret_key"

AUTHORIZATION_ENDPOINT = ""
TOKEN_ENDPOINT = ""


@app.before_request
def before_request():
    if request.path != "/" and request.path.endswith("/"):
        return redirect(request.path[:-1])


@app.route("/debug")
def list_files():
    files = os.listdir(".")
    return render_template("debug.html", files=files)


@app.route("/debug/<path:subpath>")
def list_subdir(subpath):
    path = os.path.join(".", subpath)
    if os.path.isdir(path):
        files = os.listdir(path)
        return render_template("debug.html", files=files)
    else:
        return f"{subpath} is not a directory."


@app.route("/debug/<path:filename>")
def serve_file(filename):
    try:
        with open(filename, "r") as f:
            file_content = f.read()
        return render_template(
            "file_content.html", file_content=file_content, title="File Content"
        )
    except FileNotFoundError:
        return "File not found", 404


@app.route("/")
def index():
    return render_template("index.html", title="Cyber Security Company")


@app.route("/login")
def login():
    # TODO generate the initial URL to the authorization server for login button
    keycloak_login = f""
    print(keycloak_login)
    return render_template(
        "login.html",
        title="Login to Secret Service",
        keycloak_login=keycloak_login,
    )


@app.route("/callback")
def callback():
    # Just show our fancy JWT token in the end, after we acquire with correct logic
    resp = {}
    return jsonify(resp.json())


@app.route("/contact")
def contact():
    return render_template("contact.html", title="Contact Us - Cyber Security Company")


@app.route("/about")
def about():
    return render_template("about.html", title="About Our Cyber Security Company")


@app.route("/wip")
def vendor():
    return render_template("wip.html")


@app.route("/dogs")
def dogs():
    return render_template("wip.html")


@app.route("/licenses")
def lisences():
    return render_template("wip.html")


@app.route("/mysql")
def sql():
    return render_template("wip.html")


@app.route("/call")
def call():
    return render_template("wip.html")


@app.route("/audit")
def audit():
    return render_template("wip.html")


@app.route("/App_Data")
def app_data():
    return render_template("wip.html")


@app.route("/admin")
def admin():
    return render_template("restricted.html")


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=3000)
