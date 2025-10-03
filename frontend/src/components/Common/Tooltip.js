import React from 'react';

const Tooltip = ({ text, children, position = 'top' }) => {
  const positionClasses = {
    top: 'bottom-full left-1/2 transform -translate-x-1/2 mb-2',
    bottom: 'top-full left-1/2 transform -translate-x-1/2 mt-2',
    left: 'right-full top-1/2 transform -translate-y-1/2 mr-2',
    right: 'left-full top-1/2 transform -translate-y-1/2 ml-2'
  };

  const arrowClasses = {
    top: 'absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-slate-800',
    bottom: 'absolute bottom-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-b-slate-800',
    left: 'absolute left-full top-1/2 transform -translate-y-1/2 border-4 border-transparent border-l-slate-800',
    right: 'absolute right-full top-1/2 transform -translate-y-1/2 border-4 border-transparent border-r-slate-800'
  };

  return (
    <div className="relative group/tooltip inline-block">
      {children}
      <div className={`absolute ${positionClasses[position]} opacity-0 group-hover/tooltip:opacity-100 transition-all duration-200 pointer-events-none z-50 animate-fade-in`}>
        <div className="bg-slate-800 text-white text-xs rounded-lg py-2 px-3 whitespace-nowrap shadow-lg">
          {text}
          <div className={arrowClasses[position]}></div>
        </div>
      </div>
    </div>
  );
};

export default Tooltip;