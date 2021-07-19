Moralis.initialize("g8INzwu169S7MJxvTawg964psf4EV7TjEyfuf7xi");
Moralis.serverURL = "https://yfuf1p2njpe0.usemoralis.com:2053/server";
const contractAdress = "0x6dC8722cA0D8C7717CFD1267bA44687448c8c912";

function toggleButtons( isLoggedIn )
{
    if (isLoggedIn) {
        $('#login-button').hide();
        $('#logout-button').show();

        return;
    }

    $('#logout-button').hide();
    $('#login-button').show();
}

function initButtons(){
    $('#logout-button').on( 'click', function(e){
        Moralis.User.logOut().then(() => {
            toggleButtons(false);
        });
    }); 

    $('#login-button').on( 'click', function(e){
        Moralis.Web3.authenticate().then( function(user){
            render(user);
            toggleButtons(true);
        });
        return false;
    }); 
}

function init(){
    initButtons();

    try {
        let user = Moralis.User.current();

        if (user) {
            toggleButtons(true);
            render(user);
            return;
        }
        
        toggleButtons(false);
    } catch (error) {
        
    }
}

function render(user){
    Moralis.Web3.enable().then( (web3) => {
        const ethAddress = user.get('ethAddress');

        getAbi().then( (abi) => {
            let contract = new web3.eth.Contract( abi, contractAdress );

            contract.methods.nameUrlPairsOfOwner( ethAddress ).call({from: ethereum.selectedAddress }).then( (data) => {
                data.forEach(element => {
                    console.log(element);
                });
            } );
        });

    });
}

async function getAbi(){
    return new Promise( (res) => {
        $.getJSON( 'abi.json', function(data){
            res(data);
        });
    });
}

init();