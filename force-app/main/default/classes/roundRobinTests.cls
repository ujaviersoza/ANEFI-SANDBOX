@IsTest
public with sharing class roundRobinTests {

    @isTest static void roundRobinTestBulk(){
        list<account> accounts = new list<account>();
        list<roundRobinAssigner.RoundRobinAssignment> rras = new list<roundRobinAssigner.RoundRobinAssignment>();

        for (integer x=0; x<200; x++){
            account a = new account();
            a.Name = 'Account ' + x;
            accounts.add(a);
        }

        insert accounts;

        for (account a:accounts){
            roundRobinAssigner.RoundRobinAssignment rra = new roundRobinAssigner.RoundRobinAssignment();
            rra.groupName = 'TestGroup';
            rra.recordId = a.id;
            rras.add(rra);
        }

        Test.startTest();
            roundRobinAssigner.assign(rras);
        test.stopTest();

        //verify distribution of records
        list<account> accts = [select id, ownerId from account];
        map<id, integer> recordCountbyUser = new  map<id, integer>();


        for (account a:accts){
            if (recordCountbyUser.get(a.ownerId) == null){
                recordCountbyUser.put(a.ownerId, 1);
            } else {
                recordCountbyUser.put(a.ownerId, recordCountbyUser.get(a.ownerId)+1);
            }
        }

        id lastId;
        id currentId;

        for (id userId : recordCountbyUser.keySet()){
            system.debug(userid + ' : ' + recordCountbyUser.get(userid));
        }

        for (id userId : recordCountbyUser.keySet()){
            //it's the very first one
            if (lastId == null){
                lastId = userId;
            } else {
                if (currentId != null){
                    lastId = currentId;
                }
                currentId = userId;

                system.debug('last user is ' + lastId + ' with count ' + recordCountbyUser.get(lastId));
                system.debug('current user is ' + currentId + ' with count ' + recordCountbyUser.get(currentId));

                system.assert(recordCountbyUser.get(lastId) -  recordCountbyUser.get(currentId) < 2, 'user count should not differ by more than 2');
                system.assert(recordCountbyUser.get(lastId) -  recordCountbyUser.get(currentId) > -2, 'user count should not differ by more than 2');
            }
        }





    }

    @isTest
    public static void roundRobinTestsSingleAssign() {
        account a = new account();
        a.Name = 'Test Acct 1';

        account a2 = new account();
        a2.Name = 'Test Acct 2';

        //checking group data
        List<GroupMember> gms = [select id from GroupMember where Group.Name = 'TestGroup'];
        system.assertEquals(3, gms.size());

        insert a;
        roundRobinAssigner.RoundRobinAssignment rra = new roundRobinAssigner.RoundRobinAssignment();
        rra.groupName = 'TestGroup';
        rra.recordId = a.id;

        insert a2;
        roundRobinAssigner.RoundRobinAssignment rra2 = new roundRobinAssigner.RoundRobinAssignment();
        rra2.groupName = 'TestGroup';
        rra2.recordId = a2.id;


        test.startTest();
        list<roundRobinAssigner.RoundRobinAssignment> rras = new list<roundRobinAssigner.RoundRobinAssignment>();
        rras.add(rra);
        roundRobinAssigner.assign(rras);

        rras = new list<roundRobinAssigner.RoundRobinAssignment>();
        rras.add(rra2);
        roundRobinAssigner.assign(rras);

        test.stopTest();

        // verify they got assigned to different users
        list<account> accts = [select id, ownerId from account];
        system.debug(accts);
        system.assertEquals(2, accts.size());
        System.assert(accts[0].ownerId != accts[1].ownerId, 'account owners should not match after the assigner is run!');

    }

    @TestSetup
    public static void testSetup(){
        list<User> users = createUsers(3);

        system.assertEquals(3, users.size());

        group g = new Group();
        g.DeveloperName = 'TestGroup';
        g.Name = 'TestGroup';
        g.Type = 'Regular';

        insert g;

        List<GroupMember> gms = new List<GroupMember>();

        for (user u:users){
            groupMember gm = new groupMember();
            gm.UserOrGroupId = u.id;
            gm.GroupId = g.id;
            gms.add(gm);
        }

        insert gms;
    }


    public static list<user> createUsers(integer numberOfUsers){
        list<user> users = new list<user>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar'];
        for (integer i=0; i<numberOfUsers; i++){
            string x = string.valueOf(i);
            User u = new User(Alias = 't'+x, Email='standarduser'+x+'@testLightningSharing2017.msm',
                EmailEncodingKey='UTF-8', LastName='Testing' + x, LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+x+'@testPBBRoundRobin2018.msm');
            users.add(u);
        }

        insert users;
        system.assertEquals(numberOfUsers, users.size());
        return users;
    }
}