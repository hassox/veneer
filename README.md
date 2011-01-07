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

## Creating and Saving an instance

To create an instance of an object wrap the class in a vaneer call and create or get a new instance.

<pre><code>obj = Veneer(MyModel).new(:some => "hash", :of => "attributes")
obj.save

 # OR

obj = Veneer(MyModel).create(:some => "hash", :of => "attributes")
</code></pre>

There are also version that will raise an exception if it could not save

<pre><code>obj = Veneer(MyModel).new(:some => "attribute").save!

# OR

obj = Veneer(MyModel).create!(:some => "attribute")
</code></pre>

h2. Deleting

You can delete all the instances of a model or a single instance.

<pre><code>Veneer(MyModel).destroy\_all # delete all instances

@some\_veneer\_model.destroy
</code></pre>

### Updating

To update an instance:

<pre><code>@some\_veneer\_instance.update(:with => "attributes")

OR

@some\_veneer\_instance.update!(:with => "attributes") # raise on error
</code></pre>

## Queries

Veneer lets you query models with a simple interface.  Only simple queries are supported.

You can query a single object, or multiple objects.

<pre><code>Veneer(MyModel).first(:conditions => {:name => "foo"})

Veneer(MyModel).all(:conditions => {:age => 18}, :limit => 5)
</code></pre>

The supported options are:

* :limit
* :offset
* :order
* :conditions

## Limit & Offset

The :limit option will limit the number of returned results.

The :offset option, when set to an integer x will begin the results at the xth result.

## Order

Ordering should be set as an array.  By default, the order is decending.

The format of the array is:

<pre><code>["<field> <directon>", "<field>"]

### Example
  Veneer(MyModel).all(:order => [:name, "age desc")
</code></pre>

## Conditions

Conditions are a very simple set of conditions on the fields of the model.  The for of the conditions are:

<pre><code>:conditions => {:field => value}</code></pre>

<pre><code>
  Veneer(MyModel).all(:conditions => {:name => ["fred", "barney"], :age => (18..18)})
  Veneer(MyModel).first(:conditions => {:name => "fred"})
</code></pre>

Condition fields should be ready to accept:

* String
* Range (Between clauses)
* Array (IN clauses)
* nil

The results of a query are all wrapped as Veneer instances.

## All Together

<pre><code>Veneer(MyModel).all(:order => [:name, "age asc"], :limit => 5, :offset => 15, :conditions => {:name => "betty", :age => (0..18)})
</code></pre>

## Object methods

All methods that aren't found on the adapter, are passed through to the instance.  So to access any attributes on the actual model instance, just call the method on it. This can be handy to access things that should be avaialble with an ActiveModel.

## Current Support

Veneer currently has built in support for ActiveRecord and DataMapper.

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
