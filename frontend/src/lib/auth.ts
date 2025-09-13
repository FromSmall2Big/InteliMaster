import axios from 'axios';
import Cookies from 'js-cookie';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests
api.interceptors.request.use((config) => {
  const token = Cookies.get('access_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export interface User {
  id: number;
  email: string;
  full_name: string;
  is_active: boolean;
  created_at: string;
}

export interface AuthResponse {
  access_token: string;
  token_type: string;
}

export interface SignupData {
  email: string;
  password: string;
  full_name: string;
}

export interface SigninData {
  email: string;
  password: string;
}

export const authAPI = {
  signup: async (data: SignupData): Promise<User> => {
    const response = await api.post('/signup', data);
    return response.data;
  },

  signin: async (data: SigninData): Promise<AuthResponse> => {
    const params = new URLSearchParams();
    params.append('username', data.email);
    params.append('password', data.password);
    
    const response = await api.post('/token', params, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    return response.data;
  },

  getCurrentUser: async (): Promise<User> => {
    const response = await api.get('/users/me');
    return response.data;
  },

  logout: () => {
    Cookies.remove('access_token');
  },

  setToken: (token: string) => {
    Cookies.set('access_token', token, { expires: 1 }); // 1 day
  },

  getToken: () => {
    return Cookies.get('access_token');
  },

  isAuthenticated: () => {
    return !!Cookies.get('access_token');
  },
};

