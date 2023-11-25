import { createElement } from 'lwc';
import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import getPokemons from '@salesforce/apex/PokemonController.getPokemons';
import PokemonList from 'c/pokemonList';


// Mock the Apex method
const getPokemonsAdapter = registerApexTestWireAdapter(getPokemons);

describe('c-pokemon-list', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('displays records in the data table', async () => {
        // Arrange
        const element = createElement('c-pokemon-list', {
            is: PokemonList
        });
        

        // Act
        // You may want to mock getPokemons function or use getPokemonsAdapter to set the data in the component
        getPokemonsAdapter.emit([
            {
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon/1/"
            },
            {
                "name": "ivysaur",
                "url": "https://pokeapi.co/api/v2/pokemon/2/"
            }
        ]);
        document.body.appendChild(element);

        await Promise.resolve();
        const dataTable = element.shadowRoot.querySelector('lightning-datatable');
        console.log(dataTable.data);
        expect(dataTable).not.toBeNull();
        // expect(dataTable.data.length).toBe(/* number of records based on your mock data */);
    });
});