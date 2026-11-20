import { api } from './client'
import type {
  AppNotification,
  AppUser,
  AuthResponse,
  DashboardSummary,
  Project,
  ProjectInput,
  ProjectMember,
  RegisterInput,
  Task,
  TaskAttachment,
  TaskComment,
  TaskCreateInput,
  TaskStatus,
  TaskUpdateInput,
} from '../types/api'

export const authApi = {
  login: (email: string, password: string) =>
    api.post<AuthResponse>('/api/Auth/login', { email, password }).then((r) => r.data),
  register: (input: RegisterInput) => api.post('/api/Auth/register', input).then((r) => r.data),
  assignRole: (userEmail: string, role: string) =>
    api.post('/api/Auth/assign-role', { userEmail, role }).then((r) => r.data),
}

export const usersApi = {
  list: () => api.get<AppUser[]>('/api/User').then((r) => r.data),
  setActive: (id: string, isActive: boolean) =>
    api.put(`/api/User/${id}/active`, { isActive }).then((r) => r.data),
}

export const projectsApi = {
  list: () => api.get<Project[]>('/api/Project').then((r) => r.data),
  get: (id: number) => api.get<Project>(`/api/Project/${id}`).then((r) => r.data),
  create: (input: ProjectInput) => api.post<Project>('/api/Project', input).then((r) => r.data),
  update: (id: number, input: ProjectInput) =>
    api.put<Project>(`/api/Project/${id}`, input).then((r) => r.data),
  remove: (id: number) => api.delete(`/api/Project/${id}`).then((r) => r.data),
  members: (id: number) =>
    api.get<ProjectMember[]>(`/api/Project/${id}/members`).then((r) => r.data),
  addMember: (id: number, userId: string) =>
    api.post(`/api/Project/${id}/members`, { userId }).then((r) => r.data),
  removeMember: (id: number, userId: string) =>
    api.delete(`/api/Project/${id}/members/${userId}`).then((r) => r.data),
}

export const tasksApi = {
  list: () => api.get<Task[]>('/api/Task').then((r) => r.data),
  get: (id: number) => api.get<Task>(`/api/Task/${id}`).then((r) => r.data),
  create: (input: TaskCreateInput) => api.post<Task>('/api/Task', input).then((r) => r.data),
  update: (id: number, input: TaskUpdateInput) =>
    api.put<Task>(`/api/Task/${id}`, input).then((r) => r.data),
  updateStatus: (id: number, status: TaskStatus) =>
    api.patch<Task>(`/api/Task/${id}/status`, { status }).then((r) => r.data),
  remove: (id: number) => api.delete(`/api/Task/${id}`).then((r) => r.data),
}

export const commentsApi = {
  list: (taskId: number) =>
    api.get<TaskComment[]>(`/api/TaskComment/task/${taskId}`).then((r) => r.data),
  create: (taskItemId: number, content: string) =>
    api.post<TaskComment>('/api/TaskComment', { taskItemId, content }).then((r) => r.data),
}

export const attachmentsApi = {
  list: (taskId: number) =>
    api.get<TaskAttachment[]>(`/api/TaskAttachment/task/${taskId}`).then((r) => r.data),
  upload: (taskId: number, file: File) => {
    const form = new FormData()
    form.append('file', file)
    return api
      .post<TaskAttachment>(`/api/TaskAttachment/upload/${taskId}`, form)
      .then((r) => r.data)
  },
  /** İndirme uç noktası yetki istediği için dosya Authorization başlığıyla blob olarak alınır. */
  download: async (attachment: TaskAttachment) => {
    const response = await api.get<Blob>(`/api/TaskAttachment/download/${attachment.id}`, {
      responseType: 'blob',
    })
    const url = URL.createObjectURL(response.data)
    const link = document.createElement('a')
    link.href = url
    link.download = attachment.originalFileName
    document.body.appendChild(link)
    link.click()
    link.remove()
    URL.revokeObjectURL(url)
  },
}

export const notificationsApi = {
  list: () => api.get<AppNotification[]>('/api/Notification').then((r) => r.data),
  markRead: (id: number) => api.put(`/api/Notification/${id}/read`).then((r) => r.data),
}

export const dashboardApi = {
  summary: () => api.get<DashboardSummary>('/api/Dashboard/summary').then((r) => r.data),
}
