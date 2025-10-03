// frontend/src/components/Alerts/AlertSettings.js
import React, { useState, useEffect } from 'react';
import { Mail, MessageSquare, Bell, Save, CheckCircle, AlertTriangle, Moon, Sun, Loader } from 'lucide-react';
import { alertsAPI } from '../../services/api';

const AlertSettings = () => {
  const [settings, setSettings] = useState({
    email: '',
    telegramChatId: '',
    preferences: {
      email: true,
      telegram: false,
      minUptime: 99.5,
      notifyOnUp: true,
      notifyOnDown: true,
      alertCooldown: 30,
      quietHours: {
        enabled: false,
        start: '22:00',
        end: '06:00'
      }
    }
  });
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ text: '', type: '' });
  const [testing, setTesting] = useState({ email: false, telegram: false });
  const [initialLoad, setInitialLoad] = useState(true);

  useEffect(() => {
    loadSettings();
  }, []);

  const loadSettings = async () => {
    try {
      console.log('Loading alert settings...');
      const response = await alertsAPI.getSettings();
      const data = response.data;
      console.log('Alert settings loaded:', data);
      
      // Merge with defaults to ensure all fields exist
      setSettings(prev => ({
        email: data.email || '',
        telegramChatId: data.telegramChatId || '',
        preferences: {
          ...prev.preferences,
          ...data.preferences,
          quietHours: {
            ...prev.preferences.quietHours,
            ...(data.preferences?.quietHours || {})
          }
        }
      }));
    } catch (error) {
      console.error('Error loading alert settings:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to load alert settings';
      showMessage(errorMessage, 'error');
    } finally {
      setInitialLoad(false);
    }
  };

  const showMessage = (text, type) => {
    setMessage({ text, type });
    setTimeout(() => setMessage({ text: '', type: '' }), 5000);
  };

  const handleSaveSettings = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      console.log('Saving alert settings:', settings);
      
      // Validate required fields
      if (settings.preferences.email && (!settings.email || !settings.email.includes('@'))) {
        throw new Error('Please enter a valid email address to enable email notifications');
      }
      
      if (settings.preferences.telegram && (!settings.telegramChatId || settings.telegramChatId.trim() === '')) {
        throw new Error('Please enter a Telegram Chat ID to enable Telegram notifications');
      }

      const response = await alertsAPI.updateSettings(settings);
      console.log('Save response:', response.data);
      
      showMessage('Alert settings saved successfully!', 'success');
      
      // Reload settings to get the latest from server
      setTimeout(() => {
        loadSettings();
      }, 1000);
      
    } catch (error) {
      console.error('Error saving alert settings:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to save settings';
      showMessage(errorMessage, 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleTestAlert = async (type) => {
    setTesting(prev => ({ ...prev, [type]: true }));
    
    try {
      console.log(`Testing ${type} alert...`);
      
      // Validate before testing
      if (type === 'email' && (!settings.email || !settings.email.includes('@'))) {
        throw new Error('Please configure a valid email address first');
      }
      
      if (type === 'telegram' && (!settings.telegramChatId || settings.telegramChatId.trim() === '')) {
        throw new Error('Please configure a Telegram Chat ID first');
      }

      const response = await alertsAPI.testAlert({ type });
      console.log('Test alert response:', response.data);
      
      showMessage(`${type.charAt(0).toUpperCase() + type.slice(1)} test alert sent successfully! Check your ${type} to confirm delivery.`, 'success');
    } catch (error) {
      console.error(`Error testing ${type} alert:`, error);
      const errorMessage = error.response?.data?.error || error.message || `Failed to send ${type} test alert`;
      showMessage(errorMessage, 'error');
    } finally {
      setTesting(prev => ({ ...prev, [type]: false }));
    }
  };

  const updatePreference = (key, value) => {
    setSettings(prev => ({
      ...prev,
      preferences: {
        ...prev.preferences,
        [key]: value
      }
    }));
  };

  const updateQuietHours = (key, value) => {
    setSettings(prev => ({
      ...prev,
      preferences: {
        ...prev.preferences,
        quietHours: {
          ...prev.preferences.quietHours,
          [key]: value
        }
      }
    }));
  };

  const isEmailConfigured = settings.email && settings.email.includes('@');
  const isTelegramConfigured = settings.telegramChatId && settings.telegramChatId.trim().length > 0;

  if (initialLoad) {
    return (
      <div className="min-h-96 flex items-center justify-center">
        <div className="text-center">
          <Loader className="h-8 w-8 animate-spin text-blue-600 mx-auto mb-4" />
          <p className="text-slate-600">Loading alert settings...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Message Display */}
      {message.text && (
        <div className={`p-4 rounded-2xl border ${
          message.type === 'error' 
            ? 'bg-rose-50 border-rose-200 text-rose-700' 
            : 'bg-emerald-50 border-emerald-200 text-emerald-700'
        }`}>
          <div className="flex items-center">
            {message.type === 'error' ? (
              <AlertTriangle className="h-5 w-5 mr-3 flex-shrink-0" />
            ) : (
              <CheckCircle className="h-5 w-5 mr-3 flex-shrink-0" />
            )}
            <span className="font-medium">{message.text}</span>
          </div>
        </div>
      )}

      <form onSubmit={handleSaveSettings}>
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Notification Channels */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
            <h3 className="text-lg font-semibold text-slate-900 mb-6 flex items-center">
              <Bell className="h-5 w-5 mr-3 text-blue-600" />
              Notification Channels
            </h3>

            <div className="space-y-4">
              {/* Email Settings */}
              <div className={`p-4 rounded-xl border transition-colors ${
                settings.preferences.email 
                  ? 'bg-blue-50 border-blue-200' 
                  : 'bg-slate-50 border-slate-200'
              }`}>
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center space-x-3">
                    <Mail className={`h-5 w-5 ${
                      settings.preferences.email ? 'text-blue-600' : 'text-slate-400'
                    }`} />
                    <div>
                      <div className={`font-medium ${
                        settings.preferences.email ? 'text-blue-900' : 'text-slate-700'
                      }`}>
                        Email Notifications
                      </div>
                      <div className="text-sm text-slate-600">Receive alerts via email</div>
                    </div>
                  </div>
                  <div className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={settings.preferences.email}
                      onChange={(e) => updatePreference('email', e.target.checked)}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                    />
                    <button
                      type="button"
                      onClick={() => handleTestAlert('email')}
                      disabled={testing.email || !settings.preferences.email || !isEmailConfigured}
                      className="bg-blue-600 text-white px-3 py-1.5 rounded-lg text-sm font-medium hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center space-x-2"
                    >
                      {testing.email && <Loader className="h-3 w-3 animate-spin" />}
                      <span>{testing.email ? 'Testing...' : 'Test'}</span>
                    </button>
                  </div>
                </div>
                {!isEmailConfigured && settings.preferences.email && (
                  <div className="text-sm text-amber-600 bg-amber-50 px-3 py-2 rounded-lg border border-amber-200">
                    ⚠️ Please configure your email address below to enable email notifications
                  </div>
                )}
              </div>

              {/* Telegram Settings */}
              <div className={`p-4 rounded-xl border transition-colors ${
                settings.preferences.telegram 
                  ? 'bg-emerald-50 border-emerald-200' 
                  : 'bg-slate-50 border-slate-200'
              }`}>
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center space-x-3">
                    <MessageSquare className={`h-5 w-5 ${
                      settings.preferences.telegram ? 'text-emerald-600' : 'text-slate-400'
                    }`} />
                    <div>
                      <div className={`font-medium ${
                        settings.preferences.telegram ? 'text-emerald-900' : 'text-slate-700'
                      }`}>
                        Telegram Notifications
                      </div>
                      <div className="text-sm text-slate-600">Receive alerts via Telegram</div>
                    </div>
                  </div>
                  <div className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={settings.preferences.telegram}
                      onChange={(e) => updatePreference('telegram', e.target.checked)}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                    />
                    <button
                      type="button"
                      onClick={() => handleTestAlert('telegram')}
                      disabled={testing.telegram || !settings.preferences.telegram || !isTelegramConfigured}
                      className="bg-emerald-600 text-white px-3 py-1.5 rounded-lg text-sm font-medium hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center space-x-2"
                    >
                      {testing.telegram && <Loader className="h-3 w-3 animate-spin" />}
                      <span>{testing.telegram ? 'Testing...' : 'Test'}</span>
                    </button>
                  </div>
                </div>
                {!isTelegramConfigured && settings.preferences.telegram && (
                  <div className="text-sm text-amber-600 bg-amber-50 px-3 py-2 rounded-lg border border-amber-200">
                    ⚠️ Please configure your Telegram Chat ID below to enable Telegram notifications
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Contact Information */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
            <h3 className="text-lg font-semibold text-slate-900 mb-6">Contact Information</h3>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  Email Address
                </label>
                <input
                  type="email"
                  value={settings.email}
                  onChange={(e) => setSettings(prev => ({ ...prev, email: e.target.value }))}
                  className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="your@email.com"
                />
                <p className="text-xs text-slate-500 mt-1">
                  Required for email notifications
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  Telegram Chat ID
                </label>
                <input
                  type="text"
                  value={settings.telegramChatId}
                  onChange={(e) => setSettings(prev => ({ ...prev, telegramChatId: e.target.value }))}
                  className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="123456789"
                />
                <p className="text-xs text-slate-500 mt-1">
                  Your Telegram Chat ID where alerts will be sent
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Alert Preferences */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60 mt-6">
          <h3 className="text-lg font-semibold text-slate-900 mb-6">Alert Preferences</h3>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="space-y-6">
              <div className="flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-200">
                <div>
                  <div className="font-medium text-slate-900 text-sm">Notify on Downtime</div>
                  <div className="text-xs text-slate-600">Send alerts when websites go down</div>
                </div>
                <input
                  type="checkbox"
                  checked={settings.preferences.notifyOnDown}
                  onChange={(e) => updatePreference('notifyOnDown', e.target.checked)}
                  className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                />
              </div>

              <div className="flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-200">
                <div>
                  <div className="font-medium text-slate-900 text-sm">Notify on Recovery</div>
                  <div className="text-xs text-slate-600">Send alerts when websites recover</div>
                </div>
                <input
                  type="checkbox"
                  checked={settings.preferences.notifyOnUp}
                  onChange={(e) => updatePreference('notifyOnUp', e.target.checked)}
                  className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                />
              </div>
            </div>

            <div className="space-y-6">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-3">
                  Minimum Uptime Threshold (%)
                </label>
                <div className="relative">
                  <input
                    type="range"
                    min="80"
                    max="100"
                    step="0.1"
                    value={settings.preferences.minUptime}
                    onChange={(e) => updatePreference('minUptime', parseFloat(e.target.value))}
                    className="w-full h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-blue-600 [&::-webkit-slider-thumb]:border-2 [&::-webkit-slider-thumb]:border-white [&::-webkit-slider-thumb]:shadow-lg"
                  />
                  <div className="flex justify-between text-xs text-slate-500 mt-1">
                    <span>80%</span>
                    <span className="font-medium text-blue-600">{settings.preferences.minUptime}%</span>
                    <span>100%</span>
                  </div>
                </div>
                <p className="text-xs text-slate-500 mt-2">
                  Receive alerts if uptime drops below this threshold
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-3">
                  Alert Cooldown
                </label>
                <select
                  value={settings.preferences.alertCooldown}
                  onChange={(e) => updatePreference('alertCooldown', parseInt(e.target.value))}
                  className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="5">5 minutes</option>
                  <option value="15">15 minutes</option>
                  <option value="30">30 minutes</option>
                  <option value="60">1 hour</option>
                  <option value="120">2 hours</option>
                  <option value="240">4 hours</option>
                </select>
                <p className="text-xs text-slate-500 mt-2">
                  Minimum time between consecutive alerts for the same issue
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Quiet Hours */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60 mt-6">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center">
              <Moon className="h-5 w-5 mr-3 text-violet-600" />
              <div>
                <h3 className="text-lg font-semibold text-slate-900">Quiet Hours</h3>
                <p className="text-sm text-slate-600">Suppress alerts during specified hours</p>
              </div>
            </div>
            <label className="relative inline-flex items-center cursor-pointer">
              <input
                type="checkbox"
                checked={settings.preferences.quietHours.enabled}
                onChange={(e) => updateQuietHours('enabled', e.target.checked)}
                className="sr-only peer"
              />
              <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-violet-600"></div>
            </label>
          </div>

          {settings.preferences.quietHours.enabled && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-4 bg-violet-50 rounded-xl border border-violet-200">
              <div>
                <label className="block text-sm font-medium text-violet-700 mb-3">
                  <Moon className="h-4 w-4 inline mr-2" />
                  Quiet Hours Start
                </label>
                <input
                  type="time"
                  value={settings.preferences.quietHours.start}
                  onChange={(e) => updateQuietHours('start', e.target.value)}
                  className="w-full px-3 py-2.5 border border-violet-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 focus:border-violet-500 bg-white"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-violet-700 mb-3">
                  <Sun className="h-4 w-4 inline mr-2" />
                  Quiet Hours End
                </label>
                <input
                  type="time"
                  value={settings.preferences.quietHours.end}
                  onChange={(e) => updateQuietHours('end', e.target.value)}
                  className="w-full px-3 py-2.5 border border-violet-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 focus:border-violet-500 bg-white"
                />
              </div>
              <div className="md:col-span-2">
                <div className="text-sm text-violet-700 bg-violet-100 px-3 py-2 rounded-lg border border-violet-200">
                  💤 Alerts will be suppressed between {settings.preferences.quietHours.start} and {settings.preferences.quietHours.end}
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Save Button */}
        <div className="flex justify-end mt-6 pt-6 border-t border-slate-200">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-8 py-3 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors flex items-center space-x-3 shadow-lg shadow-blue-600/25"
          >
            {loading && <Loader className="h-5 w-5 animate-spin" />}
            <span className="text-lg">{loading ? 'Saving Settings...' : 'Save All Settings'}</span>
          </button>
        </div>
      </form>
    </div>
  );
};

export default AlertSettings;