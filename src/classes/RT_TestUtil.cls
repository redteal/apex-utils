@isTest
global class RT_TestUtil {

	final static RT_Assert Assert;
	final static Set<String> COLORS;

	static {
		Assert = RT_Assert.INSTANCE;
		COLORS = new Set<String> {'Red', 'Green', 'Blue'};
	}

	static Profile stdProfile;

	global static Profile getStandardProfile() {
		if (stdProfile == null) {
			stdProfile = [ SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1 ];
		}
		return stdProfile;
	}

	global static User testUser() {
		return testUser('Test', 'User');
	}

	global static User testUser(Profile p) {
		return testUser('Test', 'User', p);
	}

	global static User testUser(String fName, String lName) {
		return testUser(fName, lName, getStandardProfile());
	}

	global static User testUser(String fName, String lName, Profile p) {
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		Integer randomInt = Integer.valueOf(Math.rint(math.random() * 1000000));
		String uniqueName = orgId + dateString + randomInt;
		User u = new User(
		    FirstName = fName,
		    LastName = lName,
		    Email = uniqueName + '@test' + orgId + '.org',
		    Username = uniqueName + '@test' + orgId + '.org',
		    EmailEncodingKey = 'ISO-8859-1',
		    Alias = uniqueName.substring(18, 23),
		    TimeZoneSidKey = 'America/Los_Angeles',
		    LocaleSidKey = 'en_US',
		    LanguageLocaleKey = 'en_US',
		    ProfileId = p.id
		);
		return u;
	}

	global static FooData setupFooData(Integer nFoos, Integer nBars, Integer nQuxs) {
		FooData data = new FooData();
		insert data.addFoos(nFoos);
		insert data.addBars(nBars);
		insert data.addQuxs(nQuxs);
		update data.setLookupsOnFoos();
		return data;
	}

	global class FooData {
		global List<Foo__c> foos;
		global List<Bar__c> bars;
		global List<Qux__c> quxs;
		global Map<String, List<Foo__c>> foosByColor;

		global FooData() {
			foos = new List<Foo__c>();
			bars = new List<Bar__c>();
			quxs = new List<Qux__c>();
			foosByColor = new Map<String, List<Foo__c>> {
				'Red' => new List<Foo__c>(),
				'Green' => new List<Foo__c>(),
				'Blue' => new List<Foo__c>(),
				null => new List<Foo__c>()
			};
		}

		global List<Foo__c> addFoos(Integer n) {
			Assert.assertTrue('n must be positive, non-zero, and a multiple of 3', n > 0 && Math.mod(n, 3) == 0);
			n = Math.ceil(n / 3).intValue();
			for (String color : COLORS) {
				addFoos(color, n);
			}
			return foos;
		}

		global List<Foo__c> addFoos(String color, Integer n) {
			Assert.assertTrue('n must be at least 1', n >= 1);
			List<Foo__c> byColor = foosByColor.get(color);
			Assert.assertNotNull(byColor);
			for (Integer i = 0; i < n; i++) {
				Integer x = 1;
				Foo__c foo = new Foo__c(
				    Color__c = color,
				    A__c = i + Math.pow(x++, 2),
				    B__c = i + Math.pow(x++, 2),
				    C__c = i + Math.pow(x++, 2),
				    D__c = i + Math.pow(x++, 2),
				    X__c = i + Math.pow(x++, 2),
				    Y__c = i + Math.pow(x++, 2),
				    Z__c = i + Math.pow(x++, 2)
				);
				byColor.add(foo);
				foos.add(foo);
			}
			return foos;
		}

		global List<Bar__c> addBars(Integer n) {
			Assert.assertTrue('n must be at least 1', n >= 1);
			for (Foo__c foo : foos) {
				Assert.assertNotNull(foo.Id);
				for (Integer i = 0; i < n; i++) {
					Integer x = 1;
					Bar__c bar = new Bar__c(
					    Foo__c = foo.Id,
					    A__c = i + Math.pow(x++, 2),
					    B__c = i + Math.pow(x++, 2),
					    C__c = i + Math.pow(x++, 2)
					);
					bars.add(bar);
				}
			}
			return bars;
		}

		global List<Qux__c> addQuxs(Integer n) {
			Integer nRequired = bars.size() == foos.size() ? 2 : 1;
			Assert.assertTrue('n must be at least ' + nRequired, n >= nRequired);
			for (Bar__c bar : bars) {
				Assert.assertNotNull(bar.Id);
				for (Integer i = 0; i < n; i++) {
					Integer x = 1;
					Qux__c qux = new Qux__c(
					    Bar__c = bar.Id,
					    A__c = i + Math.pow(x++, 2),
					    B__c = i + Math.pow(x++, 2),
					    C__c = i + Math.pow(x++, 2)
					);
					quxs.add(qux);
				}
			}
			return quxs;
		}

		global List<Foo__c> setLookupsOnFoos() {
			Assert.assertFalse(foos.isEmpty());
			Assert.assertFalse(bars.isEmpty());
			Assert.assertFalse(quxs.isEmpty());
			for (Integer i = 0; i < foos.size(); i++) {
				Foo__c foo = foos.get(i);
				foo.QuxA__c = quxs.get(i).Id;
				foo.QuxB__c = quxs.get(i + 1).Id;
			}
			return foos;
		}
	}
}
