#!/bin/bash
set -e

echo "Setting up development environment for the portfolio website..."

# Check Node.js and npm versions
echo "Node.js version:"
node --version
echo "npm version:"
npm --version

# Create a project directory
echo "Creating project directory..."
mkdir -p portfolio
cd portfolio

# Initialize a new package.json
echo "Initializing package.json..."
cat > package.json << 'EOF'
{
  "name": "portfolio-website",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "jest"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@mdx-js/loader": "^3.0.0",
    "@mdx-js/react": "^3.0.0",
    "@next/mdx": "^14.0.0"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31",
    "tailwindcss": "^3.3.5",
    "eslint": "^8.53.0",
    "eslint-config-next": "^14.0.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@testing-library/react": "^14.1.0",
    "@testing-library/jest-dom": "^6.1.4"
  }
}
EOF

# Create a basic Next.js structure
echo "Creating basic Next.js structure..."

# Create pages directory and index.js
mkdir -p pages
cat > pages/index.js << 'EOF'
import React from 'react';

export default function Home() {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Welcome to My Portfolio</h1>
      <p className="mb-4">This is a modern, responsive portfolio website showcasing my professional work, blog articles, and personal information.</p>
    </div>
  );
}
EOF

# Create components directory and a sample component
mkdir -p components
cat > components/Header.js << 'EOF'
import React from 'react';

export default function Header() {
  return (
    <header className="bg-gray-800 text-white p-4">
      <div className="container mx-auto flex justify-between items-center">
        <h1 className="text-xl font-bold">My Portfolio</h1>
        <nav>
          <ul className="flex space-x-4">
            <li><a href="/" className="hover:text-gray-300">Home</a></li>
            <li><a href="/blog" className="hover:text-gray-300">Blog</a></li>
            <li><a href="/about" className="hover:text-gray-300">About</a></li>
            <li><a href="/projects" className="hover:text-gray-300">Projects</a></li>
            <li><a href="/contact" className="hover:text-gray-300">Contact</a></li>
          </ul>
        </nav>
      </div>
    </header>
  );
}
EOF

# Create styles directory and globals.css
mkdir -p styles
cat > styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

html,
body {
  padding: 0;
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen,
    Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue, sans-serif;
}

a {
  color: inherit;
  text-decoration: none;
}

* {
  box-sizing: border-box;
}
EOF

# Create _app.js
cat > pages/_app.js << 'EOF'
import '../styles/globals.css';
import Header from '../components/Header';

function MyApp({ Component, pageProps }) {
  return (
    <>
      <Header />
      <Component {...pageProps} />
    </>
  );
}

export default MyApp;
EOF

# Create tailwind.config.js
cat > tailwind.config.js << 'EOF'
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Create postcss.config.js
cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Create Jest configuration
cat > jest.config.js << 'EOF'
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files in your test environment
  dir: './',
});

// Add any custom config to be passed to Jest
const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
};

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
module.exports = createJestConfig(customJestConfig);
EOF

# Create Jest setup file
cat > jest.setup.js << 'EOF'
// Optional: configure or set up a testing framework before each test.
// If you delete this file, remove `setupFilesAfterEnv` from `jest.config.js`
import '@testing-library/jest-dom';
EOF

# Create test files
mkdir -p __tests__
cat > __tests__/index.test.js << 'EOF'
import { render, screen } from '@testing-library/react';
import Home from '../pages/index';

describe('Home page', () => {
  it('renders the heading', () => {
    render(<Home />);
    
    const heading = screen.getByRole('heading', { name: /welcome to my portfolio/i });
    
    expect(heading).toBeInTheDocument();
  });
});
EOF

cat > __tests__/Header.test.js << 'EOF'
import { render, screen } from '@testing-library/react';
import Header from '../components/Header';

describe('Header component', () => {
  it('renders the navigation links', () => {
    render(<Header />);
    
    expect(screen.getByText('Home')).toBeInTheDocument();
    expect(screen.getByText('Blog')).toBeInTheDocument();
    expect(screen.getByText('About')).toBeInTheDocument();
    expect(screen.getByText('Projects')).toBeInTheDocument();
    expect(screen.getByText('Contact')).toBeInTheDocument();
  });
});
EOF

# Install dependencies
echo "Installing dependencies..."
npm install

# Add environment variables to .bashrc
echo "Adding environment variables to .bashrc..."
echo 'export PATH="$PATH:$HOME/portfolio/node_modules/.bin"' >> ~/.bashrc
echo 'alias dev="cd ~/portfolio && npm run dev"' >> ~/.bashrc
echo 'alias test="cd ~/portfolio && npm test"' >> ~/.bashrc

echo "Setup completed successfully! Project created in ~/portfolio directory."