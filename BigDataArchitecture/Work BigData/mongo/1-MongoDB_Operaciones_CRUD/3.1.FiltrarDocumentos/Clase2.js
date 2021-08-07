db.gimnasio.find()

db.gimnasio.find({
    $and: [
        { preferencias : { $all:["Tenis", "Padel"] } },
        { preferencias : { $ne: "Natación" } },
        { preferencias : { $ne: "Aquagym" } }
    ]
    })
    
db.gimnasio.find({
    $and: [
        { preferencias : { $all:["Tenis", "Padel"] } },
        { preferencias : { $nin:["Aquagym", "Natación"] } }        
    ]
    })


db.puntuaciones3.find()

db.puntuaciones3.find({
    $and: [
        { idEstudiante : 1 },
        { "puntuaciones.tipo" : "preguntas" }
    ]
    })
    
db.puntuaciones3.find({
    $and: [
        { idEstudiante : 1 },
        { "puntuaciones.tipo" : "preguntas" }
    ]
    }, {"puntuaciones.puntuacion":1})


db.puntuaciones3.find(
    { "puntuaciones.tipo" : "preguntas" },
    {"puntuaciones.puntuacion":1}
    )
    
db.puntuaciones3.find({
    "puntuaciones.tipo":"examen",
    "puntuaciones.puntuacion":{$gt:99}
    })
    
db.puntuaciones3.find(
    {
       puntuaciones:
       {
           $elemMatch:
           {tipo:"examen", puntuacion:{$gt:99}}
       } 
    },
    {"_id":0, "puntuaciones.$":1}
    )