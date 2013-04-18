module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    clean:
      ['lib']

    coffee:
      compile:
        files: grunt.file.expandMapping '**/*.coffee', 'lib/'
          cwd: 'src'
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, '.js')

  grunt.registerTask 'default', ['coffee']
  grunt.registerTask 'all', ['clean', 'coffee']
