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
                
            res.render('order/index', {data:response.rows, query:{id1:idCampaign, id2:idusuario}});
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
            let response = await db.query('select * from equipo as e where e.idcampana=$1 and e.idusuario=$2', [idCampaign, idusuario]);
            if (response.rowCount == 0) {
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
                for (let i = 0; i < productSelected.length; i++) {
                    let element = productSelected[i];
                    let response = await db.query('select * from producto as p where p.idproducto=$1 and p.idcampana=$2', [element.idproducto, idCampaign]);
                    if (response.rowCount > 0) {
                        let product = response.rows[0];
                        await client.query('insert into venta(idorden, unidades, titulo, costo) values ($1, 0, $2, $3)', [resOrden.rows[0].idorden, product.titulo, product.costo]);
                    }else{
                        throw 'producto no encontrado';
                    }
                }
                if (req.body.donacion != '') {
                    await client.query('insert into donacion(idorden, monto) values ($1, $2)', [resOrden.rows[0].idorden, req.body.donacion]);
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

module.exports = {
    index,
    donar
}