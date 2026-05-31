import { mount } from '@vue/test-utils';
import { describe, it, expect } from 'vitest';
import PrimaryButton from '../../../resources/js/Components/PrimaryButton.vue';

describe('PrimaryButton.vue', () => {
    it('renders a button element', () => {
        const wrapper = mount(PrimaryButton);
        expect(wrapper.find('button').exists()).toBe(true);
    });

    it('renders slot content correctly', () => {
        const wrapper = mount(PrimaryButton, {
            slots: {
                default: 'Click Me!',
            },
        });
        expect(wrapper.text()).toBe('Click Me!');
    });
});
