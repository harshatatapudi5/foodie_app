/**
 * Foodie Website-Wide Animations & Scroll Reveals
 * High-performance, non-blocking IntersectionObserver transitions across all 8 pages.
 */
(function() {
    'use strict';

    function initWebsiteAnimations() {
        const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        // Auto-tag common sections and cards for reveal animation if not already tagged
        const targets = document.querySelectorAll(
            '.category-card, .res-card, .res-list-card, .food-card, .feature-card, .bill-card, .promo-banner, .order-history-card, .profile-stat-box, .delivery-options-grid, .pay-tab'
        );

        targets.forEach((el, index) => {
            if (!el.classList.contains('reveal-on-scroll')) {
                el.classList.add('reveal-on-scroll');
                // Apply a staggered delay pattern based on column index
                const delayIndex = (index % 4) + 1;
                el.classList.add('reveal-delay-' + delayIndex);
            }
        });

        // If reduced motion is preferred, reveal everything immediately
        if (prefersReducedMotion || !('IntersectionObserver' in window)) {
            document.querySelectorAll('.reveal-on-scroll').forEach(el => {
                el.classList.add('revealed');
            });
            return;
        }

        const observerOptions = {
            root: null,
            rootMargin: '0px 0px -40px 0px',
            threshold: 0.1
        };

        const revealObserver = new IntersectionObserver(function(entries, observer) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    // Stop observing once revealed to preserve performance
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.reveal-on-scroll').forEach(el => {
            revealObserver.observe(el);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initWebsiteAnimations);
    } else {
        initWebsiteAnimations();
    }
})();
