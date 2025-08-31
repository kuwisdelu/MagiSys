import os
import sys
from badwulf.cli import dbmanager
from badwulf import tools

program = "magidb"

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

xfer = "Magi-01"

dbpath = os.getenv("MAGI_DBPATH")
if dbpath is None:
	sys.exit(f"{program}: $MAGI_DBPATH is not set")

dbname = os.getenv("MAGI_DBNAME")
if dbname is None:
	sys.exit(f"{program}: $MAGI_DBNAME is not set")

if tools.is_known_host(nodes.values()):
	user = os.getlogin()
	remote_dbhost = f"{xfer}.local"
	remote_dbpath = "/Volumes/Dogma/Datasets"
	server = None
	server_username = None
else:
	user = os.getenv("MAGI_USER", default="viteklab")
	remote_dbhost = xfer
	remote_dbpath = "/Volumes/Dogma/Datasets"
	server = "login.khoury.northeastern.edu"
	server_username = os.getenv("MAGI_LOGIN")

app = dbmanager(
	dbpath = dbpath,
	dbname = dbname,
	date = "2025-08-28",
	description = "Magi cluster research data @ NEU",
	readme = os.path.join(dbpath, "README.md"),
	program = program,
	scopes = ("Private", "Protected", "Public"),
	username = user,
	remote_dbhost = remote_dbhost,
	remote_dbpath = remote_dbpath,
	server = server,
	server_username = server_user)

if __name__ == "__main__":
	app.main()
