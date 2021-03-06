local json = require("json")

local webService = {}

local composer = require("composer")

local toast = require("plugin.toast")
local endereco = "localhost"
local porta = "8084"




-- Rest de Cadastro de Motorista
--================================================================================================================================================================
local function eventoCadastrarMotorista(event)
    
    if not event.isError then
        local response = json.decode(event.response)
        

		if event.status == 200 then
			composer.gotoScene("TelaLogin")
			toast.show("Cadastro realizado com sucesso!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
		
		elseif event.status == 422 then
			
			toast.show("CPF já cadastrado!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		elseif event.status == 400 then
			
			toast.show("CPF inválido!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  			

		else
			toast.show("Não foi possivel realizar o cadastro!!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
        	
		end

    else

    	toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})

    end
    return
end



function webService:cadastrarMotorista(motorista)

	local headers = {}

	headers["Content-Type"] = "application/json"

	local motoristaJson = json.encode(motorista)

	local params = {}

	params.headers = headers

	params.body = motoristaJson

	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/motorista/salvar", "POST", eventoCadastrarMotorista, params)

end
--================================================================================================================================================================



-- Rest de Logar o Motorista
--================================================================================================================================================================
local function eventoLogarMotorista(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			
			local motoristaJson = json.decode(event.response)
			motoristaLogado = motoristaJson
			
			composer.gotoScene("TelaMotoristaInicial")
			
		elseif event.status == 401 then
			
			toast.show("Não foi possivel fazer login, CPF ou senha inválidos!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		else
			toast.show("Não foi possivel fazer login, CPF ou senha inválidos!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end

function webService:logarMotorista(cpf,senha)

	local login = {}

	login.cpf = cpf
	login.senha = senha

	local headers = {}

	headers["Content-Type"] = "application/json"

	local motoristaLogin = json.encode(login)

	local params = {}
	
	params.headers = headers

	params.body = motoristaLogin

	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/motorista/login", "POST", eventoLogarMotorista, params)

end
--================================================================================================================================================================


--Rest de compra de cartão
--================================================================================================================================================================
local function eventoCompraCartao(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			
			motoristaLogado.credito = response.credito
			toast.show("Compra efetuada com sucesso", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
			composer.gotoScene("TelaMotoristaInicial")

		elseif event.status == 401 then

			toast.show("Senha invalida", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		elseif event.status ==403 then
			
			toast.show("Placa invalida!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
			
		elseif event.status == 406 then

			toast.show("Saldo insuficiente!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  			

		else
			toast.show("Não foi possivel realizar compra!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end

function webService:compraCartao(motorista,placa)

	local headers = {}

	headers["Content-Type"] = "application/json"

	
	local params = {}
	
	params.headers = headers

	local tabelaMotorista = motorista

	tabelaMotorista.numeros = placa.numeros
	tabelaMotorista.letras = placa.letras

	local dados = tabelaMotorista

	params.body =  json.encode(dados)
	
	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/cartaozonaazul/comprar", "POST", eventoCompraCartao, params)

end
--================================================================================================================================================================



--Rest para atualizar dados do motorista
--================================================================================================================================================================
local function eventoAtualizarMotorista(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			
			motoristaLogado = json.decode(event.response)
			print(motoristaLogado.senha)
		else
			toast.show("Não foi possivel atualizar, verifique a conexão com a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end



function webService:atualizarMotorista(motorista)
	
	local headers = {}

	headers["Content-Type"] = "application/json"

	local dados = json.encode(motorista)

	local params = {}
	
	params.headers = headers

	params.body = dados
	
	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/motorista/atualizar", "POST", eventoAtualizarMotorista, params)

end
--================================================================================================================================================================

--Rest para pegar todos os cartoes ativos
--================================================================================================================================================================


local function eventoCartoesAtivos(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			cartoesAtivos = json.decode(event.response)
		else
			
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end

function webService:consultarCartoesAtivos(motorista)
	
	local headers = {}

	headers["Content-Type"] = "application/json"

	local dados = json.encode(motorista)

	local params = {}
	
	params.headers = headers

	params.body = dados
	
	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/cartaozonaazul/cartoesativos", "POST", eventoCartoesAtivos, params)

end
--================================================================================================================================================================



--Rest para consultar todas as compras do usuarios
--================================================================================================================================================================

local function eventoTodasAsCompras(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			todosCartoes = response
		else
			
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end



function webService:consultarCompraTodosCartoes(motorista)
	
	local headers = {}

	headers["Content-Type"] = "application/json"

	local dados = json.encode(motorista)

	local params = {}
	
	params.headers = headers

	params.body = dados
	
	network.request("http://"..endereco..":"..porta.."/TesteZonaAzul/rest/cartaozonaazul/relatorioscartoes", "POST", eventoTodasAsCompras, params)

end
--================================================================================================================================================================
return webService