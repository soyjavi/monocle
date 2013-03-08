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
        todomvc: ['todomvc/app/*.coffee'],
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
      },
      todomvc: {
        src: ['<config:resources.todomvc>'],
        dest: 'todomvc/app/build',
        options: {
            bare: true,
            preserve_dirs: false
        }
      }
    },


    min: {
      js: {
        src: ['<banner>', '<config:resources.js>'],
        dest: 'package/<%=meta.file%>.js'
      }
    },

    copy: {
      package: {
        files: { 'todomvc/components/monocle/': ['package/*'] }
      }
    },

    watch: {
      files: ['<config:resources.coffee>'],
      tasks: 'coffee min copy'
    }

  });

  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-contrib-copy');

  // Default task.
  grunt.registerTask('default', 'coffee min copy');

};
