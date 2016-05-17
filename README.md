# therapeutor

Generator of automatised therapy-deciding questionnaires. The idea behind this project was allowing doctors unable to code to generate questionnaires like [Migratron](https://github.com/pbanos/migratron).

This questionnaires are web applications where doctors answer a set of questions and the answers are automatically processed to decide among a set of options according to some declared logic on the questionnaire specification. The questionnaires were thought as an implementation of therapy-deciding algorithms, but other uses such as diagnostic algorithms should be possible.

## Install (TODO)
To install therapeutor run the following

        gem install therapeutor

## Usage
To generate a questionnaire using a questionnaire specification in YAML

        therapeutor generate path/to/questionnaire.yml  path/for/questionnaire/app

## Generated app
Therapeutor's app template is a parametrization of a [yeoman generator-angular](https://github.com/yeoman/generator-angular), therefore you will need to satisfy is requirements in order to run in:

        npm install -g grunt-cli bower yo generator-karma generator-angular

In order to start the app, run the following:

        cd path/for/questionnaire/app
        npm install
        grunt serve

Finally, to package the app for deployment in production run:

        grunt

## Questionnaire specification format

Therapeutor questionnaires are specified in [YAML](https://en.wikipedia.org/wiki/YAML) format ([JSON](http://www.json.org/), as a subset of it, can be used as well) using the following elements:

* Metadata.
* Variables. The element _variables_ declares the variables of the questionnaire that will store the answers to the questionnaire on the generated application. On the generated application, they store boolean (yes/no, true/false) values. On the specification, _variables_ is a list of associative arrays, each representing a variable with two properties:
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
* Sections. The element _sections_ declares the questions of the questionnaire. On the generated application, questions are organized into blocks called sections and they allow the user to set the value of one or more variables. On the specification, _sections_ is a list of associative arrays, each representing a section or block of questions with the following properties:
  * name: a name for the section
  * description: an optional description to show as introduction to the block of questions
  * questions: a list of associative arrays, each representing a question with two properties:
    * text: The text to show as question
    * variables: a list of associative arrays, each representing a variable the question sets. If the question only has one variable, it will be rendered as a yes/no question on the application and its properties in the specification must be:
      * name: the name of the variable as declared on the variables section
      * yes: a label to show for the boolean affirmative answer to the question. This property is optional and will take the value set in the default_boolean_question element by default.
      * no: a label to show for the boolean negative answer to the question. This property is optional and will take the value set in the default_boolean_question element by default.

    If however the question sets more than one variable, it will be rendered as a multiple-choice question on the application with an input to enable/disable each variable. Then, the properties of each associative array must be:
      * name: the name of the variable as declared on the variables section
      * text: a text describing the question option. This property is optional and will take the value set as label in the corresponding variable declaration by default.

  The following is an example of a sections element with 2 sections, each with a yes/no question and a multiple-choice question:

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
* Recommendation levels. The element _recommendation_levels_ declares the different levels of suitability or recommendation a therapy can be assigned. Levels have an order and can prevent the recommendation of a therapy altogether. The generated application will use the classification of therapies into recommendation levels as the first filter when selecting the therapy, reducing the candidate set to those therapies with the highest level of recommendation available (as long as that level is not preventing recommendation altogether).

  On the specification, _recommendation_levels_ is a list of associative arrays, each representing a recommendation level ordered from least suitable to most suitable with the following properties:
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

* Preference orders
* Therapies
* Other properties

The complete schema would be the following:

        {
          name
          contact
          authors
          contributors
          disclaimer
          variables: [
            {
              name
              label
            }
          ]
          sections: [
            {
              name
              description
              questions: [
                {
                  text
                  variables: {
                    {
                      name
                      text # if multiple choice question
                      yes # label for boolean positive answers, if yes/no question, optional
                      no # label for boolean negative answers, if yes/no question, optional
                    }
                  }
                }
              ]
            }
          ]
          preference_orders: [ #Order of preference orders matters: Preference orders only influence a therapy over another if previous orders have not been able to decide between the two.
            {
              type #either 'static' (depends on therapy property) or 'dynamic' (depends on the number of answers satisfying therapy-dependent conditions)
              name # Internal name for the order
              label # The text to show the order as
              text # Description of the order
              drawing_resolution_text # Text to show when preference order resolves a draw
              descending # optional, set to some value to indicate lower values are preferred
              property # only for static-typed, the name of the therapy property to use
            }
          ]
          recommendation_levels: [ # The declaration order matters: a level is only considered if previously-declared levels have been discarded
            {
              name # Internal name for the level
              label # The text to show the level as
              description # optional, some text describing the level
              color # the color-code to assign to therapies evaluating to this level, (green, yellow, red)
              banning # optional, set to some value to indicate evaluation to this level discards the therapy
            }
          ]
          therapies: [ # The declaration order matters: other rankings being non-decisive (or in absence thereof), this order will resolve any draws
            {
              name # Internal name for the therapy
              label # The label to use to refer to the therapy on the questionnaire
              description # optional, some text describing the therapy
              properties: { # the set of values according to which static preference orders must rank the therapy
                <name of property>: <numeric value>
              }
              level_conditions: {
                <name of the level>: [
                  { # condition for the level activating for the therapy
                    text # reason to be shown when the therapy is assigned this level because of the condition activating
                    condition # boolean expression that activates the condition when evaluated to true, expressed in the format described below
                  }
                ]
              }
              order_conditions: {
                <name of the dynamic order>: [
                  { # condition for count increase of the order of the therapy
                    text # reason to be shown when the condition activates for the therapy
                    condition # boolean expression that activates the condition when evaluated to true, expressed in the format described below
                  }
                ]
              }
            }
          ]
          default_boolean_question: { # optional
            yes # Default label for boolean positive answers
            no # Default label for boolean negative answers
          }
          no_suitable_therapies_text # Text to show when no suitable therapies can be recommended
          show_complete_evaluation_text # Text to describe the enabler/disabler that shows/hides all therapies evaluations
        }

Some questionnaire YAML examples can be found on the examples directory of the repository

### Boolean Expression format
A boolean expression can be one of the following:

* A variable, specified as

      variable: <name of the variable>

* A boolean constant. True is specified as

      constant: true

  and false is specified as

      constant: false

* A boolean negation of a boolean expression, specified as:

      not: <expression>

* A boolean AND of a set of expressions, specified as:

      and:
        - <expression 1>
        - <expression 2>
        [...]
        - <expression n>

* A boolean OR of a set of expressions, specified as:

      or:
        - <expression 1>
        - <expression 2>
        [...]
        - <expression n>

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
* Adapt the README for the generated app to include references to therapeutor
* Adapt contact/about section to include author and contributor information
* Conditional showing of sections and questions based on already answered questions
