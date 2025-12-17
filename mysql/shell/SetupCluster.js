

try {


  println("Starting cluster setup...");

  print('Setting up InnoDB cluster... \n');
  dba.configureInstance({user: "root", host: "mysql-server-1", password: "mysql"})
  dba.configureInstance({user: "root", host: "mysql-server-2", password: "mysql"})
  dba.configureInstance({user: "root", host: "mysql-server-3", password: "mysql"})
  
  print('Adding instances to the cluster.');
  var cluster = dba.createCluster("devCluster");
  cluster.addInstance({user: "root", host: "mysql-server-2", password: "mysql"},{recoveryMethod: "clone"});
  cluster.rescan()
  print('.');
  cluster.addInstance({user: "root", host: "mysql-server-3", password: "mysql"},{recoveryMethod: "clone"});
  cluster.rescan()
  print('.\nInstances successfully added to the cluster.');
  print('\nInnoDB cluster deployed successfully.\n');
} catch(e) {
  
  print('\nThe InnoDB cluster could not be created.\n\nError: ' + e.message + '\n');
}
