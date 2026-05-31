import js from '@eslint/js';
import pluginVue from 'eslint-plugin-vue';
import skipFormatting from 'eslint-config-prettier';
import globals from 'globals';

export default [
    {
        name: 'app/files-to-lint',
        files: ['**/*.{js,mjs,cjs,vue}'],
    },

    {
        name: 'app/files-to-ignore',
        ignores: [
            '**/dist/**',
            '**/dev-dist/**',
            '**/vendor/**',
            '**/public/**',
            '**/storage/**',
            '**/bootstrap/cache/**',
            'node_modules/**',
        ],
    },

    js.configs.recommended,
    ...pluginVue.configs['flat/recommended'],
    skipFormatting,

    {
        languageOptions: {
            ecmaVersion: 'latest',
            sourceType: 'module',
            globals: {
                ...globals.browser,
                ...globals.node,
                route: 'readonly',
            },
        },
        rules: {
            'vue/multi-word-component-names': 'off',
            'no-unused-vars': 'warn',
            'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
            'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
            'vue/no-v-html': 'off',
            'vue/require-default-prop': 'off',
            'vue/html-self-closing': [
                'warn',
                {
                    html: {
                        void: 'always',
                        normal: 'never',
                        component: 'always',
                    },
                    svg: 'always',
                    math: 'always',
                },
            ],
        },
    },
];
