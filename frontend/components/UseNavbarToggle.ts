'use client';
import { useEffect } from 'react';

interface NavbarElement extends HTMLElement {}

export const useNavbarToggle = () => {
  useEffect(() => {
    const overlay = document.querySelector('[data-overlay]') as NavbarElement | null;
    const navbar = document.querySelector('[data-navbar]') as NavbarElement | null;
    const menuCloseBtn = document.querySelector('[data-nav-close-btn]') as NavbarElement | null;
    const menuOpenBtn = document.querySelector('[data-nav-open-btn]') as NavbarElement | null;
    const header = document.querySelector('[data-header]') as NavbarElement | null;
    const backTopBtn = document.querySelector('[data-back-top-btn]') as NavbarElement | null;

    const toggleActive = () => {
      navbar?.classList.toggle('active');
      overlay?.classList.toggle('active');
    };

    const elemArr: (NavbarElement | null)[] = [overlay, menuCloseBtn, menuOpenBtn];

    elemArr.forEach(elem => {
      elem?.addEventListener('click', toggleActive);
    });

    const handleScroll = () => {
      if (window.scrollY >= 100) {
        header?.classList.add('active');
        backTopBtn?.classList.add('active');
      } else {
        header?.classList.remove('active');
        backTopBtn?.classList.remove('active');
      }
    };

    window.addEventListener('scroll', handleScroll);

    // Cleanup event listeners on unmount
    return () => {
      elemArr.forEach(elem => {
        elem?.removeEventListener('click', toggleActive);
      });
      window.removeEventListener('scroll', handleScroll);
    };
  }, []);
};
