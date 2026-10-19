/**
 * Foodie Hero Image Carousel
 * Automatic crossfade, keyboard accessible, pauses on hover, respects reduced motion
 */
(function() {
    'use strict';

    function initHeroCarousel() {
        const carousel = document.getElementById('heroFoodCarousel');
        if (!carousel) return;

        const slides = carousel.querySelectorAll('.hero-carousel-slide');
        const dots = carousel.querySelectorAll('.hero-carousel-dot');
        const prevBtn = carousel.querySelector('.hero-carousel-arrow.prev');
        const nextBtn = carousel.querySelector('.hero-carousel-arrow.next');

        if (!slides.length) return;

        let currentIndex = 0;
        let timer = null;
        const intervalTime = 4500; // 4.5 seconds
        const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        function showSlide(index) {
            if (index < 0) {
                index = slides.length - 1;
            } else if (index >= slides.length) {
                index = 0;
            }

            slides.forEach((slide, i) => {
                const isActive = (i === index);
                slide.classList.toggle('active', isActive);
                slide.setAttribute('aria-hidden', !isActive);
            });

            dots.forEach((dot, i) => {
                const isActive = (i === index);
                dot.classList.toggle('active', isActive);
                dot.setAttribute('aria-selected', isActive);
            });

            currentIndex = index;

            // Preload next image if available
            const nextIdx = (currentIndex + 1) % slides.length;
            const nextImg = slides[nextIdx].querySelector('img');
            if (nextImg && !nextImg.complete) {
                const preloader = new Image();
                preloader.src = nextImg.src;
            }
        }

        function nextSlide() {
            showSlide(currentIndex + 1);
        }

        function prevSlide() {
            showSlide(currentIndex - 1);
        }

        function startAutoPlay() {
            if (prefersReducedMotion) return;
            stopAutoPlay();
            timer = setInterval(nextSlide, intervalTime);
        }

        function stopAutoPlay() {
            if (timer) {
                clearInterval(timer);
                timer = null;
            }
        }

        // Event listeners for controls
        if (nextBtn) {
            nextBtn.addEventListener('click', function(e) {
                e.preventDefault();
                nextSlide();
                startAutoPlay();
            });
        }

        if (prevBtn) {
            prevBtn.addEventListener('click', function(e) {
                e.preventDefault();
                prevSlide();
                startAutoPlay();
            });
        }

        dots.forEach((dot, idx) => {
            dot.addEventListener('click', function(e) {
                e.preventDefault();
                showSlide(idx);
                startAutoPlay();
            });
        });

        // Pause on mouseenter, resume on mouseleave
        carousel.addEventListener('mouseenter', stopAutoPlay);
        carousel.addEventListener('mouseleave', startAutoPlay);
        carousel.addEventListener('focusin', stopAutoPlay);
        carousel.addEventListener('focusout', startAutoPlay);

        // Keyboard arrow navigation
        carousel.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowRight') {
                e.preventDefault();
                nextSlide();
                startAutoPlay();
            } else if (e.key === 'ArrowLeft') {
                e.preventDefault();
                prevSlide();
                startAutoPlay();
            }
        });

        // Initialize first slide and start autoplay
        showSlide(0);
        startAutoPlay();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initHeroCarousel);
    } else {
        initHeroCarousel();
    }
})();

