/addColumn/s/_([a-z]*Column)/XTreeWidget.\1/
s/param = pParams.value\("(.*)", &valid\);/if ("\1" in pParams)/
s/params.append\("(.*)",( *)(.*)\);/params.\1\2= \3;/
s/params.append\("(.*)"\);/params.\1 = true;/
s/->/./g
s/[[:<:]]Qt::/Qt./g
s/orReport report\(/toolbox.printReport(/
s/[[:<:]]tr[[:>:]]/qsTr/g
s/( *)(.*) \*newdlg = new (.*)\(\);/\1var newdlg = toolbox.openWindow("\2", 0, Qt.NonModal, Qt.Window);/
/omfgThis.handleNewWindow(newdlg);/d
/^#include/d
s/( *)(.*) newdlg\(this, "", TRUE\);/\1var newdlg = toolbox.openWindow("\2", mywindow, Qt.WindowModal, Qt.Dialog);/
s/ParameterList params;/var params = new Object;/
s/^void .*::(.*)\((.*)\)/function \1(\2)/
s/^( *)q.prepare\(/\1var qry = toolbox.executeQuery(/
s/q.bindValue\(":(.*)", (.*)\);/params.\1 = \2;/
s/systemError *\( *this,/QMessageBox.critical(mywindow, qsTr("Database Error"),/
s/QMessageBox::/QMessageBox./
s/QSqlError::None/QSqlError.NoError/
s/QSqlError::/QSqlError./
s/lastError\(\).type\(\)/lastError().type/
s/lastError\(\).text\(\)/lastError().text/
s/lastError\(\).databaseText\(\)/lastError().text/
s/, __FILE__, __LINE__//
s/omfgThis/mainwindow/g
s/( *)menuItem = (.*).insertItem\((qsTr\(.*\)), this, SLOT\((.*)\(\)\), 0);/\1menuItem = \2.addAction(\3);\1menuItem.setEnabled(privileges.check());\1menuItem.triggered.connect(\4);/
s/( *)(.*).insertSeparator\(\);/\1\2.addSeparator();/
s/([~=])( *):([a-z0-9_]*)/\1\2<? value("\3") ?>/g
s/[[:<:]]connect\((.*), SIGNAL\((.*)\), this, SLOT\((.*)\(.*\)\)\) *;/\1["\2"].connect(\3);/
/[[:<:]]connect[[:>:]]/s/QTreeWidgetItem/XTreeWidgetItem/g
/[[:<:]]connect[[:>:]]/s/connect()/connect/g
s/XDialog::Rejected/QDialog.Rejected/g
s/XDialog::Accepted/QDialog.Accepted/g
s/ParameterGroup::/ParameterGroup./g
s/setType\(ParameterGroup(.*));/type = ParameterGroup\1;/g
s/[[:<:]]_metrics[[:>:]]/metrics/g
s/[[:<:]]_privileges[[:>:]]/privileges/g
s/\.isChecked\(\)/.checked/g
s/_warehouse.appendValue\((.*)\);/if (_warehouse.isSelected())\1.warehous_id = _warehouse.id();/
