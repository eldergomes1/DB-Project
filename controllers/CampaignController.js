var db = require('../db/db');

async function createPost(req, res)
{
    let body = req.body;
    let session = req.session.userLogged;
    if (session && session.administrador){
        const query = 'insert into campana(nombre, lider) values ($1, $2)';
        let queryRes = await db.query(query, [body.nombre, body.lider]);
        res.send('<div><p>Creacion exitosa</p><a href=\"/campana\">volver</a></div>');
    }else{
        res.redirect('/login');
    }
}

async function createGet(req, res)
{
    let body = req.body;
    let session = req.session.userLogged;
    if (session && session.administrador){
        let query = 'select * from usuario where lider=true;';
        let querRes = await db.query(query);
        res.render('campaign/create', {users:querRes.rows});
    }else{
        res.redirect('/login');
    }
}

async function find(req, res)
{
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    if (session && session.administrador){
        const query = 'select * from campana where idcampana=$1';
        let queryRes = await db.query(query, id); 
        res.send(queryRes.rows);
    }else{
        res.redirect('/login');
    }
}

async function findAll(req, res)
{
    let session = req.session.userLogged;
    if (session)
    {
        let query = 'select  c.idcampana, c.nombre, u.username, c.objetivo from campana as c join equipo as e on c.idcampana=e.idcampana join usuario as u on e.idusuario=u.idusuario where u.idusuario=$1';
        
        if (session.lider) {
            query = 'select c.idcampana, c.nombre, u.username, c.objetivo from campana as c join usuario as u on c.lider=u.idusuario where c.lider=$1';
        }
        if (session.administrador) {
            query = 'select c.idcampana, c.nombre, u.username, c.objetivo from campana as c join usuario as u on c.lider=u.idusuario';
        }
        
        query += ' order by c.idcampana desc';

        if (session.administrador) {
            var queryRes = await db.query(query); 
        }else{
            var queryRes = await db.query(query, [session.idusuario]); 
        }
        res.render('campaign/index', { campaigns: queryRes.rows, session: session })
    }else{
        res.redirect('/login');
    }
}

async function addProductsGet(req, res)
{
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    console.log("session ", session);
    if (session){
        if (session.administrador || session.lider) {
            const query = 'select * from campana where idcampana=$1';
            let queryRes = await db.query(query, [campaignID]); 
            res.render("campaign/config", {session:session, campaign:queryRes.rows[0]});
        }else{
            res.redirect('/campana');
        }
    }else{
        res.redirect('/login');
    }
}
async function addProductsPost(req, res)
{
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    if (session && session.lider){
        res.send("edit");
    }else{
        res.redirect('/login');
    }
}

module.exports = {
    createGet,
    createPost,
    find,
    findAll,
    addProductsGet
}