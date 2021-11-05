const express = require('express');
const app = express();
const {Storage} = require('@google-cloud/storage');
const storage = new Storage();
  
const bucketName = `gs://${process.env.STORAGE_NAME}`; 
const fileName = 'data.txt';

app.get('/', function (req, res) {
    
    const archivo = storage.bucket(bucketName).file(fileName).createReadStream();
       let buf = '';
       archivo.on('data', function(d) {
          buf += d;
       }).on('end', function() {
          res.send(buf);
       }).on('error', function(e) {
        res.send(e);
     });;
});

app.get('/ready', function (req, res) {
    //Aca tenemos que esperar que todo este inicializado 
    //Para poder recibir el primer request
    res.sendStatus(200);
});
app.get('/health', function (req, res) {
    //Este endpoint da una señal mínima de vida 
    //Tambien puede indicar la salud completa del servicio.
    //Sigue con acceso a otros sub servicios? Se ve la BD? 
    res.sendStatus(200);
});

app.listen(8080, function () {
    console.log('Listos en el 8080');
});