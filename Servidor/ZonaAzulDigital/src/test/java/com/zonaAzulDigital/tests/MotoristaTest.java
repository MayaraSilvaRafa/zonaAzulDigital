/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.zonaAzulDigital.tests;

import com.zonaAzulDigital.Excecao.CpfException;
import com.zonaAzulDigital.Excecao.DaoException;
import com.zonaAzulDigital.Excecao.MotoristaException;
import com.zonaAzulDigital.entidades.Motorista;
import com.zonaAzulDigital.interfaces.DAOMotorista;
import com.zonaAzulDigital.interfaces.ModelMotoristaInterface;
import com.zonaAzulDigital.model.ModelMotorista;
import com.zonaAzulDigital.tests.DAO.DAOMotoristaFake;
import java.math.BigDecimal;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

/**
 *
 * @author Samuel
 */

public class MotoristaTest {
    
    public ModelMotoristaInterface md;
    
    public Motorista m;
    
    @Rule
    public ExpectedException excecao = ExpectedException.none();
    
    @Before
    public void before(){
        md = new ModelMotorista(new DAOMotoristaFake());
        
    }
    
    
    @Test
    public void testaCadastroSimplesdeMotorista() throws DaoException, CpfException, MotoristaException {
        m = new Motorista(1, "Samuel", "11791558402", BigDecimal.ZERO, "alabala");
        Motorista motorista = md.cadastrar(m);
        assertEquals("Samuel",motorista.getNome());
    }
    
    @Test
    public void deveDispararExcecaoDeCPFNoCadastro() throws CpfException, DaoException, MotoristaException{
        excecao.expect(CpfException.class);
        m = new Motorista(1, "Samuel", "", BigDecimal.ZERO, "alabala");
        md.cadastrar(m);
    }
    
    @Ignore
    @Test
    public void deveDispararExcecaoDeMotoristaVazio() throws DaoException, CpfException, MotoristaException{
        excecao.expect(DaoException.class);
        m = new Motorista();
        md.cadastrar(m);
    }
    
}
