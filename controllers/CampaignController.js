const { json } = require('express');
var db = require('../db/db');

async function createPost(req, res)
{
    let body = req.body;
    let session = req.session.userLogged;
    if (session && session.administrador){
        try {
            const query = 'insert into campana(nombre, lider) values ($1, $2)';
            let queryRes = await db.query(query, [body.nombre, body.lider]);
            res.render('success');
        } catch (error) {
            console.log(error);
            res.render('error');
        }
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
    if (session){
        if (session.administrador) {
            const query = 'select * from campana where idcampana=$1';
            let queryRes = await db.query(query, [campaignID]); 
            res.send(queryRes.rows);
        }else{
            res.redirect('/campana');
        }
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
            let queryRes = await db.query('select * from campana where idcampana=$1', [campaignID]); 
            let product = await db.query('select * from producto where idcampana=$1', [campaignID]); 
            let data = {
                session:session, 
                campaign:queryRes.rows[0], 
                products:product.rows
            };
            if (session.administrador){
                data.posiblesLideres = await db.query('select * from producto where lider=true'); 
            }
            res.render("campaign/config", data);
        }else{
            res.redirect('/campana');
        }
    }else{
        res.redirect('/login');
    }
}
async function addProductsPost(req, res){
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    let body = req.body;
    if (session && session.lider){

        try {
            let prod = await db.query('update campana set nombre=$1, objetivo=$2 where idcampana=$3', [body.name, body.target, campaignID]);
            if (req.body.products !== undefined) {
                for (let i = 0; i < req.body.products.length; i++) {
                    let product = req.body.products[i];
                    if (product.id) {
                        let prod = await db.query('update producto set titulo=$1, costo=$2, tipo=$3 where idproducto=$4', [product.description, product.price, product.type, product.id]);
                    }else{
                        let prod = await db.query('insert into producto(idcampana, titulo, costo, tipo) values ($1, $2, $3, $4)', [campaignID, product.description, product.price, product.type]);
                    }
                } 
            }
            res.render('success');
        } catch (error) {
            console.log(error);
            res.render('error');
        }
    }else{
        res.redirect('/login');
    }
}

module.exports = {
    createGet,
    createPost,
    find,
    findAll,
    addProductsGet,
    addProductsPost
}