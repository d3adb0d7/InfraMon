// frontend/src/components/Auth/Login.js
import React, { useState, useEffect } from 'react';
import { useAuth } from '../../contexts/AuthContext';
import { useNavigate, useLocation } from 'react-router-dom';
import { Eye, EyeOff, LogIn, Server, Shield, Monitor, CheckCircle, X } from 'lucide-react';

const Login = () => {
  const [username, setUsername] = useState('admin');
  const [password, setPassword] = useState('admin');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showLogoutSuccess, setShowLogoutSuccess] = useState(false);
  const { login, loggingOut } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const result = await login(username, password);
    
    if (result.success) {
      navigate('/');
    } else {
      setError(result.message);
    }
    
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-slate-900 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 relative">
      {/* Animated Background */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -inset-10 opacity-20">
          <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500 rounded-full mix-blend-multiply filter blur-xl animate-pulse-slow"></div>
          <div className="absolute top-1/3 right-1/4 w-64 h-64 bg-emerald-500 rounded-full mix-blend-multiply filter blur-xl animate-pulse-slow animation-delay-2000"></div>
          <div className="absolute bottom-1/4 left-1/3 w-64 h-64 bg-violet-500 rounded-full mix-blend-multiply filter blur-xl animate-pulse-slow animation-delay-4000"></div>
        </div>
      </div>

      <div className="max-w-md w-full space-y-8 relative z-10">
        {/* Header with new logo */}
        <div className="text-center">
          <div className="mx-auto h-28 w-28 bg-gradient-to-br from-white/25 to-white/10 backdrop-blur-lg rounded-3xl flex items-center justify-center mb-6 border border-white/30 shadow-2xl animate-float">
            <img 
              src="/logo-large.png" 
              alt="InfraMon" 
              className="h-16 w-16 object-contain"
            />
          </div>
          <h2 className="text-4xl font-bold text-white mb-3">
            InfraMon
          </h2>
          <p className="text-blue-200 text-lg">
            Infrastructure  • Monitor • Analyze
          </p>
        </div>
        
        {/* Login Card */}
        <div className="bg-white/10 backdrop-blur-sm rounded-2xl shadow-xl border border-white/20 p-8">
          <form className="space-y-6" onSubmit={handleSubmit}>
            {error && (
              <div className="bg-rose-500/20 border border-rose-500/30 text-rose-200 px-4 py-3 rounded-xl text-sm">
                <div className="flex items-center space-x-2">
                  <Shield className="h-4 w-4" />
                  <span>{error}</span>
                </div>
              </div>
            )}
            
            <div className="space-y-5">
              {/* Username Field */}
              <div>
                <label htmlFor="username" className="block text-sm font-medium text-blue-100 mb-3">
                  Username
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <Server className="h-5 w-5 text-blue-300" />
                  </div>
                  <input
                    id="username"
                    name="username"
                    type="text"
                    required
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    className="bg-white/5 border border-white/20 text-white placeholder-blue-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 pr-4 py-3.5 text-sm backdrop-blur-sm transition-all duration-200"
                    placeholder="Enter your username"
                  />
                </div>
              </div>
              
              {/* Password Field */}
              <div>
                <label htmlFor="password" className="block text-sm font-medium text-blue-100 mb-3">
                  Password
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <LogIn className="h-5 w-5 text-blue-300" />
                  </div>
                  <input
                    id="password"
                    name="password"
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="bg-white/5 border border-white/20 text-white placeholder-blue-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 pr-12 py-3.5 text-sm backdrop-blur-sm transition-all duration-200"
                    placeholder="Enter your password"
                  />
                  <button
                    type="button"
                    className="absolute inset-y-0 right-0 pr-3 flex items-center text-blue-300 hover:text-white transition-colors"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? (
                      <EyeOff className="h-5 w-5" />
                    ) : (
                      <Eye className="h-5 w-5" />
                    )}
                  </button>
                </div>
              </div>
            </div>

            {/* Login Button */}
            <button
              type="submit"
              disabled={loading}
              className="group relative w-full flex justify-center py-3.5 px-4 border border-transparent text-sm font-medium rounded-xl text-white bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 transform hover:scale-[1.02] shadow-lg"
            >
              {loading ? (
                <div className="flex items-center space-x-2">
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  <span>Signing in...</span>
                </div>
              ) : (
                <div className="flex items-center space-x-2">
                  <LogIn className="h-4 w-4" />
                  <span>Sign in to Dashboard</span>
                </div>
              )}
            </button>

            {/* Demo Credentials */}
            
          </form>
        </div>

        {/* Footer */}
        <div className="text-center">
          <p className="text-blue-300 text-sm">
            Enterprise-grade infrastructure monitoring & alerting
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;