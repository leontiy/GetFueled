GetFueled
=========

The app shows venues Recommended by Foursquare around Fueled NY office, does all things requested in the test:

1. Long press a restaurant to block it from appearing again among recommended venues
2. Reviews
3. Restaurant bookmarking
4. Compatible with iOS 6 and iOS 7

Tech Notes
==========

Model object classes are generated/updated by MOGenerator on every build.

RestKit is used as thin layer over AFNetworking with data parsing capabilities. It attracted my attention for its declarative-style mapping of JSON to CoreData managed objects (also handles remote object identity). It was an experiment and I'm not terribly happy with the clumsiness of the entity mapping code and RestKit's complex unnatural relationship with CoreData. RestKit+CoreData should definitely not be a combination of choice for a short project like this: the risks of unexpected complex issues is high while the benefit of a quasi-general-purpose solution is doubtful. Apparently, some json schemas cannot be matched succinctly with mappings and require complex unnatural object structure (or manual processing of json before mapping).