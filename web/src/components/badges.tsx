import {
  PROJECT_STATUS_LABELS,
  TASK_PRIORITY_LABELS,
  TASK_STATUS_LABELS,
  type ProjectStatus,
  type TaskPriority,
  type TaskStatus,
} from '../types/api'

/** Renkler mobil uygulamadaki durum etiketleriyle aynıdır. */
const STATUS_STYLES: Record<TaskStatus, string> = {
  0: 'bg-slate-400/15 text-slate-500 dark:text-slate-300',
  1: 'bg-blue-500/15 text-blue-600 dark:text-blue-400',
  2: 'bg-orange-400/15 text-orange-600 dark:text-orange-400',
  3: 'bg-green-500/15 text-green-600 dark:text-green-400',
  4: 'bg-red-500/15 text-red-600 dark:text-red-400',
}

const PRIORITY_STYLES: Record<TaskPriority, string> = {
  0: 'bg-slate-400/15 text-slate-500 dark:text-slate-300',
  1: 'bg-blue-500/15 text-blue-600 dark:text-blue-400',
  2: 'bg-orange-400/15 text-orange-600 dark:text-orange-400',
  3: 'bg-red-500/15 text-red-600 dark:text-red-400',
}

const PROJECT_STYLES: Record<ProjectStatus, string> = {
  0: 'bg-slate-400/15 text-slate-500 dark:text-slate-300',
  1: 'bg-blue-500/15 text-blue-600 dark:text-blue-400',
  2: 'bg-violet-500/15 text-violet-600 dark:text-violet-400',
  3: 'bg-green-500/15 text-green-600 dark:text-green-400',
}

const BASE = 'inline-flex items-center whitespace-nowrap rounded-full px-2.5 py-0.5 text-xs font-medium'

export function StatusBadge({ status }: { status: TaskStatus }) {
  return <span className={`${BASE} ${STATUS_STYLES[status]}`}>{TASK_STATUS_LABELS[status]}</span>
}

export function PriorityBadge({ priority }: { priority: TaskPriority }) {
  return <span className={`${BASE} ${PRIORITY_STYLES[priority]}`}>{TASK_PRIORITY_LABELS[priority]}</span>
}

export function ProjectStatusBadge({ status }: { status: ProjectStatus }) {
  return <span className={`${BASE} ${PROJECT_STYLES[status]}`}>{PROJECT_STATUS_LABELS[status]}</span>
}

export function RoleBadge({ label }: { label: string }) {
  return <span className={`${BASE} bg-primary/10 text-primary`}>{label}</span>
}
