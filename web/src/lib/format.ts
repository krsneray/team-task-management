import { TaskStatus, type Task } from '../types/api'

const pad = (n: number) => String(n).padStart(2, '0')

/** Yerel saate göre bugünün tarihi (YYYY-MM-DD). */
export function todayIso(now: Date = new Date()): string {
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`
}

/** "2026-11-20" -> 20.11.2026 (saat dilimi kaymasına uğramadan). */
export function formatDate(value: string | null | undefined): string {
  if (!value) return '-'
  const [y, m, d] = value.slice(0, 10).split('-')
  if (!y || !m || !d) return '-'
  return `${d}.${m}.${y}`
}

/** API'den gelen DateTime değerleri UTC'dir ama 'Z' eki olmadan gelir. */
export function parseApiDateTime(value: string): Date {
  const hasZone = /(Z|[+-]\d{2}:?\d{2})$/.test(value)
  return new Date(hasZone ? value : `${value}Z`)
}

export function formatDateTime(value: string | null | undefined): string {
  if (!value) return '-'
  const date = parseApiDateTime(value)
  if (Number.isNaN(date.getTime())) return '-'
  return `${pad(date.getDate())}.${pad(date.getMonth() + 1)}.${date.getFullYear()} ${pad(date.getHours())}:${pad(date.getMinutes())}`
}

export function timeAgo(value: string, now: Date = new Date()): string {
  const diff = Math.max(0, now.getTime() - parseApiDateTime(value).getTime())
  const minutes = Math.floor(diff / 60000)
  if (minutes < 1) return 'az önce'
  if (minutes < 60) return `${minutes} dk önce`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours} sa önce`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days} gün önce`
  return formatDate(value)
}

export function isOpenStatus(status: number): boolean {
  return status === TaskStatus.New || status === TaskStatus.InProgress || status === TaskStatus.OnHold
}

export function isOverdue(task: Pick<Task, 'status' | 'dueDate'>, today: string = todayIso()): boolean {
  return isOpenStatus(task.status) && task.dueDate.slice(0, 10) < today
}

export function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

export function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean)
  if (parts.length === 0) return '?'
  const first = parts[0][0] ?? ''
  const last = parts.length > 1 ? (parts[parts.length - 1][0] ?? '') : ''
  return (first + last).toLocaleUpperCase('tr-TR')
}

export function paginate<T>(items: T[], page: number, pageSize: number): T[] {
  const start = (page - 1) * pageSize
  return items.slice(start, start + pageSize)
}

export function pageCount(total: number, pageSize: number): number {
  return Math.max(1, Math.ceil(total / pageSize))
}

/** Türkçe karakterleri de dikkate alan küçük harfe çevirme (arama için). */
export function norm(value: string): string {
  return value.toLocaleLowerCase('tr-TR')
}
