# therapeutor

Generator of automated therapy-deciding questionnaires. The idea behind this project was allowing doctors unable to code to generate questionnaires like [Migratron](https://github.com/pbanos/migratron).

These questionnaires are web applications where doctors answer a set of questions and the answers are automatically processed to decide among a set of options according to some declared logic on the questionnaire specification. The questionnaires were thought as an implementation of therapy-deciding algorithms, but other uses such as diagnostic algorithms should be possible.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [therapeutor](#therapeutor)
	- [Install (TODO)](#install-todo)
	- [Usage](#usage)
	- [Running a generated app](#running-a-generated-app)
	- [Questionnaire specification format](#questionnaire-specification-format)
		- [Variables](#variables)
		- [Sections](#sections)
		- [Recommendation levels](#recommendation-levels)
		- [Preference orders](#preference-orders)
		- [Therapies](#therapies)
			- [Boolean expression format](#boolean-expression-format)
	- [TODO](#todo)

<!-- /TOC -->

## Install (TODO)
To install therapeutor run the following

    gem install therapeutor

## Usage
To generate a questionnaire using a [questionnaire specification](#questionnaire-specification-format) in YAML, run the following:

    therapeutor generate path/to/questionnaire.yml  path/for/questionnaire/app

## Running a generated app

Therapeutor's app template is a parametrization of a [yeoman generator-angular](https://github.com/yeoman/generator-angular), therefore you will need to satisfy is requirements in order to run a therapeutor app:

* Make sure [Node.js](https://nodejs.org/en/download/package-manager/) is installed
* Install yeoman generator-angular dependencies

      npm install -g grunt-cli bower yo generator-karma generator-angular

In order to start the app, run the following:

    cd path/for/questionnaire/app
    npm install
    grunt serve

Finally, to package the app for deployment in production run:

    grunt

## Questionnaire specification format

Therapeutor questionnaires are specified in [YAML](https://en.wikipedia.org/wiki/YAML) format ([JSON](http://www.json.org/), as a subset of it, can be used as well) as an associative array with the following properties:

* name. A name for the questionnaire application.
* description. An optional text describing the questionnaire to be shown on the about section of the generated application.
* authors. A list of associative arrays with the following properties:
	* name. The name of the author
	* email. An optional email of contact of the author.
	* twitter. An optional twitter account of the author.
	* site. An optional URL describing the author.
	* organization. An optional text describing the organization to which the author belongs to.
* contributors. An optional list of associative arrays with the following properties:
	* name. The name of the contributor
	* email. An optional email of contact of the contributor.
	* twitter. An optional twitter account of the contributor.
	* site. An optional URL describing the contributor.
	* organization. An optional text describing the organization to which the contributor belongs to.
* disclaimer. Text to be shown to prevent the incorrect use or understanding of the questionnaire. It may contain html code.
* variables. This element is described later on.
* sections. This element is described later on.
* preference_orders. This element is described later on.
* recommendation_levels. This element is described later on.
* therapies. This element is described later on.
* default_boolean_answers. This optional property is declared as an associative array that sets the default labels for yes/no question answers (see the description of sections for further information). It has the following properties
  * yes: default label for boolean positive answers
  * no: default label for boolean negative answers
* no_suitable_therapies_text. Text to show when no suitable therapies can be recommended
* show_complete_evaluation_text. Text to describe the enabler/disabler that shows/hides all therapies evaluations

Some questionnaire YAML examples can be found on the [examples directory of the repository](https://github.com/pbanos/therapeutor/tree/master/examples).

### Variables

The element _variables_ declares the variables of the questionnaire that will store the answers to the questionnaire on the generated application. On the generated application, variables store boolean (yes/no, true/false) values. On the specification, _variables_ is a list of associative arrays, each representing a variable with two properties:

* name: a name for internal representation, it could suffer modifications when translated into questionnaire code.
* label: a label to show for a multiple-choice question answer when no other text is available

The variables element in a therapeutor questionnaire specification might look like this:

    variables:
      - name: pregnancy
        label: Pregnancy
      - name: chronic_constipation
        label: Chronic constipation
      - name: temperature
        label: Temperature
      - name: frequent_migraines
        label: Frequent migraines
      - name: taking_anticonceptive_pills
        label: Taking anticonceptive pills
      - name: taking_aspirin
        label: Taking aspirin
      - name: taking_ibuprofen
        label: Taking ibuprofen
      - name: taking_paracetamol
        label: Taking paracetamol

### Sections

The element _sections_ declares the questions of the questionnaire. On the generated application, questions are organized into blocks called sections and they allow the user to set the value of one or more variables. On the specification, _sections_ is a list of associative arrays, each representing a section or block of questions with the following properties:

* name: a name for the section
* description: an optional description to show as introduction to the block of questions
* questions: a list of associative arrays, each representing a question with two properties:

  * text: The text to show as question
  * variables: a list of associative arrays, each representing a variable the question sets. If the question only has one variable, it will be rendered as a yes/no question on the application and its properties in the specification must be:

    * name: the name of the variable as declared on the variables section
    * yes: a label to show for the boolean affirmative answer to the question. This property is optional and will take the value set in the *default_boolean_answers* property of the questionnaire by default.
    * no: a label to show for the boolean negative answer to the question. This property is optional and will take the value set in the *default_boolean_answers* property of the questionnaire by default.

    If however the question sets more than one variable, it will be rendered as a multiple-choice question on the application with an input to enable/disable each variable. Then, the properties of each associative array must be:

    * name: the name of the variable as declared on the variables section
    * text: a text describing the question option. This property is optional and will take the value set as label in the corresponding variable declaration by default.

The following is an example of a _sections_ element with 2 sections, each with a yes/no question and a multiple-choice question:

    sections:
      - name: Patient condition
        description: A description for the conditions of the patient
        questions:
          - text: Is the patient pregnant?
            variables:
              - name: pregnancy
          - text: "Does the patient suffer from the following conditions:"
            variables:
              - name: chronic_constipation
              - name: temperature
              - name: frequent_migraines
                text: Frequent migraines (more than one a week)
      - name: Drugs the patient is taking
        questions:
          - text: Is the patient taking birth control pills?
            variables:
              - name: taking_anticonceptive_pills
                yes: Yes, they are taking anticonceptive pills or have taken them less than 3 months ago
                no: No, they have not taken anticonceptive pills for more than 3 months
          - text: Mark other drugs the patient is taking:
            variables:
              - name: taking_aspirin
                text: Aspirin
              - name: taking_ibuprofen
                text: Ibuprofen
              - name: taking_paracetamol
                text: Paracetamol

Declaration order in this element matters: sections, questions and variable inputs for multiple-choice questions are rendered in the order of declaration.

### Recommendation levels

On a therapeutor-generated app, therapies are assigned to different levels of recommendation. These levels have an order and can prevent the recommendation of a therapy altogether. The generated application will use the classification of therapies into recommendation levels as the first filter when selecting the therapy, reducing the candidate set to those therapies with the highest level of recommendation available (as long as that level is not preventing recommendation entirely).

On the specification, *recommendation_levels* is a list of associative arrays, each representing one of these recommendation levels, in ascending order of suitability, with the following properties:

* name: an internal name for the recommendation level
* label: a label with which the recommendation level will be rendered on the evaluation of therapies that are classified into it
* description: an optional text explaining the meaning of the recommendation level, if provided it will be rendered on the evaluation results of the therapies that are classified into it
* color: 'green', 'yellow' or 'red', it defines the color-code of the evaluation of a therapy, emphasizing the meaning of the recommendation level.
* banning: an optional boolean value (true or false, yes or no), false by default, if set to true makes a recommendation level prevent the recommendation of its therapies altogether.

The following would be an example of a recommendation level element declaration:

    recommendation_levels:
      - name: forbidden
        label: Strictly forbidden
        description: This therapy should not be applied to the patient under any circumstances
        color: red
        banning: true
      - name: notRecommended
        label: Not recommended
        description: This therapy can present complications and should only be applied if no other is more suitable
        color: yellow
      - name: recommended
        label: Recommended
        description: This therapy can be applied to the patient
        color: green
        banning: false

### Preference orders

It usually happens that different therapies end up assigned to the same recommendation level. The orders the *preference_orders* element declares provide a way of resolving this situation and selecting among therapies in the same recommendation level. These orders can be static or dynamic:

* Static orders are based on a static numeric property of the therapies. For example a price order.
* Dynamic orders are based on the satisfaction of a number of conditions on the answers to the questionnaire. This allows us to declare a questionnaire that recommends a therapy over another when the first one treats more concomitant conditions from which a patient suffers, for example.

On the specification, the *preference_orders* element is a list of associative arrays, each representing a preference order. The following properties are available for static preference orders:

* type: it must be set to 'static' to declare the order as a static preference order
* name: an internal name for identifying the preference order
* label: a label to show the preference order as on the evaluation of therapies
* *draw_resolution_text*: a text to show when the preference order has been determinant for the therapy selection
* descending: an optional property indicating a lower value indicates higher preference, false by default
* property: the name of the therapy property to use for sorting

The following properties are available for dynamic preference orders:

* type: it must be set to 'dynamic' to declare the order as a dynamic preference order
* name: an internal name for identifying the preference order
* label: a label to show the preference order as on the evaluation of therapies
* text: a description of the order that will precede the description of satisfied conditions on the evaluation of therapies
* *draw_resolution_text*: a text to show when the preference order has been determinant for the therapy selection
* descending: an optional boolean value (true or false, yes or no) indicating a lower value indicates higher preference, false by default

The order of declaration of preference orders matters: the generated algorithm will apply preference orders one after another to solve a draw until the draw is resolved in the order in which they are declared.

The following would be an example of preference order element declaration:

    preference_orders:
      - type: dynamic
        name: concomitant_conditions
        label: Concomitant conditions
        text: This therapy also treats the following concomitant conditions
        draw_resolution_text: The recommended therapy has been recommended over another because of the number of concomitant conditions it treats
      - type: static
        name: price
        label: Price
        draw_resolution_text: The recommended therapy has been recommended over another because of its price
        descending: yes

### Therapies

Therapies are the elements among which the generated app's algorithm selects the best candidate. As explained above, the algorithm first assigns each therapy one of the declared recommendation levels to reduce the therapy set to those with the higher recommendation level, then sorts them using the declared preference orders. Besides, their name and description, therapies declare the set of conditions that qualify them for a recommendation level as well as those counted by a dynamic preference order and the properties on which static preference orders are evaluated.

On the specification, the *therapies* element is a list of associative arrays, each representing a therapy with the following properties:

* name: an internal name to identify the therapy.
* label: a label to use to refer to the therapy on the questionnaire's evaluation.
* description: an optional text describing the therapy that will be shown in the questionnaire's evaluation.
* properties: an associative array with numeric properties of the therapy. The property names used here are the names to refer to when declaring a static preference order. If a static order has been declared, the property it refers to should be available on every declared therapy.
* level_conditions: used to relate a therapy with the set of conditions that assign it to a recommendation level, this is declared as an associative array relating recommendation level names to a list of associative arrays, each representing a condition with the following two properties:

  * text: the reason to be shown when the therapy is assigned this level because of this condition being true
  * condition: the boolean expression, in the [boolean expression format](#boolean-expression-format) described below, that when evaluated to true assigns the therapy to the recommendation level

  On the generated app, a therapy will always be assigned the lowest recommendation level for which one of the conditions activate or evaluate to true. Not declaring conditions for a level on a therapy is equivalent to declaring an only _false_ condition on it, but for the case of the highest recommendation level where it is equivalent to an only _true_ condition (thus guaranteeing a therapy is always assigned a recommendation level).
* order_conditions: used to relate a therapy with the set of conditions that when met give it a higher evaluation regarding a declared preference order, this is declared as an associative array relating preference order names to a list of associative arrays, each representing a condition with the following two properties:

  * text: the reason to be shown when the preference of this therapy increases because of this condition being true
  * condition: the boolean expression, in the [boolean expression format](#boolean-expression-format) described below, that when evaluated to true increases the preference of the therapy in regard to the preference order

  If a therapy does not declare any conditions for a preference order, the preference order will give the lowest evaluation for it: 0.

The following is an example of a therapies element declaration:

    therapies:
      - name: aspirin
        label: Aspirin
        description: Acetylsalicylic acid (ASA)
        properties:
          price: 3
        level_conditions:
          forbidden:
            - text: The patient has an ulcer
              condition:
                variable: ulcer
            - text: The patient is allergic to ibuprofen
              condition:
                variable: ibuprofen_allergic
          not_recommended:
            - text: The patient has kidney disease
              condition:
                variable: kidney_disease
        order_conditions:
          concomitant_conditions:
            - text: It also treats migraines, from which the patient is suffering
              condition:
                variable: migraine
      - name: omeprazole
        label: Omeprazole
        properties:
          price: 5
        level_conditions:
          not_recommended:
            - text: The patient has osteoporosis
              condition:
                variable: osteoporosis
        order_conditions:
          concomitant_conditions:
            - text: It also treats ulcers, from which the patient is suffering
              condition:
                variable: ulcer

#### Boolean expression format
A boolean expression can be one of the following:

* A variable, specified as an associative array with the property _variable_ indicating the name of a declared variable in the [variables section](#variables):

      variable: _name of the variable_


* A boolean constant, specified as an associative array with the property _constant_ set to the boolean constant value. True is specified as

      constant: true

  and false is specified as

      constant: false

* A boolean negation of a boolean expression, specified as an associative array with the property _not_ set to the boolean expression that is negated:

      not: _expression_

* A boolean AND of a set of expressions, specified as an associative array with the property _and_ set to a list of boolean expressions:

      and:
        - _expression 1_
        - _expression 2_
        [...]
        - _expression n_

* A boolean OR of a set of expressions, specified as an associative array with the property _or_ set to a list of boolean expressions:

      or:
        - _expression 1_
        - _expression 2_
        [...]
        - _expression n_

Thus, to specify "a & ¬( b | c | ¬d | false | (e & f))" we would type:

    and:
    - variable: a
    - not:
        or:
          - variable: b
          - variable: c
          - not:
              variable: d
          - constant: false
          - and:
              - variable: e
              - variable: f

## TODO

* Show error messages for strict validation checks on the questionnaire before rendering
* Show warnings for non-strict validation checks on the questionnaire before rendering, such as:
  * Variable declared but not used
  * Therapy property declared but not used
* Adapt the README for the generated app to include references to therapeutor
* Adapt contact/about section to include author and contributor information
* Conditional showing of sections and questions based on already answered questions
