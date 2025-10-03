// frontend/src/pages/Settings.js
import React, { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { authAPI } from '../services/api';
import { 
  User, 
  Mail, 
  Shield, 
  Key, 
  Save, 
  CheckCircle, 
  AlertCircle,
  Eye,
  EyeOff,
  Globe,
  Phone,
  User as UserIcon
} from 'lucide-react';

const Settings = () => {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState('profile');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ text: '', type: '' });
  const [showPassword, setShowPassword] = useState(false);
  const [showNewPassword, setShowNewPassword] = useState(false);

  const [profileData, setProfileData] = useState({
    username: '',
    email: '',
    phone: '',
    firstName: '',
    lastName: ''
  });

  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  });

  useEffect(() => {
    if (user) {
      loadUserProfile();
    }
  }, [user]);

  const loadUserProfile = async () => {
    try {
      const response = await authAPI.getProfile();
      const userData = response.data;
      setProfileData({
        username: userData.username || '',
        email: userData.email || '',
        phone: userData.phone || '',
        firstName: userData.firstName || '',
        lastName: userData.lastName || ''
      });
    } catch (error) {
      console.error('Error loading profile:', error);
      showMessage('Error loading profile data', 'error');
    }
  };

  const showMessage = (text, type) => {
    setMessage({ text, type });
    setTimeout(() => setMessage({ text: '', type: '' }), 5000);
  };

  const handleProfileUpdate = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await authAPI.updateProfile(profileData);
      showMessage('Profile updated successfully!', 'success');
      
      // Update the user context if needed
      setTimeout(() => {
        window.location.reload(); // Simple way to refresh user data
      }, 1000);
    } catch (error) {
      console.error('Error updating profile:', error);
      showMessage(error.response?.data?.error || 'Failed to update profile', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordChange = async (e) => {
    e.preventDefault();
    setLoading(true);

    if (passwordData.newPassword !== passwordData.confirmPassword) {
      showMessage('New passwords do not match', 'error');
      setLoading(false);
      return;
    }

    if (passwordData.newPassword.length < 6) {
      showMessage('New password must be at least 6 characters', 'error');
      setLoading(false);
      return;
    }

    try {
      await authAPI.changePassword({
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword
      });
      
      showMessage('Password changed successfully!', 'success');
      setPasswordData({
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
      });
    } catch (error) {
      console.error('Error changing password:', error);
      showMessage(error.response?.data?.error || 'Failed to change password', 'error');
    } finally {
      setLoading(false);
    }
  };

  const tabs = [
    { id: 'profile', label: 'Profile Information', icon: User },
    { id: 'security', label: 'Change Password', icon: Shield }
  ];

  const renderProfileTab = () => (
    <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6">
      <h3 className="text-lg font-semibold text-slate-900 mb-6 flex items-center">
        <UserIcon className="h-5 w-5 mr-3 text-blue-600" />
        Personal Information
      </h3>

      <form onSubmit={handleProfileUpdate} className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              First Name
            </label>
            <input
              type="text"
              value={profileData.firstName}
              onChange={(e) => setProfileData({ ...profileData, firstName: e.target.value })}
              className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Enter your first name"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              Last Name
            </label>
            <input
              type="text"
              value={profileData.lastName}
              onChange={(e) => setProfileData({ ...profileData, lastName: e.target.value })}
              className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Enter your last name"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 mb-3 flex items-center">
            <User className="h-4 w-4 mr-2 text-slate-500" />
            Username *
          </label>
          <input
            type="text"
            required
            value={profileData.username}
            onChange={(e) => setProfileData({ ...profileData, username: e.target.value })}
            className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="Enter your username"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 mb-3 flex items-center">
            <Mail className="h-4 w-4 mr-2 text-slate-500" />
            Email Address *
          </label>
          <input
            type="email"
            required
            value={profileData.email}
            onChange={(e) => setProfileData({ ...profileData, email: e.target.value })}
            className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="your@email.com"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 mb-3 flex items-center">
            <Phone className="h-4 w-4 mr-2 text-slate-500" />
            Phone Number
          </label>
          <input
            type="tel"
            value={profileData.phone}
            onChange={(e) => setProfileData({ ...profileData, phone: e.target.value })}
            className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="+1 (555) 123-4567"
          />
        </div>

        <div className="flex justify-end pt-4 border-t border-slate-200/60">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-6 py-2.5 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors flex items-center space-x-2"
          >
            <Save className="h-4 w-4" />
            <span>{loading ? 'Updating...' : 'Update Profile'}</span>
          </button>
        </div>
      </form>
    </div>
  );

  const renderSecurityTab = () => (
    <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6">
      <h3 className="text-lg font-semibold text-slate-900 mb-6 flex items-center">
        <Shield className="h-5 w-5 mr-3 text-blue-600" />
        Change Password
      </h3>

      <form onSubmit={handlePasswordChange} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-3">
            Current Password *
          </label>
          <div className="relative">
            <input
              type={showPassword ? 'text' : 'password'}
              required
              value={passwordData.currentPassword}
              onChange={(e) => setPasswordData({ ...passwordData, currentPassword: e.target.value })}
              className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 pr-10"
              placeholder="Enter current password"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3 top-1/2 transform -translate-y-1/2 text-slate-400 hover:text-slate-600"
            >
              {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              New Password *
            </label>
            <div className="relative">
              <input
                type={showNewPassword ? 'text' : 'password'}
                required
                value={passwordData.newPassword}
                onChange={(e) => setPasswordData({ ...passwordData, newPassword: e.target.value })}
                className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 pr-10"
                placeholder="Enter new password"
              />
              <button
                type="button"
                onClick={() => setShowNewPassword(!showNewPassword)}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-slate-400 hover:text-slate-600"
              >
                {showNewPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
              </button>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              Confirm New Password *
            </label>
            <input
              type={showNewPassword ? 'text' : 'password'}
              required
              value={passwordData.confirmPassword}
              onChange={(e) => setPasswordData({ ...passwordData, confirmPassword: e.target.value })}
              className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Confirm new password"
            />
          </div>
        </div>

        <div className="bg-slate-50 rounded-lg p-4 border border-slate-200">
          <h4 className="text-sm font-medium text-slate-900 mb-2">Password Requirements</h4>
          <ul className="text-xs text-slate-600 space-y-1">
            <li>• At least 6 characters long</li>
            <li>• Should include letters and numbers</li>
            <li>• Avoid common words or patterns</li>
          </ul>
        </div>

        <div className="flex justify-end pt-4 border-t border-slate-200/60">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-6 py-2.5 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors flex items-center space-x-2"
          >
            <Key className="h-4 w-4" />
            <span>{loading ? 'Changing...' : 'Change Password'}</span>
          </button>
        </div>
      </form>
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header */}
        <div className="mb-8 text-center">
          <h1 className="text-4xl font-bold text-slate-900 mb-3">Profile Settings</h1>
          <p className="text-lg text-slate-600">Manage your personal information and account security</p>
        </div>

        {/* Message Display */}
        {message.text && (
          <div className={`mb-6 p-4 rounded-2xl border ${
            message.type === 'error' 
              ? 'bg-rose-50 border-rose-200 text-rose-700' 
              : 'bg-emerald-50 border-emerald-200 text-emerald-700'
          }`}>
            <div className="flex items-center">
              {message.type === 'error' ? (
                <AlertCircle className="h-5 w-5 mr-3" />
              ) : (
                <CheckCircle className="h-5 w-5 mr-3" />
              )}
              <span>{message.text}</span>
            </div>
          </div>
        )}

        {/* Tabs */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden mb-6">
          <div className="border-b border-slate-200/60">
            <nav className="flex space-x-8 px-6">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`py-4 px-1 border-b-2 font-medium text-sm flex items-center space-x-2 transition-colors ${
                      activeTab === tab.id
                        ? 'border-blue-500 text-blue-600'
                        : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{tab.label}</span>
                  </button>
                );
              })}
            </nav>
          </div>
        </div>

        {/* Tab Content */}
        <div>
          {activeTab === 'profile' && renderProfileTab()}
          {activeTab === 'security' && renderSecurityTab()}
        </div>

        {/* Account Information Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6 mt-6">
          <h3 className="text-lg font-semibold text-slate-900 mb-4 flex items-center">
            <Globe className="h-5 w-5 mr-3 text-blue-600" />
            Account Information
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div>
              <span className="text-slate-500">User ID:</span>
              <p className="text-slate-900 font-medium">{user?.id}</p>
            </div>
            <div>
              <span className="text-slate-500">Role:</span>
              <p className="text-slate-900 font-medium capitalize">{user?.role}</p>
            </div>
            <div>
              <span className="text-slate-500">Member Since:</span>
              <p className="text-slate-900 font-medium">
                {user?.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'N/A'}
              </p>
            </div>
            <div>
              <span className="text-slate-500">Last Login:</span>
              <p className="text-slate-900 font-medium">
                {user?.lastLogin ? new Date(user.lastLogin).toLocaleString() : 'N/A'}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;