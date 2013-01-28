module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package/component.json>',

    meta: {
        file: "monocle",
        name: 'Monocle - Amazing Monocle',
        banner: '/* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy/m/d") %>\n' +
                '   <%= pkg.homepage %>\n' +
                '   Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
                ' - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */'
    },

    resources: {
        coffee: ['src/**/*.coffee', 'spec/**/*.coffee'],
        js: ['build/**/monocle.js',
            'build/**/monocle.model.js',
            'build/**/monocle.controller.js',
            'build/**/monocle.view.js',
            'build/**/monocle.templayed.js',
            'build/**/monocle.route.js']
    },


    coffee: {
      app: {
        src: ['<config:resources.coffee>'],
        dest: 'build',
        options: {
            bare: true,
            preserve_dirs: true
        }
      }
    },

    concat: {
      js: {
        src: ['<config:resources.js>'],
        dest: 'build/<%=meta.file%>.js'
      }
    },


    min: {
      js: {
        src: ['<banner>', 'build/<%=meta.file%>.js'],
        dest: 'package/<%=meta.file%>.js'
      }
    },


    watch: {
      files: ['<config:resources.coffee>'],
      tasks: 'coffee concat min'
    },


    uglify: {}
  });

  grunt.loadNpmTasks('grunt-coffee');

  // Default task.
  grunt.registerTask('default', 'coffee concat min');

};
