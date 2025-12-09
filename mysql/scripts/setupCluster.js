
var dbPass = "mysql"
var clusterName = "devCluster"

try {


  println("Starting cluster setup...");

  print('Setting up InnoDB cluster... \n');
  dba.configureInstance({user: "root", host: "mysql-server-1", password: "mysql"})
  dba.configureInstance({user: "root", host: "mysql-server-2", password: "mysql"})
  dba.configureInstance({user: "root", host: "mysql-server-3", password: "mysql"})
  
  shell.connect('root@mysql-server-1:3306', dbPass)
  var cluster = dba.createCluster(clusterName);
  print('Adding instances to the cluster.');
  cluster.addInstance({user: "root", host: "mysql-server-2", password: dbPass})
  print('.');
  cluster.addInstance({user: "root", host: "mysql-server-3", password: dbPass})
  print('.\nInstances successfully added to the cluster.');
  print('\nInnoDB cluster deployed successfully.\n');
} catch(e) {
  
  print('\nThe InnoDB cluster could not be created.\n\nError: ' + e.message + '\n');
}
