import React, { useState, useEffect } from 'react';
import { X, Globe, Clock, Code, Server, Terminal, AlertCircle } from 'lucide-react';
import { websitesAPI } from '../../services/api';

const EditWebsiteModal = ({ isOpen, onClose, website, onWebsiteUpdated }) => {
  const [formData, setFormData] = useState({
    url: '',
    name: '',
    interval: 5,
    httpMethod: 'GET',
    expectedStatusCodes: [200],
    headers: [],
    customCurlCommand: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const statusCodeOptions = [200, 201, 202, 301, 302, 400, 401, 403, 404, 500];
  const httpMethods = ['GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST', 'CUSTOM_CURL'];

  useEffect(() => {
    if (website) {
      setFormData({
        url: website.url || '',
        name: website.name || '',
        interval: website.interval || 5,
        httpMethod: website.httpMethod || 'GET',
        expectedStatusCodes: website.expectedStatusCodes || [200],
        headers: website.headers || [],
        customCurlCommand: website.customCurlCommand || ''
      });
    }
  }, [website]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // For non-CUSTOM_CURL methods, URL is required
      if (formData.httpMethod !== 'CUSTOM_CURL' && 
          !formData.url.startsWith('http://') && 
          !formData.url.startsWith('https://')) {
        setError('URL must start with http:// or https://');
        setLoading(false);
        return;
      }

      // For CUSTOM_CURL method, command is required
      if (formData.httpMethod === 'CUSTOM_CURL' && !formData.customCurlCommand.trim()) {
        setError('Custom CURL command is required');
        setLoading(false);
        return;
      }

      // Basic security check for custom curl commands
      if (formData.httpMethod === 'CUSTOM_CURL') {
        const command = formData.customCurlCommand.trim();
        if (!command.toLowerCase().startsWith('curl')) {
          setError('Custom CURL command must start with "curl"');
          setLoading(false);
          return;
        }
        
        // Allow CURL command characters but block shell injection
        const dangerousPatterns = ['&', '|', '`', '$', '>', '<', '&&', '||'];
        
        // Check for dangerous patterns that could lead to command injection
        for (const pattern of dangerousPatterns) {
          if (command.includes(pattern)) {
            setError('Custom CURL command contains potentially dangerous characters');
            setLoading(false);
            return;
          }
        }

        // Smarter check for multiple commands
        let inQuotes = false;
        let quoteChar = null;
        let commandCount = 0;
        
        for (let i = 0; i < command.length; i++) {
          const char = command[i];
          
          // Track when we're inside quotes
          if ((char === '"' || char === "'") && (i === 0 || command[i-1] !== '\\')) {
            if (!inQuotes) {
              inQuotes = true;
              quoteChar = char;
            } else if (char === quoteChar) {
              inQuotes = false;
              quoteChar = null;
            }
          }
          
          // Count commands only when not inside quotes
          if (char === ';' && !inQuotes) {
            const beforeSemicolon = command.substring(0, i).trim();
            const afterSemicolon = command.substring(i + 1).trim();
            
            // Only count as separate command if there's content before and after
            if (beforeSemicolon.length > 0 && afterSemicolon.length > 0) {
              commandCount++;
            }
          }
        }
        
        if (commandCount > 0) {
          setError('Multiple commands not allowed. Please use a single CURL command.');
          setLoading(false);
          return;
        }
      }

      // Filter out empty headers
      const filteredHeaders = formData.headers.filter(header => 
        header.key && header.value && header.key.trim() && header.value.trim()
      );

      const payload = {
        ...formData,
        headers: filteredHeaders,
        // Clear customCurlCommand if not using CUSTOM_CURL method
        customCurlCommand: formData.httpMethod === 'CUSTOM_CURL' ? formData.customCurlCommand : null
      };

      const response = await websitesAPI.update(website.id, payload);
      onWebsiteUpdated(response.data);
      onClose();
    } catch (error) {
      setError(error.response?.data?.error || 'Failed to update website');
    } finally {
      setLoading(false);
    }
  };

  const handleStatusCodeChange = (code) => {
    setFormData(prev => {
      const newCodes = prev.expectedStatusCodes.includes(code)
        ? prev.expectedStatusCodes.filter(c => c !== code)
        : [...prev.expectedStatusCodes, code];
      
      return { ...prev, expectedStatusCodes: newCodes };
    });
  };

  // Example commands
  const curlExamples = [
    { 
      label: 'Simple GET (recommended)', 
      command: 'curl https://google.com' 
    },
    { 
      label: 'GET with status code', 
      command: 'curl -L -w "%{http_code}" https://google.com' 
    },
    { 
      label: 'GET with silent output', 
      command: 'curl -s -o /dev/null -L -w "%{http_code}" https://google.com' 
    }
  ];
  
  if (!isOpen || !website) return null;

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-fade-in">
      <div className="bg-white rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto animate-scale-in">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-slate-200/60">
          <div>
            <h2 className="text-xl font-semibold text-slate-900">Edit Website</h2>
            <p className="text-slate-600 text-sm mt-1">Update monitoring settings for {website.name || website.url}</p>
          </div>
          <button
            onClick={onClose}
            className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-xl transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-6">
          {error && (
            <div className="bg-rose-50 border border-rose-200 text-rose-700 px-4 py-3 rounded-xl flex items-center space-x-2">
              <AlertCircle className="h-4 w-4" />
              <span className="text-sm">{error}</span>
            </div>
          )}

          {/* Check Method */}
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              Check Method *
            </label>
            <div className="relative">
              <Code className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
              <select
                value={formData.httpMethod}
                onChange={(e) => setFormData({ ...formData, httpMethod: e.target.value })}
                className="w-full pl-10 pr-3 py-2.5 border border-slate-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              >
                {httpMethods.map(method => (
                  <option key={method} value={method}>
                    {method.startsWith('CURL_') 
                      ? `CURL ${method.replace('CURL_', '')}` 
                      : method === 'CUSTOM_CURL'
                      ? 'CUSTOM CURL COMMAND'
                      : method}
                  </option>
                ))}
              </select>
            </div>
            <p className="text-xs text-slate-500 mt-2">
              {formData.httpMethod === 'PING' 
                ? 'PING: Uses ICMP ping (works for websites that block HTTP requests)' 
                : formData.httpMethod.startsWith('CURL_')
                ? 'CURL: Uses curl command for advanced HTTP requests'
                : formData.httpMethod === 'CUSTOM_CURL'
                ? 'CUSTOM CURL: Paste any custom curl command for advanced testing'
                : 'HTTP: Uses standard HTTP requests with custom headers'}
            </p>
          </div>

          {/* URL Input (conditionally rendered) */}
          {formData.httpMethod !== 'CUSTOM_CURL' && (
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-3">
                Website URL *
              </label>
              <div className="relative">
                <Globe className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
                <input
                  type="url"
                  required={formData.httpMethod !== 'CUSTOM_CURL'}
                  placeholder="https://example.com"
                  value={formData.url}
                  onChange={(e) => setFormData({ ...formData, url: e.target.value })}
                  className="w-full pl-10 pr-3 py-2.5 border border-slate-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
                />
              </div>
            </div>
          )}

          {/* Custom CURL Command */}
          {formData.httpMethod === 'CUSTOM_CURL' && (
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-3">
                Custom CURL Command *
              </label>
              <div className="relative">
                <Terminal className="absolute left-3 top-3 h-5 w-5 text-slate-400" />
                <textarea
                  required
                  placeholder="curl https://google.com"
                  value={formData.customCurlCommand}
                  onChange={(e) => setFormData({ ...formData, customCurlCommand: e.target.value })}
                  rows={3}
                  className="w-full pl-10 pr-3 py-2.5 border border-slate-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm font-mono"
                />
              </div>
              <p className="text-xs text-slate-500 mt-2">
                Enter a simple curl command. For best results, use: <code className="bg-slate-100 px-1 rounded">curl https://google.com</code>
              </p>
              
              <div className="mt-3">
                <details className="text-xs">
                  <summary className="cursor-pointer text-blue-600 hover:text-blue-800 font-medium">
                    Show example commands
                  </summary>
                  <div className="mt-2 space-y-2">
                    {curlExamples.map((example, index) => (
                      <div key={index} className="bg-slate-50 p-3 rounded-lg border border-slate-200">
                        <div className="text-slate-700 font-medium">{example.label}:</div>
                        <code className="text-xs block mt-1 bg-slate-100 p-2 rounded font-mono">
                          {example.command}
                        </code>
                        <button
                          type="button"
                          onClick={() => setFormData(prev => ({ ...prev, customCurlCommand: example.command }))}
                          className="text-xs text-blue-600 hover:text-blue-800 mt-1 font-medium"
                        >
                          Use this command
                        </button>
                      </div>
                    ))}
                  </div>
                </details>
              </div>
            </div>
          )}

          {/* Display Name */}
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              Display Name (Optional)
            </label>
            <div className="relative">
              <Server className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
              <input
                type="text"
                placeholder={formData.httpMethod === 'CUSTOM_CURL' ? 'My API Endpoint' : 'My Website'}
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="w-full pl-10 pr-3 py-2.5 border border-slate-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              />
            </div>
          </div>

          {/* Status Codes (conditionally rendered) */}
          {(formData.httpMethod !== 'PING') && (
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-3">
                Success Status Codes *
              </label>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                {statusCodeOptions.map(code => (
                  <label key={code} className="flex items-center space-x-2 p-2 bg-slate-50 rounded-lg hover:bg-slate-100 cursor-pointer transition-colors">
                    <input
                      type="checkbox"
                      checked={formData.expectedStatusCodes.includes(code)}
                      onChange={() => handleStatusCodeChange(code)}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                    />
                    <span className="text-sm text-slate-700 font-medium">{code}</span>
                  </label>
                ))}
              </div>
            </div>
          )}

          {/* Check Interval */}
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-3">
              Check Interval (minutes) *
            </label>
            <div className="relative">
              <Clock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
              <select
                value={formData.interval}
                onChange={(e) => setFormData({ ...formData, interval: parseInt(e.target.value) })}
                className="w-full pl-10 pr-3 py-2.5 border border-slate-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              >
                <option value={1}>1 minute</option>
                <option value={5}>5 minutes</option>
                <option value={10}>10 minutes</option>
                <option value={15}>15 minutes</option>
                <option value={30}>30 minutes</option>
                <option value={60}>1 hour</option>
              </select>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex justify-end space-x-3 pt-4 border-t border-slate-200/60">
            <button
              type="button"
              onClick={onClose}
              className="px-6 py-2.5 border border-slate-300 text-slate-700 rounded-xl hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-slate-500 font-medium transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-6 py-2.5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed font-medium transition-colors"
            >
              {loading ? (
                <div className="flex items-center space-x-2">
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  <span>Updating Website...</span>
                </div>
              ) : (
                'Update Website'
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default EditWebsiteModal;