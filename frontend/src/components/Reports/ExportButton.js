import React, { useState } from 'react';
import { Download, Loader, CheckCircle, AlertCircle, X } from 'lucide-react';
import { reportsAPI } from '../../services/api';

const ExportButton = ({ dateRange, type, disabled }) => {
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ text: '', type: '' });

  const showMessage = (text, type) => {
    setMessage({ text, type });
    setTimeout(() => setMessage({ text: '', type: '' }), 5000);
  };

  const handleCloseMessage = () => {
    setMessage({ text: '', type: '' });
  };

  const handleExport = async () => {
    if (!dateRange.startDate || !dateRange.endDate) {
      showMessage('Please select a date range first', 'error');
      return;
    }

    setLoading(true);
    
    try {
      console.log('Exporting data:', { type, dateRange });
      
      const response = await reportsAPI.exportData(type, {
        startDate: dateRange.startDate,
        endDate: dateRange.endDate
      });

      // Create blob from response data
      const blob = new Blob([response.data], { type: 'text/csv' });
      
      // Create download link
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      
      // Set filename based on type and date
      const start = dateRange.startDate;
      const end = dateRange.endDate;
      const filename = `${type}-export-${start}-to-${end}.csv`;
      
      link.setAttribute('download', filename);
      document.body.appendChild(link);
      link.click();
      
      // Cleanup
      link.remove();
      window.URL.revokeObjectURL(url);
      
      console.log('Export completed successfully');
      showMessage(`Export completed successfully! File "${filename}" has been downloaded.`, 'success');
      
    } catch (error) {
      console.error('Export error:', error);
      
      // Handle different error types
      if (error.response?.status === 400) {
        const errorMessage = error.response.data?.error || 'No data found for export';
        showMessage(errorMessage, 'error');
      } else if (error.response?.status === 500) {
        showMessage('Server error during export', 'error');
      } else if (error.code === 'NETWORK_ERROR') {
        showMessage('Network error - please check your connection', 'error');
      } else {
        const errorMessage = error.response?.data?.error || error.message || 'Export failed';
        showMessage(errorMessage, 'error');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      {/* Export Button */}
      <button
        onClick={handleExport}
        disabled={disabled || loading}
        className="bg-emerald-600 text-white px-4 py-2.5 rounded-lg font-medium hover:bg-emerald-700 disabled:opacity-50 transition-colors flex items-center space-x-2 shadow-lg shadow-emerald-600/25"
      >
        {loading ? (
          <Loader className="h-4 w-4 animate-spin" />
        ) : (
          <Download className="h-4 w-4" />
        )}
        <span>{loading ? 'Exporting...' : 'Export CSV'}</span>
      </button>

      {/* Centered Modal-style Message */}
      {message.text && (
        <div className="fixed inset-0 flex items-center justify-center z-50 p-4 animate-fade-in">
          {/* Backdrop */}
          <div 
            className="absolute inset-0 bg-black bg-opacity-50 transition-opacity"
            onClick={handleCloseMessage}
          />
          
          {/* Message Card */}
          <div className={`relative rounded-2xl p-6 shadow-2xl border max-w-md w-full animate-scale-in ${
            message.type === 'error' 
              ? 'bg-rose-50 border-rose-200 text-rose-700' 
              : 'bg-emerald-50 border-emerald-200 text-emerald-700'
          }`}>
            {/* Close Button */}
            <button
              onClick={handleCloseMessage}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-600 transition-colors"
            >
              <X className="h-5 w-5" />
            </button>
            
            <div className="flex items-start space-x-4 pr-6">
              <div className={`p-2 rounded-xl ${
                message.type === 'error' 
                  ? 'bg-rose-100 text-rose-600' 
                  : 'bg-emerald-100 text-emerald-600'
              }`}>
                {message.type === 'error' ? (
                  <AlertCircle className="h-6 w-6" />
                ) : (
                  <CheckCircle className="h-6 w-6" />
                )}
              </div>
              
              <div className="flex-1">
                <h3 className={`font-bold text-lg mb-2 ${
                  message.type === 'error' ? 'text-rose-800' : 'text-emerald-800'
                }`}>
                  {message.type === 'error' ? 'Export Failed' : 'Export Successful!'}
                </h3>
                <p className={`text-sm ${
                  message.type === 'error' ? 'text-rose-700' : 'text-emerald-700'
                }`}>
                  {message.text}
                </p>
                
                {message.type === 'success' && (
                  <div className="mt-4 text-xs text-emerald-600 bg-emerald-100 px-3 py-2 rounded-lg border border-emerald-200">
                    💾 The CSV file has been saved to your downloads folder
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ExportButton;