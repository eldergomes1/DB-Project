const { json } = require('express');
var db = require('../db/db');

const insertEquipoQuery = 'insert into equipo(idcampana, idusuario) values ($1, $2)';

async function createPost(req, res)
{
    let body = req.body;
    let session = req.session.userLogged;

    if (session === undefined) {
        res.redirect('/login');
        return;
    }

    if (session.administrador) {
        const client = await db.connect();
        try {
            await client.query('BEGIN');
            const insertCampana = 'insert into campana(nombre, lider) values ($1, $2) returning idcampana';
            let {rows:[campana]} = await client.query(insertCampana, [body.nombre, body.lider]);
            await client.query(insertEquipoQuery, [campana.idcampana, body.lider]);
            await client.query('COMMIT');
            res.render('success');
        } catch (error) {
            console.log(error);
            await client.query('ROLLBACK');
            res.render('error');
        }finally{
            client.release();
        }
        return;
    }

    res.render('error');
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
    if (session === undefined) {
        res.redirect('/login');
        return;
    }

    // let query = 'select u.idusuario, c.idcampana, c.nombre, u.username, c.objetivo from campana as c join equipo as e on c.idcampana=e.idcampana join usuario as u on e.idusuario=u.idusuario where u.idusuario=$1';
    
    // if (session.lider) {
        query = "select u.idusuario, c.idcampana, c.nombre, u.username, c.objetivo from campana as c join usuario as u on u.idusuario=c.lider where c.idcampana in (select e.idcampana from equipo as e where e.idusuario=$1)";
    //     // query = 'select c.idcampana, c.nombre, u.username, c.objetivo from campana as c join usuario as u on c.lider=u.idusuario where c.lider=$1';
    // }

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
}

async function addProductsGet(req, res)
{
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    if (session === undefined) {
        res.redirect('/login');
        return;
    }

    if (session.administrador || session.lider) {
        let campaignR = await db.query('select * from campana where idcampana=$1', [campaignID]); 
        let productR = await db.query('select * from producto where idcampana=$1', [campaignID]); 
        
        let users = await db.query('select * from usuario where lider=true or agente=true'); 
        let equipo = await db.query('select e.idusuario, username from equipo as e join usuario as u on u.idusuario=e.idusuario where idcampana=$1;', [campaignID]); 
        let team = [];
        console.log("len", users.rows.length);
        users.rows.forEach(item => {
            let index = equipo.rows.findIndex(user => user.idusuario == item.idusuario);
            console.log(index);
            team.push({
                id:item.idusuario,
                username:item.username,
                isAgent: index != -1
            });
        });
        
        let lideres = await db.query('select * from usuario where lider=true'); 
        let agentes = await db.query('select * from usuario where agente=true'); 
        let data = {
            session:session, 
            campaign:campaignR.rows[0], 
            products:productR.rows,
            team:equipo.rows,
            lideres:lideres.rows,
            agentes:agentes.rows
        };
        res.render("campaign/config", data);
    }else{
        res.redirect('/campana');
    }
}

async function addProductsPost(req, res){
    let campaignID = req.params.id;
    let session = req.session.userLogged;
    let body = req.body;
    if (session && session.lider){
        const client = await db.connect();
        await client.query('BEGIN');
        try {
            let {rows:[campana]} = await client.query('select c.lider from campana as c where c.idcampana=$1', [campaignID]);
            // Verificamos que se quiere cambiar el lider
            if (session.administrador && campana.lider !== body.lider) {
                // sacamos al lider anterior del equipo de campaña
                // let deleteUserQuery = "delete from equipo as e where e.idcampana=$1 and e.idusuario=$2";
                // await client.query(deleteUserQuery, [campaignID, campana.lider]);

                // Verificamos si el nuevo lider ya es parte del equipo
                let liderActualQuery = "select * from equipo as e where e.idcampana=$1 and e.idusuario=$2"
                let {rowCount:usuariosEncontrados} = await client.query(liderActualQuery, [campaignID, body.lider]);
                if (usuariosEncontrados == 0) {
                    // incorporamos al nuevo lider al equipo de campaña
                    await client.query(insertEquipoQuery, [campaignID, body.lider]);
                }
            }

            await client.query('update campana set nombre=$1, objetivo=$2, lider=$4 where idcampana=$3', [body.name, body.target, campaignID, body.lider]);
            if (req.body.products !== undefined) {
                for (let i = 0; i < req.body.products.length; i++) {
                    let product = req.body.products[i];
                    if (product.id) {
                        await client.query('update producto set titulo=$1, costo=$2, tipo=$3 where idproducto=$4', [product.description, product.price, product.type, product.id]);
                    }else{
                        await client.query('insert into producto(idcampana, titulo, costo, tipo) values ($1, $2, $3, $4)', [campaignID, product.description, product.price, product.type]);
                    }
                } 
            }
            let newAgents = req.body.newAgent;
            if (newAgents !== undefined) {
                for (let i = 0; i < newAgents.length; i++) {
                    let newAgentInsert = await client.query('insert into equipo(idcampana, idusuario) values ($1, $2)', [campaignID, newAgents[i]]);
                }
            }

            await client.query('COMMIT');
            res.render('success');
        } catch (error) {
            console.log(error);
            await client.query('ROLLBACK');
            res.render('error');
        }finally{
            client.release();
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