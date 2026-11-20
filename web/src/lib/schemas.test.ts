import { describe, expect, it } from 'vitest'
import { commentSchema, loginSchema, projectSchema, registerSchema, taskSchema, validateUpload } from './schemas'

describe('loginSchema', () => {
  it('geçersiz e-postayı reddeder', () => {
    expect(loginSchema.safeParse({ email: 'abc', password: 'x' }).success).toBe(false)
  })
  it('geçerli girişi kabul eder', () => {
    expect(loginSchema.safeParse({ email: 'a@b.co', password: 'x' }).success).toBe(true)
  })
})

describe('projectSchema', () => {
  const base = { name: 'Web', startDate: '2026-01-01', targetEndDate: '2026-02-01' }
  it('3 karakterden kısa adı reddeder', () => {
    expect(projectSchema.safeParse({ ...base, name: 'ab' }).success).toBe(false)
  })
  it('150 karakterden uzun adı reddeder', () => {
    expect(projectSchema.safeParse({ ...base, name: 'a'.repeat(151) }).success).toBe(false)
  })
  it('bitiş tarihi başlangıçtan önceyse targetEndDate hatası verir', () => {
    const r = projectSchema.safeParse({ ...base, targetEndDate: '2025-12-31' })
    expect(r.success).toBe(false)
    if (!r.success) expect(r.error.issues[0].path).toEqual(['targetEndDate'])
  })
  it('geçerli projeyi kabul eder', () => {
    expect(projectSchema.safeParse(base).success).toBe(true)
  })
})

describe('taskSchema', () => {
  const base = {
    projectId: 1,
    title: 'Görev',
    assignedUserId: 'u1',
    priority: 1,
    status: 0,
    startDate: '2026-01-05',
    dueDate: '2026-01-10',
  }
  it('geçerli görevi kabul eder', () => {
    expect(taskSchema.safeParse(base).success).toBe(true)
  })
  it('bitiş tarihi başlangıçtan önceyse reddeder', () => {
    expect(taskSchema.safeParse({ ...base, dueDate: '2026-01-01' }).success).toBe(false)
  })
  it('başlangıç tarihi boş olabilir', () => {
    expect(taskSchema.safeParse({ ...base, startDate: '' }).success).toBe(true)
  })
  it('atanan kişi zorunludur', () => {
    expect(taskSchema.safeParse({ ...base, assignedUserId: '' }).success).toBe(false)
  })
  it('başlık 3 karakterden kısa olamaz', () => {
    expect(taskSchema.safeParse({ ...base, title: 'ab' }).success).toBe(false)
  })
})

describe('commentSchema / registerSchema', () => {
  it('boş yorumu reddeder', () => {
    expect(commentSchema.safeParse({ content: '   ' }).success).toBe(false)
  })
  it('kısa şifreyi reddeder', () => {
    expect(registerSchema.safeParse({ firstName: 'Ali', lastName: 'Veli', email: 'a@b.co', password: '123' }).success).toBe(false)
  })
})

describe('validateUpload', () => {
  it('izinli uzantıyı kabul eder', () => {
    expect(validateUpload({ name: 'rapor.PDF', size: 1000 })).toBeNull()
  })
  it('izinsiz uzantıyı reddeder', () => {
    expect(validateUpload({ name: 'virus.exe', size: 1000 })).not.toBeNull()
  })
  it('10 MB üstünü reddeder', () => {
    expect(validateUpload({ name: 'a.zip', size: 11 * 1024 * 1024 })).not.toBeNull()
  })
  it('boş dosyayı reddeder', () => {
    expect(validateUpload({ name: 'a.txt', size: 0 })).not.toBeNull()
  })
})
