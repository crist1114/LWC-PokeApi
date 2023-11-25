@isTest
public class PokemonCascadeDeleteTest {

    @isTest
    static void deletePoke(){
        Pokemon__c p = new Pokemon__c(Name__c='bolbasor', Url__c='sgdsdfdfdsfs.com');
        Ability__c a = new Ability__c(Name__c='fire', Url__c='sgdsdfdfdsfs.com');
        insert p;
        insert a;
        Pokemon_Ability__c pa = new Pokemon_Ability__c(Pokemon__c=p.Id, Ability__c=a.Id);
        Test.startTest();
        Database.DeleteResult result = Database.delete(p, false);
        Test.stopTest();
        System.assertEquals(true, result.isSuccess());
        System.assertEquals(p.Id, result.getId());
    }
}