import { describe, expect, it } from 'vitest'
import { formatDate, formatFileSize, initials, isOverdue, pageCount, paginate, parseApiDateTime } from './format'
import { TaskStatus } from '../types/api'

describe('format', () => {
  it('tarihi gg.aa.yyyy biçimler', () => {
    expect(formatDate('2026-03-07')).toBe('07.03.2026')
    expect(formatDate(null)).toBe('-')
  })
  it('Z içermeyen API tarihini UTC kabul eder', () => {
    expect(parseApiDateTime('2026-01-01T10:00:00').toISOString()).toBe('2026-01-01T10:00:00.000Z')
  })
  it('geciken görevi bulur, tamamlananı saymaz', () => {
    expect(isOverdue({ status: TaskStatus.New, dueDate: '2026-01-01' }, '2026-01-02')).toBe(true)
    expect(isOverdue({ status: TaskStatus.Completed, dueDate: '2026-01-01' }, '2026-01-02')).toBe(false)
    expect(isOverdue({ status: TaskStatus.InProgress, dueDate: '2026-01-02' }, '2026-01-02')).toBe(false)
  })
  it('sayfalama', () => {
    const items = [1, 2, 3, 4, 5]
    expect(paginate(items, 2, 2)).toEqual([3, 4])
    expect(pageCount(5, 2)).toBe(3)
    expect(pageCount(0, 2)).toBe(1)
  })
  it('dosya boyutu ve baş harfler', () => {
    expect(formatFileSize(2048)).toBe('2.0 KB')
    expect(initials('Eray Kırşan')).toBe('EK')
  })
})
