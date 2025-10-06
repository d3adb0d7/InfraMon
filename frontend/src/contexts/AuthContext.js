import React, { createContext, useContext, useState, useEffect } from 'react';
import axios from 'axios';

const AuthContext = createContext();

export function useAuth() {
  return useContext(AuthContext);
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [loggingOut, setLoggingOut] = useState(false);
  const [tokenVerified, setTokenVerified] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('token');
    console.log('🔐 Token found in storage:', !!token);
    
    if (token) {
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      verifyToken();
    } else {
      console.log('🔐 No token, skipping verification');
      setLoading(false);
      setTokenVerified(true);
    }
  }, []);

  const verifyToken = async () => {
    try {
      console.log('Verifying token...');
      const response = await axios.get('http://localhost:3001/api/auth/verify');
      console.log('Token verified, user:', response.data.user);
      setUser(response.data.user);
    } catch (error) {
      console.log('Token verification failed:', error.response?.data || error.message);
      
      // Clear invalid token but don't cause redirect loop
      localStorage.removeItem('token');
      delete axios.defaults.headers.common['Authorization'];
      setUser(null);
    } finally {
      setLoading(false);
      setTokenVerified(true);
    }
  };

  const login = async (username, password) => {
    try {
      console.log('Attempting login with:', username);
      const response = await axios.post('http://localhost:3001/api/auth/login', {
        username,
        password
      });
      
      const { token, user } = response.data;
      console.log('Login successful, user:', user);
      localStorage.setItem('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      setUser(user);
      setTokenVerified(true);
      
      return { success: true };
    } catch (error) {
      console.log('Login failed:', error.response?.data || error.message);
      return { 
        success: false, 
        message: error.response?.data?.error || 'Login failed' 
      };
    }
  };

  const logout = () => {
    console.log('Logging out');
    setLoggingOut(true);
    
    // Add a small delay for smooth animation
    setTimeout(() => {
      localStorage.removeItem('token');
      delete axios.defaults.headers.common['Authorization'];
      setUser(null);
      setTokenVerified(true);
      setLoggingOut(false);
      
      // Use window.location.replace to prevent history issues
      window.location.replace('/login');
    }, 300);
  };

  const value = {
    user,
    login,
    logout,
    loading,
    loggingOut,
    tokenVerified
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}