import { describe, it, expect, vi, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../server/server.js';
import * as child_process from 'child_process';
import fs from 'fs';
import path from 'path';

// Mock child_process for safety so tests don't actually shutdown the PC
vi.mock('child_process', async (importOriginal) => {
  return {
    exec: vi.fn((cmd, cb) => cb(null, 'OK', '')),
  };
});

describe('Desligar PC API Tests', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('POST /api/shutdown', () => {
    it('deve retornar erro se os segundos forem invalidos', async () => {
      const response = await request(app)
        .post('/api/shutdown')
        .send({ seconds: 'abc' });
      
      expect(response.status).toBe(400);
      expect(response.body.error).toMatch(/Tempo inválido/);
    });

    it('deve agendar o desligamento se os segundos forem validos', async () => {
      const response = await request(app)
        .post('/api/shutdown')
        .send({ seconds: 3600 });
      
      expect(response.status).toBe(200);
      expect(response.body.ok).toBe(true);
      expect(child_process.exec).toHaveBeenCalledWith(
        expect.stringContaining('shutdown /s /t 3600'),
        expect.any(Function)
      );
    });
  });

  describe('POST /api/cancel', () => {
    it('deve cancelar o agendamento', async () => {
      const response = await request(app).post('/api/cancel');
      
      expect(response.status).toBe(200);
      expect(response.body.ok).toBe(true);
      expect(child_process.exec).toHaveBeenCalledWith(
        'shutdown /a',
        expect.any(Function)
      );
    });
  });
  
  describe('GET /api/status', () => {
    it('deve retornar o status atual', async () => {
      const response = await request(app).get('/api/status');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('scheduled');
    });
  });
});
