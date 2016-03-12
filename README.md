# therapeutor
Generator of automatised theraupetic questionnaires

## Usage
therapeutor [-o /app/output/path] [questionnaire.yml | - ]

## Input format

The input format must be a valid YML file following the schema below:

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
  preference_orders: [
    {
      type #either 'static' (depends on therapy property) or 'dynamic' (depends on the number of answers satisfying therapy-dependent conditions)
      name
      text # Description to show when preference order resolves a draw
      descendent # optional, set to some value to indicate lower values are preferred
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
      properties # the set of values according to which static preference orders must rank the therapy
      level_conditions: {
        <name of the level>: { # condition for the assignation of the level: or condition of (optionally negated) variables and subconditions
          negated
          variables: [
            {
                name # name of the variable
                text # reason to be shown when the therapy is assigned this level because of the variable activating
            }
          ]
          subconditions: [
            {
              text # reason to be shown when the therapy is assigned this level because of the subcondition activating
              negated
              variables
              subconditions
            }
          ]
        }
      }
      order_condition_counts: {
        <name of the order condition count>: [
          { # condition for count increase of the order to therapy: or condition of (optionally negated) variables and subconditions
            text
            negated
            variables: [
              {
                  name # name of the variable
              }
            ]
            subconditions: [
              {
                negated
                variables
                subconditions
              }
            ]
          }
        ]
      }
    }
  ]
  default_boolean_question: { # optional
    yes # Default label for boolean positive answers
    no # Default label for boolean negative answers
  }
}
