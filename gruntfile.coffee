module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package/component.json"

    meta:
      file: 'monocle'
      endpoint: 'package',
      banner: '/* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy/m/d") %>\n' +
              '   <%= pkg.homepage %>\n' +
              '   Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
              ' - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */\n'


    resources:
      src: [
        'src/monocle.coffee',
        'src/monocle.*.coffee']
      spec: [
        'spec/*.coffee']

    coffee:
      src:
        files:
          '<%= meta.endpoint %>/<%= meta.file %>.debug.js': ['<%= resources.src %>']
          'build/spec.js': ['<%= resources.spec %>']

    uglify:
      options:
        compress: false
        banner: '<%= meta.banner %>'
      endpoint:
        files: '<%=meta.endpoint%>/<%=meta.file%>.js':  '<%= meta.endpoint %>/<%= meta.file %>.debug.js'

    jasmine:
        pivotal:
          src: 'package/<%=meta.file%>.debug.js'
          options:
            specs: 'build/spec.js',
            vendor: 'todomvc/components/jquery/jquery.js'

    watch:
      src:
        files: ['<%= resources.src %>']
        tasks: ['coffee:src', 'uglify', 'jasmine']
      # spec:
      #   files: ['<%= resources.spec %>']
      #   tasks: ['stylus:stylesheets', 'stylus:theme']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks('grunt-contrib-jasmine')

  grunt.registerTask 'default', ['coffee', 'uglify', 'jasmine']
