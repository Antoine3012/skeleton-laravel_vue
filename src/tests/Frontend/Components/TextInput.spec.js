import { mount } from '@vue/test-utils';
import { describe, it, expect } from 'vitest';
import TextInput from '../../../resources/js/Components/TextInput.vue';

describe('TextInput.vue', () => {
    it('renders an input element', () => {
        const wrapper = mount(TextInput, {
            props: {
                modelValue: 'hello',
                'onUpdate:modelValue': (e) => wrapper.setProps({ modelValue: e }),
            },
        });
        expect(wrapper.find('input').exists()).toBe(true);
    });

    it('displays the initial model value', () => {
        const wrapper = mount(TextInput, {
            props: {
                modelValue: 'testing value',
                'onUpdate:modelValue': () => {},
            },
        });
        expect(wrapper.find('input').element.value).toBe('testing value');
    });

    it('emits update:modelValue when text is typed', async () => {
        const wrapper = mount(TextInput, {
            props: {
                modelValue: '',
                'onUpdate:modelValue': (e) => wrapper.setProps({ modelValue: e }),
            },
        });
        const input = wrapper.find('input');
        await input.setValue('new text');
        expect(wrapper.emitted('update:modelValue')[0]).toEqual(['new text']);
    });
});
