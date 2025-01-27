import os
from badwulf.cli import dbmanager
from badwulf import tools

program = "msi"

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

dbpath = os.getenv("MAGI_DBPATH")
if dbpath is None:
	sys.exit("msi: $MAGI_DBPATH is not set")

dbname = "MSI"
metaname = "MSIResearch"

app = dbmanager("Magi", 
	dbpath = dbpath,
	dbname = dbname,
	metaname = metaname,
	version = "0.1.0",
	date = "2024-01-18",
	description = "MSI Research database @ NEU",
	readme = os.path.join(dbpath, dbname, metaname, "README.md"),
	program = program)

if tools.is_known_host(nodes.values()):
	app.remote_dbhost = "Magi-03.local"
	app.remote_dbpath = "/Volumes/MagiFS/Datasets"
	app.server = None
	app.server_username = None
else:
	app.remote_dbhost = "Magi-03"
	app.remote_dbpath = "/Volumes/MagiFS/Datasets"
	app.server = "login.khoury.northeastern.edu"
	app.server_username = os.getenv("MAGI_LOGIN")

if __name__ == "__main__":
	app.main()
