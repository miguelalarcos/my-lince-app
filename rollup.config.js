import babel from 'rollup-plugin-babel';
import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import riot from 'rollup-plugin-riot';
import replace from 'rollup-plugin-replace'

export default {
    entry: 'main.js',
    format: 'iife',
    sourceMap: true,
    plugins: [replace({'process.env.NODE_ENV': JSON.stringify( 'development' )}),
              riot(),
              nodeResolve({browser: true, main:true, jsnext: true}),
              commonjs(),
              babel({"babelrc": false, "presets": ["es2015-rollup"]})
    ],
    external: ['lodash', 'mobx'],
    globals: {lodash: 'lodash', mobx: 'mobx'},
    dest: 'bundle.js'
};
