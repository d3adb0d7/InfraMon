// frontend/src/pages/Users.js
import React, { useState, useEffect } from 'react';
import { 
  Users as UsersIcon, 
  Plus, 
  Edit, 
  Trash2, 
  Shield,
  User,
  Eye,
  EyeOff,
  Search,
  Filter,
  Mail,
  MessageSquare,
  CheckCircle,
  XCircle,
  X,
  Check,
  AlertTriangle
} from 'lucide-react';
import { usersAPI } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

const Users = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const { user: currentUser } = useAuth();

  // Animation states
  const [showNotification, setShowNotification] = useState(false);
  const [notification, setNotification] = useState({ 
    message: '', 
    type: '', 
    icon: null 
  });

  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    role: 'user',
    telegramChatId: '',
    isActive: true
  });

  useEffect(() => {
    loadUsers();
  }, []);

  const showSuccessNotification = (message) => {
    setNotification({
      message,
      type: 'success',
      icon: CheckCircle
    });
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 4000);
  };

  const showErrorNotification = (message) => {
    setNotification({
      message,
      type: 'error',
      icon: AlertTriangle
    });
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 5000);
  };

  const loadUsers = async () => {
    try {
      setLoading(true);
      const response = await usersAPI.getAll();
      setUsers(response.data);
    } catch (error) {
      console.error('Error loading users:', error);
      showErrorNotification('Error loading users: ' + (error.response?.data?.error || error.message));
    } finally {
      setLoading(false);
    }
  };

  const handleAddUser = async (e) => {
    e.preventDefault();
    try {
      const response = await usersAPI.create(formData);
      setUsers([...users, response.data]);
      setShowAddModal(false);
      resetForm();
      showSuccessNotification('User created successfully!');
    } catch (error) {
      console.error('Error creating user:', error);
      showErrorNotification('Error creating user: ' + (error.response?.data?.error || error.message));
    }
  };

  const handleEditUser = async (e) => {
    e.preventDefault();
    try {
      const response = await usersAPI.update(editingUser.id, formData);
      setUsers(users.map(u => u.id === editingUser.id ? response.data : u));
      setShowEditModal(false);
      setEditingUser(null);
      resetForm();
      showSuccessNotification('User updated successfully!');
    } catch (error) {
      console.error('Error updating user:', error);
      showErrorNotification('Error updating user: ' + (error.response?.data?.error || error.message));
    }
  };

  const handleDeleteUser = async (userId) => {
    if (userId === currentUser.id) {
      showErrorNotification('You cannot delete your own account!');
      return;
    }

    // Show confirmation modal instead of window.confirm
    const userToDelete = users.find(u => u.id === userId);
    setNotification({
      message: `Are you sure you want to delete user "${userToDelete?.username}"? This action cannot be undone.`,
      type: 'confirm',
      icon: AlertTriangle,
      onConfirm: async () => {
        try {
          await usersAPI.delete(userId);
          setUsers(users.filter(u => u.id !== userId));
          showSuccessNotification('User deleted successfully!');
        } catch (error) {
          console.error('Error deleting user:', error);
          showErrorNotification('Error deleting user: ' + (error.response?.data?.error || error.message));
        }
      },
      onCancel: () => setShowNotification(false)
    });
    setShowNotification(true);
  };

  const handleEditClick = (user) => {
    setEditingUser(user);
    setFormData({
      username: user.username,
      email: user.email,
      password: '',
      role: user.role,
      telegramChatId: user.telegramChatId || '',
      isActive: user.isActive
    });
    setShowEditModal(true);
  };

  const resetForm = () => {
    setFormData({
      username: '',
      email: '',
      password: '',
      role: 'user',
      telegramChatId: '',
      isActive: true
    });
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = roleFilter === 'all' || user.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  const getRoleConfig = (role) => {
    const configs = {
      admin: { color: 'bg-rose-100 text-rose-800 border-rose-200', icon: Shield, label: 'Admin' },
      monitoring_user: { color: 'bg-blue-100 text-blue-800 border-blue-200', icon: Eye, label: 'Monitoring User' },
      user: { color: 'bg-emerald-100 text-emerald-800 border-emerald-200', icon: User, label: 'User' }
    };
    return configs[role] || configs.user;
  };

  const Notification = () => {
    if (!showNotification) return null;

    const Icon = notification.icon;
    const isSuccess = notification.type === 'success';
    const isError = notification.type === 'error';
    const isConfirm = notification.type === 'confirm';

    return (
      <div className="fixed top-4 right-4 z-50 animate-fade-in-down">
        <div className={`rounded-2xl p-4 shadow-lg max-w-sm border ${
          isSuccess 
            ? 'bg-emerald-50 border-emerald-200' 
            : isError
            ? 'bg-rose-50 border-rose-200'
            : 'bg-amber-50 border-amber-200'
        }`}>
          <div className="flex items-center space-x-3">
            <div className={`p-2 rounded-xl ${
              isSuccess 
                ? 'bg-emerald-100 text-emerald-600' 
                : isError
                ? 'bg-rose-100 text-rose-600'
                : 'bg-amber-100 text-amber-600'
            }`}>
              <Icon className="h-5 w-5" />
            </div>
            
            <div className="flex-1">
              <p className={`text-sm font-medium ${
                isSuccess ? 'text-emerald-800' : 
                isError ? 'text-rose-800' : 
                'text-amber-800'
              }`}>
                {notification.message}
              </p>
              
              {isConfirm && (
                <div className="flex space-x-2 mt-3">
                  <button
                    onClick={notification.onConfirm}
                    className="flex-1 bg-rose-600 text-white px-3 py-1.5 rounded-lg text-sm font-medium hover:bg-rose-700 transition-colors"
                  >
                    Delete
                  </button>
                  <button
                    onClick={notification.onCancel}
                    className="flex-1 bg-slate-200 text-slate-700 px-3 py-1.5 rounded-lg text-sm font-medium hover:bg-slate-300 transition-colors"
                  >
                    Cancel
                  </button>
                </div>
              )}
            </div>
            
            {!isConfirm && (
              <button
                onClick={() => setShowNotification(false)}
                className={`p-1 rounded-lg ${
                  isSuccess 
                    ? 'text-emerald-600 hover:bg-emerald-100' 
                    : isError
                    ? 'text-rose-600 hover:bg-rose-100'
                    : 'text-amber-600 hover:bg-amber-100'
                } transition-colors`}
              >
                <X className="h-4 w-4" />
              </button>
            )}
          </div>
        </div>
      </div>
    );
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-slate-600 text-lg">Loading users...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 relative">
      {/* Notification Component */}
      <Notification />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header */}
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="text-center lg:text-left">
              <h1 className="text-4xl font-bold text-slate-900 mb-3">User Management</h1>
              <p className="text-lg text-slate-600">Manage system users and permissions</p>
            </div>
            
            {currentUser.role === 'admin' && (
              <button
                onClick={() => setShowAddModal(true)}
                className="bg-blue-600 text-white px-6 py-2.5 rounded-lg font-medium hover:bg-blue-700 transition-colors flex items-center space-x-2 justify-center"
              >
                <Plus className="h-4 w-4" />
                <span>Add User</span>
              </button>
            )}
          </div>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60 mb-6">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="flex flex-col sm:flex-row lg:items-center gap-4 flex-1">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
                <input
                  type="text"
                  placeholder="Search users..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10 pr-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 w-full"
                />
              </div>
              
              <select
                value={roleFilter}
                onChange={(e) => setRoleFilter(e.target.value)}
                className="px-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="all">All Roles</option>
                <option value="admin">Admin</option>
                <option value="user">User</option>
                <option value="monitoring_user">Monitoring User</option>
              </select>
            </div>
            
            <div className="text-sm text-slate-600">
              Showing {filteredUsers.length} of {users.length} users
            </div>
          </div>
        </div>

        {/* Users Table */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200">
              <thead className="bg-slate-50">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">User</th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Role</th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Status</th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Contact</th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Created</th>
                  {currentUser.role === 'admin' && (
                    <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Actions</th>
                  )}
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {filteredUsers.length === 0 ? (
                  <tr>
                    <td colSpan={currentUser.role === 'admin' ? 6 : 5} className="px-6 py-12 text-center text-slate-500">
                      <div className="flex flex-col items-center space-y-3">
                        <UsersIcon className="h-12 w-12 text-slate-300" />
                        <div>No users found</div>
                        <div className="text-sm">Try adjusting your search or filters</div>
                      </div>
                    </td>
                  </tr>
                ) : (
                  filteredUsers.map((user) => {
                    const roleConfig = getRoleConfig(user.role);
                    const Icon = roleConfig.icon;
                    
                    return (
                      <tr key={user.id} className="hover:bg-slate-50/50 transition-colors">
                        <td className="px-6 py-4">
                          <div className="flex items-center">
                            <div className="flex-shrink-0 h-10 w-10 bg-gradient-to-r from-blue-500 to-blue-600 rounded-full flex items-center justify-center">
                              <span className="text-white font-medium text-sm">
                                {user.username.charAt(0).toUpperCase()}
                              </span>
                            </div>
                            <div className="ml-4">
                              <div className="text-sm font-medium text-slate-900">
                                {user.username}
                                {user.id === currentUser.id && (
                                  <span className="ml-2 text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                                    You
                                  </span>
                                )}
                              </div>
                              <div className="text-sm text-slate-600">{user.email}</div>
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex items-center space-x-2">
                            <Icon className="h-4 w-4" />
                            <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${roleConfig.color}`}>
                              {roleConfig.label}
                            </span>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex items-center space-x-2">
                            {user.isActive ? (
                              <CheckCircle className="h-4 w-4 text-emerald-500" />
                            ) : (
                              <XCircle className="h-4 w-4 text-rose-500" />
                            )}
                            <span className={`text-sm ${user.isActive ? 'text-emerald-600' : 'text-rose-600'}`}>
                              {user.isActive ? 'Active' : 'Inactive'}
                            </span>
                          </div>
                        </td>
                        <td className="px-6 py-4 text-sm text-slate-600">
                          <div className="space-y-1">
                            {user.telegramChatId && (
                              <div className="flex items-center space-x-2">
                                <MessageSquare className="h-3 w-3 text-emerald-500" />
                                <span>Telegram: {user.telegramChatId}</span>
                              </div>
                            )}
                          </div>
                        </td>
                        <td className="px-6 py-4 text-sm text-slate-600">
                          {new Date(user.createdAt).toLocaleDateString()}
                        </td>
                        {currentUser.role === 'admin' && (
                          <td className="px-6 py-4">
                            <div className="flex space-x-2">
                              <button
                                onClick={() => handleEditClick(user)}
                                className="text-blue-600 hover:text-blue-900 transition-colors p-1"
                                title="Edit user"
                              >
                                <Edit className="h-4 w-4" />
                              </button>
                              <button
                                onClick={() => handleDeleteUser(user.id)}
                                disabled={user.id === currentUser.id}
                                className="text-rose-600 hover:text-rose-900 disabled:opacity-50 disabled:cursor-not-allowed transition-colors p-1"
                                title={user.id === currentUser.id ? "Cannot delete your own account" : "Delete user"}
                              >
                                <Trash2 className="h-4 w-4" />
                              </button>
                            </div>
                          </td>
                        )}
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Add User Modal */}
        {showAddModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 animate-fade-in">
            <div className="bg-white rounded-2xl max-w-md w-full max-h-[90vh] overflow-y-auto animate-scale-in">
              <div className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-slate-900">Add New User</h3>
                  <button
                    onClick={() => {
                      setShowAddModal(false);
                      resetForm();
                    }}
                    className="text-slate-400 hover:text-slate-600 transition-colors"
                  >
                    <X className="h-5 w-5" />
                  </button>
                </div>
                <form onSubmit={handleAddUser} className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Username</label>
                    <input
                      type="text"
                      required
                      value={formData.username}
                      onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Enter username"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Email</label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Enter email"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Password</label>
                    <input
                      type="password"
                      required
                      value={formData.password}
                      onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Enter password"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Role</label>
                    <select
                      value={formData.role}
                      onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="user">User</option>
                      <option value="admin">Admin</option>
                      <option value="monitoring_user">Monitoring User</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Telegram Chat ID (Optional)</label>
                    <input
                      type="text"
                      value={formData.telegramChatId}
                      onChange={(e) => setFormData({ ...formData, telegramChatId: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="123456789"
                    />
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.isActive}
                      onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                    />
                    <label className="ml-2 text-sm text-slate-700">Active User</label>
                  </div>
                  <div className="flex justify-end space-x-3 pt-4">
                    <button
                      type="button"
                      onClick={() => {
                        setShowAddModal(false);
                        resetForm();
                      }}
                      className="px-4 py-2.5 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors"
                    >
                      Cancel
                    </button>
                    <button
                      type="submit"
                      className="px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    >
                      Create User
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        )}

        {/* Edit User Modal */}
        {showEditModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 animate-fade-in">
            <div className="bg-white rounded-2xl max-w-md w-full max-h-[90vh] overflow-y-auto animate-scale-in">
              <div className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-slate-900">Edit User</h3>
                  <button
                    onClick={() => {
                      setShowEditModal(false);
                      setEditingUser(null);
                      resetForm();
                    }}
                    className="text-slate-400 hover:text-slate-600 transition-colors"
                  >
                    <X className="h-5 w-5" />
                  </button>
                </div>
                <form onSubmit={handleEditUser} className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Username</label>
                    <input
                      type="text"
                      required
                      value={formData.username}
                      onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Email</label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">New Password (Leave blank to keep current)</label>
                    <input
                      type="password"
                      value={formData.password}
                      onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="••••••••"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Role</label>
                    <select
                      value={formData.role}
                      onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="user">User</option>
                      <option value="admin">Admin</option>
                      <option value="monitoring_user">Monitoring User</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Telegram Chat ID</label>
                    <input
                      type="text"
                      value={formData.telegramChatId}
                      onChange={(e) => setFormData({ ...formData, telegramChatId: e.target.value })}
                      className="w-full px-3 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="123456789"
                    />
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.isActive}
                      onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                    />
                    <label className="ml-2 text-sm text-slate-700">Active User</label>
                  </div>
                  <div className="flex justify-end space-x-3 pt-4">
                    <button
                      type="button"
                      onClick={() => {
                        setShowEditModal(false);
                        setEditingUser(null);
                        resetForm();
                      }}
                      className="px-4 py-2.5 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors"
                    >
                      Cancel
                    </button>
                    <button
                      type="submit"
                      className="px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    >
                      Update User
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Users;