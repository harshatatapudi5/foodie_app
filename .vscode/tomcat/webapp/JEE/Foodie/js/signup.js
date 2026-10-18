/**
 * ===================================================
 * FOODIE - SIGNUP VALIDATION & INTERACTION (js/signup.js)
 * Clean, accessible client-side validation
 * Ready for future Java Servlet / JDBC integration
 * ===================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    // Form and input elements
    const signupForm = document.getElementById('signupForm');
    const fullName = document.getElementById('fullName');
    const email = document.getElementById('email');
    const phone = document.getElementById('phone');
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    const terms = document.getElementById('terms');

    // Password toggle buttons
    const togglePasswordBtn = document.getElementById('togglePassword');
    const toggleConfirmPasswordBtn = document.getElementById('toggleConfirmPassword');

    // Extra UI elements
    const googleBtn = document.getElementById('googleSignUpBtn');
    const toast = document.getElementById('toastNotification');

    // Error message elements
    const fullNameError = document.getElementById('fullNameError');
    const emailError = document.getElementById('emailError');
    const phoneError = document.getElementById('phoneError');
    const passwordError = document.getElementById('passwordError');
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    const termsError = document.getElementById('termsError');

    // ----------------------------------------------------
    // Utility Functions
    // ----------------------------------------------------
    function showError(input, errorElement, message) {
        if (input && input.type !== 'checkbox') {
            input.classList.add('has-error');
            input.setAttribute('aria-invalid', 'true');
        }
        errorElement.textContent = message;
        errorElement.classList.add('visible');
    }

    function clearError(input, errorElement) {
        if (input && input.type !== 'checkbox') {
            input.classList.remove('has-error');
            input.removeAttribute('aria-invalid');
        }
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
    function validateFullName() {
        const val = fullName.value.trim();
        if (!val) {
            showError(fullName, fullNameError, 'Full Name is required.');
            return false;
        }
        if (val.length < 3) {
            showError(fullName, fullNameError, 'Full Name must be at least 3 characters.');
            return false;
        }
        clearError(fullName, fullNameError);
        return true;
    }

    function validateEmail() {
        const val = email.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!val) {
            showError(email, emailError, 'Email address is required.');
            return false;
        }
        if (!emailRegex.test(val)) {
            showError(email, emailError, 'Please enter a valid email format (e.g. name@domain.com).');
            return false;
        }
        clearError(email, emailError);
        return true;
    }

    function validatePhone() {
        const rawVal = phone.value.trim();
        // Indian phone numbers: 10 digits starting with 6, 7, 8, or 9
        const indianPhoneRegex = /^[6-9]\d{9}$/;

        if (!rawVal) {
            showError(phone, phoneError, 'Phone number is required.');
            return false;
        }

        // Clean user input in case they entered dashes or spaces
        const cleaned = rawVal.replace(/[\s\-()]/g, '');

        if (!indianPhoneRegex.test(cleaned)) {
            showError(phone, phoneError, 'Enter a valid 10-digit Indian mobile number (starts with 6-9).');
            return false;
        }
        clearError(phone, phoneError);
        return true;
    }

    function validatePassword() {
        const val = password.value;
        if (!val) {
            showError(password, passwordError, 'Password is required.');
            return false;
        }
        if (val.length < 8) {
            showError(password, passwordError, 'Password must be at least 8 characters long.');
            return false;
        }
        if (!/[A-Z]/.test(val)) {
            showError(password, passwordError, 'Password must contain at least one uppercase letter (A-Z).');
            return false;
        }
        if (!/[a-z]/.test(val)) {
            showError(password, passwordError, 'Password must contain at least one lowercase letter (a-z).');
            return false;
        }
        if (!/[0-9]/.test(val)) {
            showError(password, passwordError, 'Password must contain at least one number (0-9).');
            return false;
        }

        clearError(password, passwordError);

        // Re-validate confirm password if it already has content
        if (confirmPassword.value.length > 0) {
            validateConfirmPassword();
        }
        return true;
    }

    function validateConfirmPassword() {
        const val = confirmPassword.value;
        if (!val) {
            showError(confirmPassword, confirmPasswordError, 'Please confirm your password.');
            return false;
        }
        if (val !== password.value) {
            showError(confirmPassword, confirmPasswordError, 'Passwords do not match.');
            return false;
        }
        clearError(confirmPassword, confirmPasswordError);
        return true;
    }

    function validateTerms() {
        if (!terms.checked) {
            showError(terms, termsError, 'You must accept the Terms & Conditions before creating an account.');
            return false;
        }
        clearError(terms, termsError);
        return true;
    }

    // ----------------------------------------------------
    // Live Validation Events
    // ----------------------------------------------------
    fullName.addEventListener('input', () => {
        if (fullName.classList.contains('has-error')) validateFullName();
    });
    fullName.addEventListener('blur', () => {
        if (fullName.value.trim() !== '') validateFullName();
    });

    email.addEventListener('input', () => {
        if (email.classList.contains('has-error')) validateEmail();
    });
    email.addEventListener('blur', () => {
        if (email.value.trim() !== '') validateEmail();
    });

    phone.addEventListener('input', () => {
        // Enforce numeric only input for phone
        phone.value = phone.value.replace(/\D/g, '').slice(0, 10);
        if (phone.classList.contains('has-error')) validatePhone();
    });
    phone.addEventListener('blur', () => {
        if (phone.value.trim() !== '') validatePhone();
    });

    password.addEventListener('input', () => {
        if (password.classList.contains('has-error')) validatePassword();
    });

    confirmPassword.addEventListener('input', () => {
        if (confirmPassword.classList.contains('has-error')) validateConfirmPassword();
    });

    terms.addEventListener('change', () => {
        if (terms.checked) clearError(terms, termsError);
    });

    // ----------------------------------------------------
    // Password Visibility Toggles (👁)
    // ----------------------------------------------------
    function setupPasswordToggle(button, inputField) {
        if (!button || !inputField) return;

        button.addEventListener('click', () => {
            const currentType = inputField.getAttribute('type');
            if (currentType === 'password') {
                inputField.setAttribute('type', 'text');
                button.textContent = '🙈';
                button.setAttribute('aria-label', 'Hide password');
            } else {
                inputField.setAttribute('type', 'password');
                button.textContent = '👁';
                button.setAttribute('aria-label', 'Show password');
            }
        });
    }

    setupPasswordToggle(togglePasswordBtn, password);
    setupPasswordToggle(toggleConfirmPasswordBtn, confirmPassword);

    // ----------------------------------------------------
    // Google Button (UI-Only Mock)
    // ----------------------------------------------------
    if (googleBtn) {
        googleBtn.addEventListener('click', () => {
            showToast('Google Sign-Up is a UI demo only. Use regular form above.', true);
        });
    }

    // ----------------------------------------------------
    // Form Submission Handling
    // ----------------------------------------------------
    signupForm.addEventListener('submit', (event) => {
        const isNameValid = validateFullName();
        const isEmailValid = validateEmail();
        const isPhoneValid = validatePhone();
        const isPasswordValid = validatePassword();
        const isConfirmValid = validateConfirmPassword();
        const isTermsValid = validateTerms();

        const isFormValid = isNameValid && isEmailValid && isPhoneValid && 
                            isPasswordValid && isConfirmValid && isTermsValid;

        if (!isFormValid) {
            // Validation failed: prevent submit & focus first invalid input
            event.preventDefault();

            if (!isNameValid) fullName.focus();
            else if (!isEmailValid) email.focus();
            else if (!isPhoneValid) phone.focus();
            else if (!isPasswordValid) password.focus();
            else if (!isConfirmValid) confirmPassword.focus();
            else if (!isTermsValid) terms.focus();

            return;
        }

        /* =========================================================================
         * BACKEND INTEGRATION NOTE (Java Servlet):
         * -------------------------------------------------------------------------
         * Currently, event.preventDefault() stops form submit to demonstrate
         * client-side success feedback.
         *
         * When ready to connect to your Java Servlet backend:
         * 1. Remove event.preventDefault() below.
         * 2. The form action="SignupServlet" method="POST" will automatically
         *    submit all fields to your SignupServlet.
         * 3. In SignupServlet.java (doPost):
         *    String name     = request.getParameter("fullName");
         *    String email    = request.getParameter("email");
         *    String phone    = request.getParameter("phone");
         *    String password = request.getParameter("password");
         * ========================================================================= */
        event.preventDefault(); // Remove this line when connecting to real Servlet!

        showToast('Account created successfully! Redirecting to login...', false);

        // Demo redirect simulation to login.html after 1.5s
        setTimeout(() => {
            console.log('Account registered for:', fullName.value.trim(), email.value.trim());
        }, 1500);
    });
});

