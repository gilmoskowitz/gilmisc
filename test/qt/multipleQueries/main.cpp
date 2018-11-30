#include <QCoreApplication>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QTextStream>

void usage(QString prog) {
  qDebug() << "usage:"
           << prog << "-h hostname -U username -w password -d dbname -p port";
}

/* test how the database server handles multiple queries
   embedded in a single query string.
 */
int main(int argc, char *argv[]) {
  QCoreApplication app(argc, argv);
  QSqlDatabase     db = QSqlDatabase::addDatabase("QPSQL");
  QTextStream      input(stdin),
                   output(stdout);

  QString hostname("localhost"),
          username("admin"),
          password("admin"),
          dbname("template1");
  int     port = 5962;

  for (int i = 1; i < argc; i++) {
    QString option(argv[i]);
    if (option == "-h")
      hostname = argv[++i];
    else if (option == "-U")
      username = argv[++i];
    else if (option == "-w")
      password = argv[++i];
    else if (option == "-d")
      dbname = argv[++i];
    else if (option == "-p")
      port = QString(argv[++i]).toInt();
    else {
      usage(argv[0]);
      exit(1);
    }
  }

  db.setHostName(hostname);
  db.setPort(port);
  db.setUserName(username);
  db.setPassword(password);
  db.setDatabaseName(dbname);

  if (db.open()) {
    QStringList querystrings;
    querystrings << "SELECT false AS result FROM information_schema.columns LIMIT 1;"
                    "SELECT true  AS result FROM information_schema.columns LIMIT 1;"
                 << "DO $$ DECLARE test BOOLEAN ; BEGIN test := false; END; $$;"
                    "SELECT true AS result FROM information_schema.columns LIMIT 1;"
                 ;

    foreach(QString str, querystrings) {
      QSqlQuery q(str);
      if (q.first())
        qDebug() << (q.value("result").toBool() ? "PASSED" : "FAILED") << str;
      else if (q.lastError().type() != QSqlError::NoError)
        qDebug() << "FAILED" << q.lastError().text();
    }

    db.close();
  } else
    qDebug() << "Could not connect to db" << db.lastError().text();
}

