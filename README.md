# The Data Foundry - Sample DBT Project

This project is based on the standard `jaffle shop` model for dbt, including additional other models to replicate a more real world situation.

The purpose of this project is to show how to structure DBT projects as there are a number of ways, and they can conflict with each other if specific parts are not made explicit.

# Table of Contents
   
1. [Profiles](#profiles)
2. [Projects](#projects)
3. [Models](#models)
4. [Seeds](#seeds)
5. [Macros](#macros)
6. [Tags](#tags)
7. [Tests](#tests)
8. [Materialisation](#materialisation)
9. [Targets](#targets)
10. [Packages](#packages)
11. [Documents](#documents)
12. [Documentation Macros](#documentation-macros)

## Key Areas Included

### Profiles

The standard location for a profile file is ```~/.dbt/profiles.yml``` but if you are running multiple projects (eg. different clients) you might find it easier to keep multiple profile.yml files

The default ```dbt run``` command will look in the standard location, so if using multiple profiles use the following command

```bash
dbt run --profiles-dir .
```

### Projects

You can run multiple projects on a dbt profile, or you can build them all into one. If you have multiple projects you will have a copy of this folder structure for each project.
DBT looks for a file called `dbt_project.yml` to define the details of the project. 

```
NB: All models within a project need to be uniquely named, so it may make sense to use separate projects to reduce the likelyhood of this issue
```

### Models



#### Folders



#### Profile


#### Schema


### Seeds


### Macros


### Tags

#### [dbt Doco - Tags](https://docs.getdbt.com/reference/resource-configs/tags)

Tags can be used to separate out parts of a model so that it can be run in parts. This might be for dev purposes, different parts needing different run schedules (eg daily and hourly sections) or any other reason you need.

Tags need to be defined in 3 places, the project level, the model level (folder) or within the individual model. This project has some example tags within the base `dbt_project.yml` configured.

To run dbt for a tagged subset use the following code (assuming using a local profile)

```bash
dbt run --profiles-dir . -s tag:your_tag_name_here
```

### Tests

#### [dbt Doco - Tests](https://docs.getdbt.com/docs/building-a-dbt-project/tests)

Tests are important. Write tests.

Tests can be run against columns or tables. DBT contains only 4 built in tests, but can be expanded as needed with custom tests.

Tests can be run using the `dbt test` command.

All of the models have tests in them, but custom tests (using dbt_utils) are being used in the `mrr` model. A custom model of `date_format_check` is set to run on jaffles.order.order_date. Note that this test may return a SQL error, as the order field is already a date column and there seems to be a bug in Snowflake where running this function on a date breaks things. 

### Materialisation


### Targets

Targets (maybe better thought of as stages) allow for you to use your dbt project in different configurations as defined in your `profiles.yml` file. The sample profile has two targets to show how this might be used.

Targets will use what is defined in the `target:` key in the profile and can be overridden as needed to run in a different target. Probably the most common use case is leaving as `dev`, then setting a target or `test` or `prod` at runtime as needed. To use a specific target at runtime use the command below

```bash
dbt run --target your_target_here
```

### Packages

DBT can include additional packages to serve a number of functions. For more info [look here](https://docs.getdbt.com/docs/building-a-dbt-project/package-management) and [here](https://hub.getdbt.com/dbt-labs/codegen/latest/)

dbt-codegen is included in packages as an example, but packages can also be from a git repo too.

To install the dependancies run the following command:

```bash
dbt deps
```

Example usage:
```bash
dbt run-operation generate_source --args '{"schema_name": "jaffle_shop", "database_name": "raw"}' --profiles-dir . > source.yml
```


### Documents

DBT can automatically generate documentation of the environment. This contains a bunch of useful info like the columns, tests being run, the SQL and so on.

![dbt Documents](/etc/docs.png)

dbt also generates lineage graphs as part of the docs. This can be really helpful in debugging when you have a lot of models and dependancies.

![dbt Lineage](/etc/lineage.png)

To generate the docs run the command below:

```bash
dbt docs generate
```

To view the docs use this:

```bash
dbt docs serve
```

### Documentation Macros

Data quality, data standards, consistency, who wants to do all that?! You should!

Thankfully dbt makes that much easier when using this. In the `models/jaffles/schema.yml` file on the `status` column you'll see how its used. This, populates into the docs above and makes for some nice easy docs that are referenced in a single place. Notice in the `customer_id` column you can even include images in the doco if there is value.

# Jaffle Shop

## Testing dbt project: `jaffle_shop`

`jaffle_shop` is a fictional ecommerce store. This dbt project transforms raw data from an app database into a customers and orders model ready for analytics.

### What is this repo?
What this repo _is_:
- A self-contained playground dbt project, useful for testing out scripts, and communicating some of the core dbt concepts.

What this repo _is not_:
- A tutorial — check out the [Getting Started Tutorial](https://docs.getdbt.com/tutorial/setting-up) for that. Notably, this repo contains some anti-patterns to make it self-contained, namely the use of seeds instead of sources.
- A demonstration of best practices — check out the [dbt Learn Demo](https://github.com/dbt-labs/dbt-learn-demo) repo instead. We want to keep this project as simple as possible. As such, we chose not to implement:
    - our standard file naming patterns (which make more sense on larger projects, rather than this five-model project)
    - a pull request flow
    - CI/CD integrations
- A demonstration of using dbt for a high-complex project, or a demo of advanced features (e.g. macros, packages, hooks, operations) — we're just trying to keep things simple here!

### What's in this repo?
This repo contains [seeds](https://docs.getdbt.com/docs/building-a-dbt-project/seeds) that includes some (fake) raw data from a fictional app.

The raw data consists of customers, orders, and payments, with the following entity-relationship diagram:

![Jaffle Shop ERD](/etc/jaffle_shop_erd.png)


### Running this project
To get up and running with this project:
1. Install dbt using [these instructions](https://docs.getdbt.com/docs/installation).

2. Clone this repository.

3. Change into the `jaffle_shop` directory from the command line:
```bash
$ cd jaffle_shop
```

4. Set up a profile called `jaffle_shop` to connect to a data warehouse by following [these instructions](https://docs.getdbt.com/docs/configure-your-profile). If you have access to a data warehouse, you can use those credentials – we recommend setting your [target schema](https://docs.getdbt.com/docs/configure-your-profile#section-populating-your-profile) to be a new schema (dbt will create the schema for you, as long as you have the right privileges). If you don't have access to an existing data warehouse, you can also setup a local postgres database and connect to it in your profile.

5. Ensure your profile is setup correctly from the command line:
```bash
$ dbt debug
```

6. Load the CSVs with the demo data set. This materializes the CSVs as tables in your target schema. Note that a typical dbt project **does not require this step** since dbt assumes your raw data is already in your warehouse.
```bash
$ dbt seed
```

7. Run the models:
```bash
$ dbt run
```

> **NOTE:** If this steps fails, it might mean that you need to make small changes to the SQL in the models folder to adjust for the flavor of SQL of your target database. Definitely consider this if you are using a community-contributed adapter.

8. Test the output of the models:
```bash
$ dbt test
```

9. Generate documentation for the project:
```bash
$ dbt docs generate
```

10. View the documentation for the project:
```bash
$ dbt docs serve
```

### What is a jaffle?
A jaffle is a toasted sandwich with crimped, sealed edges. Invented in Bondi in 1949, the humble jaffle is an Australian classic. The sealed edges allow jaffle-eaters to enjoy liquid fillings inside the sandwich, which reach temperatures close to the core of the earth during cooking. Often consumed at home after a night out, the most classic filling is tinned spaghetti, while my personal favourite is leftover beef stew with melted cheese.

---
For more information on dbt:
- Read the [introduction to dbt](https://docs.getdbt.com/docs/introduction).
- Read the [dbt viewpoint](https://docs.getdbt.com/docs/about/viewpoint).
- Join the [dbt community](http://community.getdbt.com/).
---
