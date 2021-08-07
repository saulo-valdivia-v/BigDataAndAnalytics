db.puntuaciones.find()

db.puntuaciones.find({puntuacion:{$gt:90.0}})

db.puntuaciones.find({
        $and:[
            {puntuacion:{$gt:90.0}},
            {puntuacion:{$lt:95.0}}
        ]
    })
    
