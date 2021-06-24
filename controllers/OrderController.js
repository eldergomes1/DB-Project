const { render } = require('ejs');
const db = require('../db/db');

const index = async function(req, res){
    let idCampaign = req.query.id1
    let idusuario = req.query.id2
    try {
        if (idCampaign !== undefined && idusuario !== undefined) {
            // res.send("id1="+idCampaign+" id2="+idusuario);
            let response = await db.query('select c.nombre, p.idproducto, p.titulo, p.costo, p.tipo from campana as c join equipo as e on e.idcampana=c.idcampana join producto as p on p.idcampana=c.idcampana where c.idcampana=$1 and e.idusuario=$2',
            [idCampaign, idusuario]);

            if (response.rowCount == 0) {
                throw "sin registros";
            }

            res.render('order/create', {data:response.rows, query:{id1:idCampaign, id2:idusuario}});
        }else{
            throw "parametros insuficientes";
        }
    } catch (error) {
        res.send('<h1>ocurrio un error</h1>');
    }
};

const donar = async function(req, res){
    let idCampaign = req.query.id1
    let idusuario = req.query.id2
    try {
        if (idCampaign !== undefined && idusuario !== undefined) {
            let {rowCount, rows:Campaign} = await db.query('select c.recaudado from equipo as e join campana as c on c.idcampana = e.idcampana where e.idcampana=$1 and e.idusuario=$2', [idCampaign, idusuario]);
            if (rowCount == 0) {
                throw 'usuario y campana no relacionados';
            }
            let productSelected = req.body.products.filter(produt => produt.isselected === 'on');
            if (productSelected.length == 0 && req.body.donacion === '') {
                throw 'productos y donacion no proporcionados';
            }
            const client = await db.connect();
            try {
                await client.query('BEGIN');
                const insertText = 'insert into orden(idcampana, idusuario) values ($1, $2) returning idorden';
                let resOrden = await client.query(insertText, [idCampaign, idusuario]);
                let subTotal = 0;
                for (let i = 0; i < productSelected.length; i++) {
                    let element = productSelected[i];
                    let productQuery = 'select * from producto as p where p.idproducto=$1 and p.idcampana=$2';
                    let {rowCount:productNumber, rows:products} = await db.query(productQuery, [element.idproducto, idCampaign]);
                    if (productNumber > 0) {
                        let product = products[0];
                        subTotal += Number(product.costo);
                        await client.query('insert into venta(idorden, unidades, titulo, costo) values ($1, 0, $2, $3)', [resOrden.rows[0].idorden, product.titulo, product.costo]);
                    }else{
                        throw 'producto no encontrado';
                    }
                }
                if (req.body.donacion != '') {
                    await client.query('insert into donacion(idorden, monto) values ($1, $2)', [resOrden.rows[0].idorden, req.body.donacion]);
                }

                let total = subTotal + (req.body.donacion == '' ? 0 :Number(req.body.donacion));
                if (total > 0) {
                    let query = "update campana set recaudado=$1 where idcampana=$2";
                    await client.query(query, [Number(Campaign[0].recaudado) + total, idCampaign]);
                }

                await client.query('COMMIT');
                res.send('codigo de orden: '+resOrden.rows[0].idorden);
            } catch (error) {
                await client.query('ROLLBACK');
                throw error;
            }finally{
                client.release();
            }
        }else{
            throw "parametros insuficientes";
        }
    } catch (error) {
        console.log(error);
        res.send('<h1>ocurrio un error</h1>');
    }
};

const ordenesQuery = "select o.idorden, v.titulo, v.costo from orden as o join venta as v on v.idorden = o.idorden where o.idusuario = $1 and o.idcampana = $2";

const getOrders = async (req, res) => {
    let session = req.session.userLogged;
    let idusuario = req.query.idusuario;
    let idcampana = req.query.idcampana;
    if (session === undefined){
        res.redirect('/login');
        return;
    }

    // Un admistrador puede consultar las ordenes de campaña de cualquier usuario
    if (session.administrador) {
        let { rows:productosPorOrden } = await db.query(ordenesQuery, [idusuario, idcampana]);
        res.send(productosPorOrden);
        return;
    }
    
    if (session.lider) {
        // comprobamos si es parte del equipo de campaña
        let campanaQuery = "select * from campana as c join equipo as e on c.idcampana = e.idcampana where e.idcampana=$1 and e.idusuario=$2";
        let { rowCount, rows:campanas } = db.query(ordenesQuery, [idcampana, session.idusuario]);

        // El usuario es parte del equipo de campana y ademas es el lider de esa campaña
        // por ente puede consultar las ordenes de cualquier miembra de esa campaña
        if (rowCount > 0 && campanas[0].lider === session.idusuario) {
            let { rows:productosPorOrden } = await db.query(ordenesQuery,  [idusuario, idcampana]);
            res.send(productosPorOrden);
            return;
        }
        // El usuario es parte del equipo de campana pero no es lider de esa cmapaña
        // por ende solo puede consultar sus ordenes
        if (rowCount > 0 && campanas[0].lider !== session.idusuario) {
            let { rows:productosPorOrden } = await db.query(ordenesQuery,  [idusuario, idcampana]);
            res.send(productosPorOrden);
            return;
        }
    }

    // Si el que consulta las ordenes des un agente 
    // solo debe poder consultar sus propias ordenes
    if (session.agente && session.idusuario == idusuario){
        let { rows:productosPorOrden } = await db.query(ordenesQuery, [idusuario, idcampana]);
        res.send(productosPorOrden);
        return;
    }

    res.render("error");
}

const orders = async (req, res) => {
    let idcampana = req.params.idcampana
    // let idcampana = req.query.idcampana
    // let idusuario = req.query.idusuario

    let session = req.session.userLogged;
    if (session === undefined) {
        res.redirect('/login');
        return;
    }
    // el aministrador puede consultar cualquier equipo de cualquier campana
    if (session.administrador) {
        let teamQuery = "select u.idusuario, u.username from equipo as e join usuario as u on u.idusuario = e.idusuario where e.idcampana = $1";
        let { rows:equipo } = await db.query(teamQuery, [idcampana]);
        res.render("order/index", {equipo});
        return
    }
    // el lider solo puede consultar los equipos que lidera
    if (session.lider) {
        let teamQuery = "select u.idusuario, u.username from campana as c join equipo as e on c.idcampana=e.idcampana join usuario as u on u.idusuario = e.idusuario where e.idcampana = $1 and c.lider=$2";
        let { rows:equipo } = await db.query(teamQuery, [idcampana, session.idusuario]);
        res.render("order/index", {equipo});
        return
    }

    res.render("error");

    // if (session.administrador){
    //     let query = "select o.idorden, v.titulo, v.costo, u.username from venta as v join orden as o on v.idorden = o.idorden join usuario as u on o.idusuario = u.idusuario";
    //     let reponse = await db.query(query, []);
    //     res.send(reponse.rows);
    // }

    // if (session.lider){
    //     let query = "select o.idorden, v.titulo, v.costo from venta as v join orden as o on v.idorden = o.idorden join campana as c on c.idcampana = o.idcampana where c.lider = $1";
    //     let reponse = await db.query(query, [session.idusuario]);
    //     res.send(reponse.rows);
    // }

    // if (session.agente){
    //     let query = "select o.idorden, v.titulo, v.costo from venta as v join orden as o on v.idorden = o.idorden where o.idusuario = $1";
    //     let reponse = await db.query(query, [session.idusuario]);
    //     res.send(reponse.rows);
    // }




    // let a = [];
    // a.reduce((acc, item) => {
    //     let index = acc.findIndex(elemt => elemt[item.idorden]);
    //     if (index == -1) {
    //         acc[item.idorden] = [item.titulo];
    //         return acc;
    //     }

    //     acc[item.idorden].push(item.titulo);
    // });

}

module.exports = {
    index,
    donar,
    orders,
    getOrders
}