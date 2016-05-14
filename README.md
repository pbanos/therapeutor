# therapeutor

Generator of automatised therapy-deciding questionnaires. The idea behind this project was allowing doctors unable to code to generate questionnaires like [Migratron](https://github.com/pbanos/migratron)

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

## YAML questionnaire format
The input format must be a valid YAML file following the schema below:

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
          - [...]
          - <expression n>

* A boolean OR of a set of expressions, specified as:

        or:
          - <expression 1>
          - <expression 2>
          - [...]
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
