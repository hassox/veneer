# veneer

Veneer is an interface that sits above Data Sources.  A data source may be an ORM like ActiveRecord or DataMapper, or it could be a document store like MongoMapper, Mongoid, a key value storage like Moneta, or even an adapter could be setup to use for an external API.

Veneer aims to provide plugin, engine, and library authors with a consistant interface to any of these libraries so that plugins, engines, stacks and gems may be used across data store types.  Reusable code FTW!

It differs from ActiveModel in that it doesn't provide any validation support, serialization, callbacks, state machine or anything like that.  Veneer is intended to work _with_ ActiveModel to provide a data store independant interface to create reusable code.

Veneer instead aims to provide a simple interface for
* querying
* creating
* saving
* deleting
* basic lifecycle hooks
** before validation
** before save
** after save
** before destroy
** after destroy

There is no interface for validations, since this interface is handled as part of ActiveModel

## Quick Intro

<pre><code># Assume User class model

# Create new items
Veneer(User).new(:some => "parameters")     # instantiate only
Veneer(User).create(:some => "parameters")  # instantiate and persist
Veneer(User).create!(:some => "parameters") # create and raise on failure

# Query

# The supported options are:
#
# * :limit
# * :offset
# * :order
# * :conditions (hash with keys => <Array|Primitive|Range>

# First can be used in place of all to get a single item
# All options can be used together

Veneer(User).all(:limit => 3, :offset => 2)
Veneer(User).all(:order => ["name", "dob desc"])
Veneer(User).all(:conditions => {:some => "condition"})

# Update object
user = Veneer(User).first(:conditions => {:id => params[:id]})
user.update(:some => "new values") # updates and persists changes

# Destroy object
user = Veneer(User).first(:conditions => {:id => params[:id]})
user.destroy

Veneer(User).destroy_all

# Save
user.name = "bar"
user.save
# OR
user.save! # raise on fail

# Find associations
Veneer(User).collection_associations # grabs things like has_many and has n
Veneer(User).member_associations # grabs singular associations like belongs_to and has_one

# ====> results in
[ { :name => "asociaiton_name", :class => AssociationClass }]

# Find property names

Veneer(User).property_names # => [:name, :login, ...]

# Discover loaded model classes
Veneer.model_classes

</code></pre>

## Object methods

All methods that aren't found on the adapter, are passed through to the instance.  So to access any attributes on the actual model instance, just call the method on it. This can be handy to access things that should be avaialble with an ActiveModel.

## Current Support

Veneer currently has built in support for ActiveRecord and DataMapper and MongoMapper.

Veneer works on a VeneerInterface inner module though so you can easily impelment your adapter without requiring it to be in the veneer repo (although pull requests are welcome) (see Building Your Adapter)

To use DataMapper or ActiveRecord

<pre><code>
require 'veneer/adapters/activerecord'
require 'veneer/adapters/datamapper'
</code></pre>

## Building Your own Adapter

Veneer is made so that you don't need to have access to the main repository to create an adapter.  Veneer looks for an inner constant in the klass or object. For example, in ActiveRecord, to provide the adapter, Veneer will look for the adapter in ActiveRecord::VeneerInterface.  VeneerInterface should define two classes:

* ClassWrapper
* InstanceWrapper

So, you'd end up with

* ActiveRecord::Base::VeneerInterface::ClassWrapper < Veneer::Base::ClassWrapper
* ActiveRecord::Base::VeneerInterface::InstanceWrapper < Veneer::Base::InstanceWrapper

By using inner constants, no behavior of the base implementation is overwritten, or will clash with potential methods implented in the base data store.

It also means that any adapter can be created without direct access to the Veneer repository.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Daniel Neighman. See LICENSE for details.
