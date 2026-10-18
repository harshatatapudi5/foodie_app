/**
 * ===================================================
 * FOODIE - LOGIN VALIDATION & INTERACTION (js/login.js)
 * Clean, accessible client-side validation
 * Ready for future Java Servlet / JDBC integration
 * ===================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    // Form and input elements
    const loginForm = document.getElementById('loginForm');
    const loginIdentifier = document.getElementById('loginIdentifier');
    const loginPassword = document.getElementById('loginPassword');
    const togglePasswordBtn = document.getElementById('toggleLoginPassword');
    const googleBtn = document.getElementById('googleSignInBtn');
    const toast = document.getElementById('toastNotification');

    // Error message elements
    const identifierError = document.getElementById('loginIdentifierError');
    const passwordError = document.getElementById('loginPasswordError');

    // ----------------------------------------------------
    // Utility Functions
    // ----------------------------------------------------
    function showError(input, errorElement, message) {
        input.classList.add('has-error');
        input.setAttribute('aria-invalid', 'true');
        errorElement.textContent = message;
        errorElement.classList.add('visible');
    }

    function clearError(input, errorElement) {
        input.classList.remove('has-error');
        input.removeAttribute('aria-invalid');
        errorElement.textContent = '';
        errorElement.classList.remove('visible');
    }

    function showToast(message, isError = false) {
        if (!toast) return;
        toast.textContent = message;
        toast.className = 'toast-notification' + (isError ? ' error' : '');
        toast.style.display = 'block';

        setTimeout(() => {
            toast.style.display = 'none';
        }, 3500);
    }

    // ----------------------------------------------------
    // Validation Rules
    // ----------------------------------------------------
    function validateIdentifier() {
        const value = loginIdentifier.value.trim();

        if (!value) {
            showError(loginIdentifier, identifierError, 'Please enter your email or phone number.');
            return false;
        }

        // Check if user entered an email
        if (value.includes('@')) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(value)) {
                showError(loginIdentifier, identifierError, 'Please enter a valid email address (e.g. name@example.com).');
                return false;
            }
        } else {
            // Check if user entered a phone number
            // Cleans spaces, hyphens, and optional +91 or leading 0
            const cleanedPhone = value.replace(/[\s\-()]/g, '').replace(/^(\+91|0)/, '');
            const indianPhoneRegex = /^[6-9]\d{9}$/;

            if (!indianPhoneRegex.test(cleanedPhone)) {
                showError(loginIdentifier, identifierError, 'Please enter a valid 10-digit Indian phone number (starting with 6-9).');
                return false;
            }
        }

        clearError(loginIdentifier, identifierError);
        return true;
    }

    function validatePassword() {
        const value = loginPassword.value;

        if (!value || value.trim() === '') {
            showError(loginPassword, passwordError, 'Password is required.');
            return false;
        }

        clearError(loginPassword, passwordError);
        return true;
    }

    // ----------------------------------------------------
    // Live Validation Events (Clear on typing/blur)
    // ----------------------------------------------------
    loginIdentifier.addEventListener('input', () => {
        if (loginIdentifier.classList.contains('has-error')) {
            validateIdentifier();
        }
    });

    loginIdentifier.addEventListener('blur', () => {
        if (loginIdentifier.value.trim() !== '') {
            validateIdentifier();
        }
    });

    loginPassword.addEventListener('input', () => {
        if (loginPassword.classList.contains('has-error')) {
            validatePassword();
        }
    });

    // ----------------------------------------------------
    // Password Visibility Toggle (👁)
    // ----------------------------------------------------
    if (togglePasswordBtn) {
        togglePasswordBtn.addEventListener('click', () => {
            const currentType = loginPassword.getAttribute('type');
            if (currentType === 'password') {
                loginPassword.setAttribute('type', 'text');
                togglePasswordBtn.textContent = '🙈';
                togglePasswordBtn.setAttribute('aria-label', 'Hide password');
            } else {
                loginPassword.setAttribute('type', 'password');
                togglePasswordBtn.textContent = '👁';
                togglePasswordBtn.setAttribute('aria-label', 'Show password');
            }
        });
    }

    // ----------------------------------------------------
    // Google Button (UI-Only Mock)
    // ----------------------------------------------------
    if (googleBtn) {
        googleBtn.addEventListener('click', () => {
            showToast('Google Sign-In is a UI demo only. Use regular login above.', true);
        });
    }

    // ----------------------------------------------------
    // Form Submission Handling
    // ----------------------------------------------------
    loginForm.addEventListener('submit', (event) => {
        const isIdentifierValid = validateIdentifier();
        const isPasswordValid = validatePassword();

        if (!isIdentifierValid || !isPasswordValid) {
            // Validation failed: Prevent submission and focus first invalid input
            event.preventDefault();
            if (!isIdentifierValid) {
                loginIdentifier.focus();
            } else {
                loginPassword.focus();
            }
            return;
        }

        /* =========================================================================
         * BACKEND INTEGRATION NOTE (Java Servlet):
         * -------------------------------------------------------------------------
         * Currently, event.preventDefault() stops the mock submission and shows
         * a success toast.
         *
         * When ready to connect to your Java Servlet backend:
         * 1. Remove event.preventDefault() below.
         * 2. The form action="LoginServlet" method="POST" will automatically
         *    submit to your LoginServlet.
         * 3. In LoginServlet.java (doPost):
         *    String identifier = request.getParameter("loginIdentifier");
         *    String password   = request.getParameter("loginPassword");
         * ========================================================================= */
        event.preventDefault(); // Remove this line when connecting to real Servlet!

        showToast('Login successful! Redirecting...', false);

        // Demo feedback: reset inputs after small delay
        setTimeout(() => {
            console.log('Login credentials validated successfully:');
            console.log('Identifier:', loginIdentifier.value.trim());
        }, 500);
    });
});

