


# template = """
#     <h1>{{header}}</h1>
#     {{#bug}}
#     {{/bug}}

#     {{#items}}
#       {{#first}}
#         <li><strong>{{name}}</strong></li>
#       {{/first}}
#       {{#link}}
#         <li><a href="{{url}}">{{name}}</a></li>
#       {{/link}}
#     {{/items}}

#     {{#empty}}
#       <p>The list is empty.</p>
#     {{/empty}}
# """

# data = {
#   "header": "Colors",
#   "items": [
#       {"name": "red", "first": true, "url": "#Red"},
#       {"name": "green", "link": true, "url": "#Green"},
#       {"name": "blue", "link": true, "url": "#Blue"}
#   ],
#   "empty": false
# }

# console.log Mustache.render(template, data)

# template = """
# {{#repos}}<b>{{name}}</b>{{/repos}}
# {{^repos}}No repos :({{/repos}}
# """

# data = {
#   "repos": []
# }

# console.log Mustache.render(template, data)

# base = """
# <h2>Names</h2>
# {{#names}}
#   {{> user}}
# {{/names}}
# """

# user = """
# <strong>{{name}}</strong>
# """

# console.log Mustache.render(base, data, user)

# console.log('MILK', window, milk)


template = """
{{#users}}
    <li>{{{name}}} - {{name}} ({{twitter}})</li>
{{/users}}
"""

data = {
    users: [
        {name: '<b>Javi</b>', twitter: '@soyjavi'},
        {name: 'Cata', twitter: '@cata'}
    ]
}



console.log Mustache.render(template, data)

console.error(window)
