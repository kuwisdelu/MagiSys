import os
from badwulf.cli import dbmanager
from badwulf import tools

program = "magidb"

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

dbpath = os.getenv("MAGI_DBPATH")
if dbpath is None:
	sys.exit(f"{program}: $MAGI_DBPATH is not set")

dbname = os.getenv("MAGI_DBNAME")
if dbname is None:
	sys.exit(f"{program}: $MAGI_DBNAME is not set")

app = dbmanager("Magi", 
	dbpath = dbpath,
	dbname = dbname,
	date = "2025-08-28",
	description = "Magi cluster research data @ NEU",
	readme = os.path.join(dbpath, "README.md"),
	program = program)

if tools.is_known_host(nodes.values()):
	app.username = os.getlogin()
	app.remote_dbhost = "Magi-01.local"
	app.remote_dbpath = "/Volumes/Dogma/Datasets"
	app.server = None
	app.server_username = None
else:
	app.username = os.getenv("MAGI_USER", default="viteklab")
	app.remote_dbhost = "Magi-01"
	app.remote_dbpath = "/Volumes/Dogma/Datasets"
	app.server = "login.khoury.northeastern.edu"
	app.server_username = os.getenv("MAGI_LOGIN")

if __name__ == "__main__":
	app.main()
