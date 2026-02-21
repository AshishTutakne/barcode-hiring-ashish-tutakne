# Take Home Task
## Description
This task is close to a real Dirac problem we had to solve and gives you a taste for software engineering here.

## The Task
You are building a key part of the new product tracking system at Dirac - deduplication. Every product has a barcode. We expect to ingest ~100,000 products into this new system in the next month, and if the system works then it will be many more!
We will be ingesting price lists, scraping websites, manually adding products. We have lots of different sources  - barcodes are the unique identifiers. We need a clean way of adding barcodes so we can match them. Barcodes are not simple identifiers though, there are different types (EAN,UPC...), but we never receive the barcode type with the data.

Your task is to build something to upsert products into this table. That means we need them deduplicated. For now, only do this by barcode matching.

Ingesting products for price comparisons is the bottleneck for the Operations team, so we need this _yesterday_. That means it needs to work in production, not just on your laptop.

Here is the kicker - we need all of the product ingesting code to be _in database_. This reflects how we code at Dirac and also will mean LLMs take you down some dark alleys...

Here are some docs that might help.
https://www.geeksforgeeks.org/postgresql/postgresql-introduction-to-stored-procedures/
https://pgtap.org/
If you need a hand understanding what _in database_ means, reach out for a hint.

This task should test your coding chops, but it is really about engineering tradeoffs. What edge cases do we need to consider? Is your code maintainable? Will it handle scale? Does that matter?  Does it work? How do you know it works?


We expect you to use an LLM for this task (although you don't have to). Try to tell us how you used it to help you and why.

Try and get what you can done in one working days worth of hours. 

### Extension
_we think this is a pretty cool thing to build - you might find it interesting_
Make an MCP tool (using any language you like) that will expose the database with permissions that only allow the LLM to use your methods for ingestion without access to the underlying tables. 

## Setup
I have provided:
1. A docker compose that will set up the database
2. [goose](https://github.com/pressly/goose) for migrations
3. A starter migration with a simple product table

Mirror this repo (make sure it is private!), share it with me and get to work!

## The Deliverable
1. the code
2. a demo explaining your solution (I used [kommodo](https://kommodo.ai/recordings for this) recently for this)
3. a document explaining _in detail_  the engineering decisions you took and why

Either in the video or the document you must explain how you used the LLM to help you - using an LLM well is a _good_ thing. If you don't understand what you have built, that is a _bad_ thing.
