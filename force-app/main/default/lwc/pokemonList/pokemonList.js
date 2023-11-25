import { LightningElement, wire, track } from 'lwc';
import getPokemons from '@salesforce/apex/PokemonController.getPokemons';
import existePokemon from '@salesforce/apex/PokemonController.existePokemon';
import getDescripcion from '@salesforce/apex/PokemonController.getDescripcion';

const columns = [
    { label: 'Name', 
    fieldName: 'name',
    },
    { label: 'URL', fieldName: 'url', type: 'url' },
    {
        label: 'View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
        iconName: 'action:preview',
        title: 'Preview',
        variant: 'border-filled',
        alternativeText: 'View'
        }
    },
    ];

export default class PokemonList extends LightningElement {

columns = columns;
@track container = false;
@track respuesta={};
pokemons;
fila = {};
pokemon = [{Id:''}];

totalPokemons = 0;
pokemonsMostrados;
pageSize =5;
end=5;

@wire(getPokemons)
obtenerPokemons({ data, error }) {
    if (data) {
        this.pokemons = data;
        this.totalPokemons = this.pokemons.length; 
        this.pokemonsMostrados = this.pokemons.slice(0,this.pageSize);
    } else if (error) {
        console.error(error);
    }
}

async handleRowAction(event) {
    this.fila = event.detail.row;
    const urlSplit = this.fila.url.split('/');
    const id = urlSplit[urlSplit.length - 2];
    const bypassCache = Math.floor(Math.random() * 10);
    
    await existePokemon({id:id, random:bypassCache}).then(res =>{
        this.pokemon = res.length===0 ? [{Id:''}] : res;
    });
    await this.obtenerDescripcion();
    this.container = true;
}

async obtenerDescripcion() {
    await getDescripcion({url: this.fila.url}).then(res =>{
        this.respuesta = {fila: this.fila, pokemon: this.pokemon, descripcionPokemon: res};
    }).catch(err => {
        console.log(err);
    })
}

handleRecibirEventoModal(evento){
    this.container = evento.detail;
}

handlePagination(){  
    let start = this.end;
    this.end = this.end+this.pageSize;

    if(this.end-1>this.pokemons.length){
        start=0;
        this.end=5;
    }
    this.pokemonsMostrados = this.pokemons.slice(start, this.end);
}

}