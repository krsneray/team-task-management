// API sözleşmesi (TeamTaskManager.DTO ile birebir). Enum'lar API'den sayı olarak gelir.

export const TaskStatus = { New: 0, InProgress: 1, OnHold: 2, Completed: 3, Cancelled: 4 } as const
export type TaskStatus = (typeof TaskStatus)[keyof typeof TaskStatus]

export const TaskPriority = { Low: 0, Medium: 1, High: 2, Critical: 3 } as const
export type TaskPriority = (typeof TaskPriority)[keyof typeof TaskPriority]

export const ProjectStatus = { ToDo: 0, InProgress: 1, Review: 2, Done: 3 } as const
export type ProjectStatus = (typeof ProjectStatus)[keyof typeof ProjectStatus]

export const ProjectRole = { Manager: 0, Member: 1 } as const
export type ProjectRole = (typeof ProjectRole)[keyof typeof ProjectRole]

export const NotificationType = {
  TaskAssigned: 0,
  TaskStatusChanged: 1,
  TaskCommented: 2,
  ProjectMemberAdded: 3,
} as const
export type NotificationType = (typeof NotificationType)[keyof typeof NotificationType]

export type RoleName = 'Admin' | 'ProjectManager' | 'TeamMember'

export const TASK_STATUS_LABELS: Record<TaskStatus, string> = {
  0: 'Yeni',
  1: 'Devam Ediyor',
  2: 'Beklemede',
  3: 'Tamamlandı',
  4: 'İptal Edildi',
}

export const TASK_PRIORITY_LABELS: Record<TaskPriority, string> = {
  0: 'Düşük',
  1: 'Orta',
  2: 'Yüksek',
  3: 'Kritik',
}

export const PROJECT_STATUS_LABELS: Record<ProjectStatus, string> = {
  0: 'Planlanıyor',
  1: 'Devam Ediyor',
  2: 'İncelemede',
  3: 'Tamamlandı',
}

export const ROLE_LABELS: Record<string, string> = {
  Admin: 'Yönetici',
  ProjectManager: 'Proje Yöneticisi',
  TeamMember: 'Ekip Üyesi',
}

export interface AuthResponse {
  userId: string
  token: string
  email: string
  fullName: string
  roles: string[]
  expiresAt: string
}

export interface Project {
  id: number
  name: string
  description: string | null
  startDate: string
  targetEndDate: string
  status: ProjectStatus
  managerUserId: string
  createdTime: string
  updatedTime: string
}

export interface ProjectInput {
  name: string
  description?: string | null
  startDate: string
  targetEndDate: string
}

export interface ProjectMember {
  userId: string
  fullName: string
  email: string
  memberRole: ProjectRole
  isActive: boolean
  joinedDate: string
}

export interface Task {
  id: number
  projectId: number
  title: string
  description: string | null
  assignedUserId: string
  priority: TaskPriority
  status: TaskStatus
  startDate: string | null
  dueDate: string
  completedDate: string | null
  createdByUserId: string
  createdDate: string
  updatedDate: string | null
}

export interface TaskCreateInput {
  projectId: number
  title: string
  description?: string | null
  assignedUserId: string
  priority: TaskPriority
  status: TaskStatus
  startDate?: string | null
  dueDate: string
}

export interface TaskUpdateInput {
  title: string
  description?: string | null
  assignedUserId: string
  priority: TaskPriority
  status: TaskStatus
  startDate?: string | null
  dueDate: string
}

export interface TaskComment {
  id: number
  taskItemId: number
  userId: string
  content: string
  createdDate: string
  updatedDate: string | null
}

export interface TaskAttachment {
  id: number
  taskItemId: number
  originalFileName: string
  contentType: string
  fileSize: number
  uploadedByUserId: string
  createdDate: string
}

export interface AppNotification {
  id: number
  userId: string
  title: string
  message: string
  type: NotificationType
  relatedEntityId: number
  isRead: boolean
  createdDate: string
}

export interface AppUser {
  id: string
  email: string
  fullName: string
  roles: string[]
  isActive: boolean
}

export interface RegisterInput {
  firstName: string
  lastName: string
  email: string
  password: string
}

export interface ProjectProgress {
  projectId: number
  name: string
  totalTasks: number
  completedTasks: number
  overdueTasks: number
  progressPercent: number
}

export interface UserWorkload {
  userId: string
  fullName: string
  openTasks: number
  completedTasks: number
}

export interface RecentActivity {
  id: number
  taskId: number
  taskTitle: string
  userFullName: string
  description: string
  createdDate: string
}

export interface DashboardSummary {
  projectCount: number
  totalTasks: number
  openTasks: number
  overdueTasks: number
  completedTasks: number
  myOpenTasks: number
  myOverdueTasks: number
  unreadNotifications: number
  projects: ProjectProgress[]
  workload: UserWorkload[]
  recentActivities: RecentActivity[]
}

export interface ApiErrorBody {
  title?: string
  statusCode?: number
  errors?: string[]
  traceId?: string
}
