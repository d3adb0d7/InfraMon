// frontend/src/utils/dateUtils.js

export const getTodayDate = () => {
  // Use local date components to ensure correct timezone
  const today = new Date();
  
  // Get local date components (this ensures correct timezone)
  const localDate = new Date(today.getTime() - (today.getTimezoneOffset() * 60000));
  
  const year = localDate.getFullYear();
  const month = String(localDate.getMonth() + 1).padStart(2, '0');
  const day = String(localDate.getDate()).padStart(2, '0');
  
  console.log('Today date calculated:', `${year}-${month}-${day}`);
  return `${year}-${month}-${day}`;
};

export const getDaysAgo = (days) => {
  const today = new Date();
  
  // Subtract days and get local date
  const targetDate = new Date(today);
  targetDate.setDate(targetDate.getDate() - days);
  
  // Convert to local date string
  const localDate = new Date(targetDate.getTime() - (targetDate.getTimezoneOffset() * 60000));
  
  const year = localDate.getFullYear();
  const month = String(localDate.getMonth() + 1).padStart(2, '0');
  const day = String(localDate.getDate()).padStart(2, '0');
  
  console.log(`${days} days ago:`, `${year}-${month}-${day}`);
  return `${year}-${month}-${day}`;
};

export const formatDateForInput = (date) => {
  if (!date) return '';
  
  // If it's already in correct format, return as is
  if (typeof date === 'string' && date.match(/^\d{4}-\d{2}-\d{2}$/)) {
    return date;
  }
  
  try {
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) return '';
    
    // Convert to local date
    const localDate = new Date(dateObj.getTime() - (dateObj.getTimezoneOffset() * 60000));
    
    const year = localDate.getFullYear();
    const month = String(localDate.getMonth() + 1).padStart(2, '0');
    const day = String(localDate.getDate()).padStart(2, '0');
    
    return `${year}-${month}-${day}`;
  } catch (error) {
    console.error('Error formatting date:', error);
    return '';
  }
};