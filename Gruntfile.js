'use strict';

module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compileScripts: {
        expand: true,
        flatten: false,
        cwd: 'scripts',
        src: '**/*.coffee',
        dest: '.tmp/scripts/',
        ext: '.js'
      },
      compileSpecs: {
        expand: true,
        flatten: false,
        cwd: 'spec',
        src: 'frontEnd/**/*.coffee',
        dest: '.tmp/spec/',
        ext: '.js'
      }
    },
    concat: {
      options: {
        seperator: ';'
      },
      dist: {
        src: ['lib/namespace.js', '.tmp/scripts/frontEnd/**/*.js'],
        dest: 'dist/<%= pkg.name %>.js'
      },
      server: {
        src: ['.tmp/scripts/server.js'],
        dest: 'server.js'
      }
    },
    uglify: {
      dist: {
        files: {
          'dist/<%= pkg.name %>.min.js': ['<%= concat.dist.dest %>'],
          'dist/backEnd/googleOauthWrapper.min.js': '.tmp/scripts/backEnd/googleOauthWrapper.js',
          'dist/backEnd/googleEmailWrapper.min.js': '.tmp/scripts/backEnd/googleEmailWrapper.js'
        }
      }
    }
  });

  grunt.registerTask('default', ['coffee', 'concat', 'uglify']);
}
