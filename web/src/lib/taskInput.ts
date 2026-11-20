import type { TaskValues } from './schemas'
import type { TaskCreateInput, TaskPriority, TaskStatus, TaskUpdateInput } from '../types/api'

/** Form değerlerini API gövdesine çevirir (boş alanlar null olur). */
export function toTaskCreateInput(v: TaskValues): TaskCreateInput {
  return {
    projectId: v.projectId,
    title: v.title,
    description: v.description || null,
    assignedUserId: v.assignedUserId,
    priority: v.priority as TaskPriority,
    status: v.status as TaskStatus,
    startDate: v.startDate || null,
    dueDate: v.dueDate,
  }
}

export function toTaskUpdateInput(v: TaskValues): TaskUpdateInput {
  const { projectId: _projectId, ...rest } = toTaskCreateInput(v)
  return rest
}
