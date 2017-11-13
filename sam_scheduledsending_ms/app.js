
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const request = require('request');
const NodeCouchDb = require('node-couchdb');

// node-couchdb instance with default options

// node-couchdb instance talking to external service
const couch = new NodeCouchDb({
    host: 'couchdb.server',
    protocl: 'https',
    port: '5984'
});

// not admin party
const couchAuth = new NodeCouchDb({
    auth: {
        user: 'admin',
        pass: 'admin'
    }
});

const dbName = 'scheduledsending';
const viewUrl = '_design/all_sheduledsending/_view/all';

couch.listDatabases().then(function(dbs){
});

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname,'views'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));

const PORT = 3006;
const HOST = '0.0.0.0';

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);


//-------- controller -----------------------------------------


app.get('/', function (req, res){
    couch.get(dbName, viewUrl).then(
      function(data, headers, status){
        res.render('index',{
          scheduledsending:data.data.rows
        });
      },
    function(err){
      res.send(err);
    });
});
app.get('/scheduledsending/all', function (req, res){
    couch.get(dbName, viewUrl).then(
      function(data, headers, status){
        res.send(data.data.rows);
      },
    function(err){
      res.send(err);
    });
});

app.post('/scheduledsending/add', function (req, res){
    const user_id = req.body.user_id;
    const mail_id = req.body.mail_id;
    const fecha = new Date(req.body.date);
    const year = fecha.getFullYear();
    const month = fecha.getMonth()+1;
    const day = fecha.getDate();
    const hour = fecha.getHours();
    const minutes = fecha.getMinutes();
    couch.uniqid().then(function(ids){
      const id = ids[0];
      couch.insert('scheduledsending',{
        _id:id,
        user_id:user_id,
        mail_id:mail_id,
        date:{
          year:year,
          month:month,
          day:day,
          hour:hour,
          minutes:minutes
        }
      }).then(
        function(data, headers, status){
          res.send('Created successfully');
          res.redirect('/')
        },
        function(err){
          res.send(err);
        });
    });
});
app.put('/scheduledsending/update', function (req, res){
  couch.get(dbName, viewUrl).then(
    function(data, headers, status){
    var data=data.data.rows;
    const id = 0;
    const rev = 0;
    const user_id = req.body.user_id;
    const mail_id = req.body.mail_id;
    const date = objDate(req.body.date);
    const year = date.year;
    const month = date.month;
    const day = date.day;
    const hour = date.hour;
    const minutes = date.minutes;
    for (i=0;i<data.length;i++){
      if(user_id==data[i].value.user_id && mail_id==data[i].value.mail_id){
        couch.update('scheduledsending',{
            _id:data[i].id,
            _rev:data[i].value.rev,
            user_id:user_id,
            mail_id:mail_id,
            date:{
              year:year,
              month:month,
              day:day,
              hour:hour,
              minutes:minutes
            }
          }).then(
            function(data, headers, status){
              res.send('Edited successfully');
            },
            function(err){
              res.send(err);
            });
        }
      }
    },
    function(err){
      res.send(err);
    });
});

app.delete('/scheduledsending/delete',function(req,res){
  couch.get(dbName, viewUrl).then(
    function(data, headers, status){
    var dat=data.data.rows;
    const user_id = req.body.user_id;
    const mail_id = req.body.mail_id;
    for (i=0;i<dat.length;i++){
      if(user_id==dat[i].value.user_id && mail_id==dat[i].value.mail_id){
        couch.del(dbName,dat[i].id,dat[i].value.rev).then(
        function(data, headers, status){
          res.send('Deleted successfully');
        },
        function(err){
          res.send(err);
        });
      }
    }
  },
  function(err){
    res.send(err);
  });
});

function objDate(date){
  return {
    year:date.substring(0, 4),
    month:date.substring(5, 7),
    day:date.substring(8, 10),
    hour:date.substring(11, 13),
    minutes:date.substring(14, 16),
  }
}



function intervalFunc() {
  couch.get(dbName, viewUrl).then(
        function(data, headers, status){
          var data=data.data.rows;
          var now = new Date()
          console.log(now.getFullYear()+" / "+(Number(now.getMonth())+1)+" / "+now.getDate()+" / "+now.getHours()+" / "+now.getMinutes());
          for (i=0;i<data.length;i++){
             if (data[i].value.date.year==now.getFullYear()){
               if (data[i].value.date.month==(Number(now.getMonth())+1)){
                 if (data[i].value.date.day==now.getDate()){
                   if (data[i].value.date.hour==now.getHours()){
                     if (data[i].value.date.minutes==now.getMinutes()){
                       console.log("se enviara el mail con id "+data[i].value.mail_id);

                      request.get('http://192.168.99.101:4000/senddrafts/'+data[i].value.mail_id).on('response', function(response) {
                      console.log(response.statusCode) // 200
                      console.log(response.headers['content-type']) // 'image/png'
                    });
                      couch.del(dbName, data[i].id,data[i].value.rev).then(
                           function(data, headers, status){
                              console.log('ScheduledSending deleted');
                             },
                             function(err){
                               console.log(err);
                             });
                         }
                         }
                        }
                      }
                    }
                  }
          });
      }


setInterval(intervalFunc, 1500);
