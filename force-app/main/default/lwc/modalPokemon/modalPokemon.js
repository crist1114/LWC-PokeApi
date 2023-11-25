import { LightningElement, api, track } from 'lwc';
import insertPokemon from '@salesforce/apex/PokemonController.insertPokemon';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import insertAbiity from '@salesforce/apex/PokemonController.insertAbiity';
import insertPokemonAbiity from '@salesforce/apex/PokemonController.insertPokemonAbiity';
import eliminarPokemon from '@salesforce/apex/PokemonController.eliminarPokemon';

const columnsAbility = [
    {
        label: 'Habilidades',
        fieldName: 'Name__c',
    }];

export default class ModalPokemon extends LightningElement {

    columnsAbility = columnsAbility;

    abilities = [];
    @api respuestah={};
    @track imageUrlDefault;
    @track imageUrlShiny;
    @api container;

    idPokemon;
    modalContainer = false;

    connectedCallback() {
        this.abilities = this.mapAbilities();
        this.imageUrlDefault = this.respuestah.descripcionPokemon.sprites.front_default;
        this.imageUrlShiny = this.respuestah.descripcionPokemon.sprites.front_shiny;
        this.toggleImages();

        this.idPokemon = this.respuestah.pokemon[0].Id;
        this.modalContainer = true;
    }

    async guardarAction() {//wekjfnsjrs.com/2
        const id = this.getExternalId(this.respuestah.fila.url);

        const result = await insertPokemon({ name: this.respuestah.fila.name, url: this.respuestah.fila.url, id: id });
        const idsAbilities = await insertAbiity({ abilities: this.abilities });

        //idp, id abi
        await insertPokemonAbiity({ idsAbility: idsAbilities.ids, idPokemon: result.ids });

        this.idPokemon = result.ids;
        this.closeModalAction();
        this.showToast('Exito', 'Haz capturado un pokemon!', 'success');
    }

    async eliminarAction(){
        const idEliminar = this.idPokemon;
        const result = await eliminarPokemon({id: idEliminar});
        
        this.closeModalAction();
        if (result.success) {
            this.showToast('Oh no!', 'Haz abandonado un pokemon!', 'warning');
        }
        this.idPokemon='';
    }

    toggleImages() {
        let intercambio1 = this.imageUrlDefault;
        let intercambio2 = this.imageUrlShiny;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setInterval(() => {
            this.imageUrlDefault = this.imageUrlDefault === intercambio1 ? intercambio2 : intercambio1;
            this.imageUrlShiny = this.imageUrlShiny === intercambio2 ? intercambio1 : intercambio2;
            
        }, 400); 
    }

    closeModalAction() {
        this.dispatchEvent(new CustomEvent('eventomodal', {detail: false }));
    }

    mapAbilities() {
            return this.respuestah.descripcionPokemon.abilities.map(resp => {
                const id = this.getExternalId(resp.ability.url); 
                return {
                    Name__c: resp.ability.name,
                    Url__c: resp.ability.url,
                    External_id__c: id
                };
            });
        }
    
    getExternalId(url){
        const id = url.split('/');
        return id[id.length - 2];
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}