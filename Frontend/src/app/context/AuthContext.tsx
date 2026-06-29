import React, { createContext, useContext, useState, useEffect } from 'react';

export type UserRole = 'doctor' | 'patient' | 'admin';

export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  avatar?: string;
  specialty?: string;
  phone?: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  register: (email: string, password: string, name: string, role: UserRole, specialty?: string) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
  resetPassword: (email: string) => Promise<boolean>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    const storedUser = localStorage.getItem('currentUser');
    if (storedUser) {
      setUser(JSON.parse(storedUser));
    }
  }, []);

  // ✅ LOGIN (REAL BACKEND ONLY)
  const login = async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      const response = await fetch('http://localhost:8080/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      if (response.ok) {
        const data = await response.json();
        const authResponse = data.data;

        const user: User = {
          id: authResponse.id, // Fixed: backend returns 'id' not 'userId'
          email: authResponse.email,
          name: authResponse.name,
          role: authResponse.role.toLowerCase() as UserRole,
        };

        localStorage.setItem('token', authResponse.token);
        localStorage.setItem('currentUser', JSON.stringify(user));
        setUser(user);

        return { success: true };
      } else {
        // Try to get error message from backend
        const errorData = await response.json().catch(() => ({}));
        const errorMessage = errorData.message || 'Login failed';
        console.error('Login failed:', errorMessage);
        return { success: false, error: errorMessage };
      }
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, error: 'Network error. Please try again.' };
    }
  };

  // ✅ REGISTER (FIXED — SAVES TO MONGODB)
  const register = async (
    email: string,
    password: string,
    name: string,
    role: UserRole,
    specialty?: string
  ): Promise<{ success: boolean; error?: string }> => {
    try {
      const response = await fetch('http://localhost:8080/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email,
          password,
          name,
          role: role.toUpperCase(), // ✅ IMPORTANT FIX
          specialty,
        }),
      });

      if (response.ok) {
        return { success: true };
      } else {
        // Try to get error message from backend
        const errorData = await response.json().catch(() => ({}));
        const errorMessage = errorData.message || 'Registration failed';
        console.error('Registration failed:', errorMessage);
        return { success: false, error: errorMessage };
      }
    } catch (error) {
      console.error('Registration error:', error);
      return { success: false, error: 'Network error. Please try again.' };
    }
  };

  // ✅ LOGOUT
  const logout = () => {
    setUser(null);
    localStorage.removeItem('currentUser');
    localStorage.removeItem('token');
  };

  // ✅ RESET PASSWORD (DUMMY)
  const resetPassword = async (email: string): Promise<boolean> => {
    await new Promise(resolve => setTimeout(resolve, 500));
    return true;
  };

  return (
    <AuthContext.Provider value={{ user, login, register, logout, resetPassword }}>
      {children}
    </AuthContext.Provider>
  );
}

// ✅ HOOK
export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
