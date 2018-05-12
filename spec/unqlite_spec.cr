require "./spec_helper"

describe Unqlite do
  it "Test JSON output" do
    script = <<-EOS
/* Create the collection 'users'  */
if( !db_exists('users') ){
/* Try to create it */
$rc = db_create('users');
if ( !$rc ){
  /*Handle error*/
  print db_errlog();
  return;
} else{
  print "Collection 'users' successfuly created\n";
}
}
/*The following is the records to be stored shortly in our collection*/
$zRec = [
{
name : 'james',
age  : 27,
mail : 'dude@example.com'
},
{
name : 'robert',
age  : 35,
mail : 'rob@example.com'
},
{
name : 'monji',
age  : 47,
mail : 'monji@example.com'
},
{
name : 'barzini',
age  : 52,
mail : 'barz@mobster.com'
}
];
/*Store our records*/
$rc = db_store('users',$zRec);
if( !$rc ){
/*Handle error*/
print db_errlog();
return;
}
/*Create our filter callback*/
$zCallback = function($rec){
/*Allow only users >= 30 years old.*/
if( $rec.age < 30 ){
  /* Discard this record*/
  return FALSE;
}
/* Record correspond to our criteria*/
return TRUE;
}; /* Don't forget the semi-colon here*/
/* Retrieve collection records and apply our filter callback*/
$data = db_fetch_all('users',$zCallback);
print "Filtered records\n";
/*Iterate over the extracted elements*/
foreach($data as $value){ /*JSON array holding the filtered records*/
print $value..JX9_EOL;
}

EOS

    db = UnQLite::DB.new
    db.open("./unq.db")
    db.compile(script)
    db.exec
    db.close
  end
end
