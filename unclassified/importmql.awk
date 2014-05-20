/^--.*[gG][rR][oO][uU][pP] *:/ { group = $NF; }
/^--.*[nN][aA][mM][eE] *:/     { name  = $NF; }
/^--.*[nN][oO][tT][eE][sS] *:/ { notes = $0; sub(/.*:/,   "", notes); innotes = 1; }
innotes && /^--/ && ! /^--.*[nN][oO][tT][eE][sS] *:/ {
                                 more  = $0; sub(/^-- */, "", more);  notes = notes " " more; }
                               { query = query "\n" $0; }
END { gsub("'", "''", group);
      gsub("'", "''", name);
      gsub("'", "''", notes);
      gsub("'", "''", query);
      print "UPDATE metasql SET metasql_notes     = '" notes "', " \
                               "metasql_query     = '" query "', " \
                               "metasql_lastuser  = CURRENT_USER," \
                               "metasql_lastupdate= CURRENT_DATE " \
            " WHERE metasql_group='" group "' AND metasql_name='"  name  "';";
      print "INSERT INTO metasql (metasql_group, metasql_name, metasql_notes, " \
            "                     metasql_query, metasql_lastuser, metasql_lastupdate" \
            ") VALUES ('" group "', '" name "', '" notes "', '" query "', CURRENT_USER, CURRENT_DATE" \
            ");";
}
