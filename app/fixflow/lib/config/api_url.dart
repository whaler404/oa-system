class ApiUrls {
  // server address
  static const String baseUrl = 'http://139.199.168.63:8080';
  /*-------------- user api --------------*/
  // user login
  static const String userLogin = '$baseUrl/user/login';
  // token check
  static const String tokenCheck = '$baseUrl/user/validateToken';

  /*-------------- applicant api ---------*/
  // get ProcessDefinitions list
  static const String listProcessDefinitions = '$baseUrl/applicant/listProcessDefinitions';
  // get ProcessInstances list
  static const String listProcessInstances = '$baseUrl/applicant/listProcessInstancesNotCompleted';
  //get ProcessDefinitionForm
  static const String getStartForm = '$baseUrl/applicant/getStartForm';
  // create a process instance
  static const String createProcessInstance = '$baseUrl/applicant/createProcessInstance';
  //submit the startform
  static const String submitStartForm = '$baseUrl/applicant/submitStartForm';
  // get origin processdiagram
  static const String getOriginalProcessDiagram = '$baseUrl/applicant/getOriginalProcessDiagram';
  // get ProcessInstance
  static const String getProcessInstance = '$baseUrl/applicant/getProcessInstance';
  //get processInstanceDiagram
  static const String getProcessInstanceDiagram = '$baseUrl/applicant/getProcessInstanceDiagram';
  //abort processInstance
  static const String abortProcessInstance = '$baseUrl/applicant/abortProcessInstance';
  //get HistoricalForm
  static const String getHistoricalForm = '$baseUrl/applicant/getHistoricalForm';
  //list ProcessInstancesCompleted
  static const String listProcessInstancesCompleted = '$baseUrl/applicant/listProcessInstancesCompleted';

  /* --------------approval api--------------  */
  //list ApprovalTasksNotCompleted
  static const String listApprovalTasksNotCompleted = '$baseUrl/approver/listApprovalAssignTasks';
  //list ApprovalTasksCompleted
  static const String listApprovalTasksCompleted = '$baseUrl/approver/listApprovalTasksCompleted';
  //get TaskStartForm
  static const String getTaskStartForm = '$baseUrl/approver/getStartForm';
  //get TaskForm
  static const String getTaskForm = '$baseUrl/approver/getTaskForm';
  //get ProcessProgress
  static const String getProcessProgress = '$baseUrl/approver/getProcessProgress';
  //submit taskForm
  static const String completeApprovalTask = '$baseUrl/approver/completeApprovalTask';
  //get Histotical Form
  static const String getHistoricalTaskForm = '$baseUrl/approver/getHistoricalForm';
  //list ApprovalCandidateTasks
  static const String listApprovalCandidateTasks = '$baseUrl/approver/listApprovalCandidateTasks';
  //claimCandidateTask
  static const String claimCandidateApprovalTask = '$baseUrl/approver/claimCandidateTask';


  /* -------------operator api ----------------*/
  //list OperatorTasksCompleted
  static const String listOperatorTasksCompleted = '$baseUrl/operator/listOperatorTasksCompleted';
  //list listOperatorAssignTasks
  static const String listOperatorAssignTasks = '$baseUrl/operator/listOperatorAssignTasks';
  //get OperationForm
  static const String getOperationForm = '$baseUrl/operator/getTaskFormData';
  //get OperationStartForm
  static const String getOperationStartForm = '$baseUrl/operator/getStartForm';
  //get OperationProcessProgress
  static const String getOperationProcessProgress = '$baseUrl/operator/getProcessProgress';
  //submit OperationForm
  static const String completeOperatorTask = '$baseUrl/operator/completeOperatorTask';
  //get HistoricalOperationForm
  static const String getHistoricalOperationForm = '$baseUrl/operator/getHistoricalForm';
  //list listOperatorCandidateTasks
  static const String listOperatorCandidateTasks = '$baseUrl/operator/listOperatorCandidateTasks';
  //claim CandidateTask
  static const String claimCandidateTask = '$baseUrl/operator/claimCandidateTask';
  //save OperatorTask
  static const String saveOperatorTask = '$baseUrl/operator/saveOperatorTask';
  //unclaim CandidateTask
  static const String unclaimCandidateTask = '$baseUrl/operator/unclaimCandidateTask';
  //list OperatorCandidateUsers
  static const String listOperatorCandidateUsers = '$baseUrl/operator/listOperatorCandidateUsers';
  //assignTask
  static const String assignTask = '$baseUrl/operator/assignTask';
  //get TaskNotCompleted
  static const String getTaskNotCompleted = '$baseUrl/operator/getTaskNotCompleted';
  //unassignTask
  static const String unassignTask = '$baseUrl/operator/unassignTask';
  //endAssignedTask
  static const String endAssignedTask = '$baseUrl/operator/endAssignedTask';


  /* -------------operator api ----------------*/
  // admin login
  static const String adminLogin = '$baseUrl/admin/login';
  // adminToken check
  static const String adminTokenCheck = '$baseUrl/admin/validateToken';
  // admin listProcessDefinitions
  static const String adminlistProcessDefinitions = '$baseUrl/admin/listProcessDefinitions';
  // admin getProcessDiagram 
  static const String admingetProcessDiagram = '$baseUrl/admin/getProcessDiagram';
  // admin getInfo
  static const String admingetInfo = '$baseUrl/admin/getInfo';
  // admin getDailyReport
  static const String getDailyReport = '$baseUrl/admin/getDailyReport';
  // admin listWeeklyReports
  static const String listWeeklyReports = '$baseUrl/admin/listWeeklyReports';
  // admin getWeeklyReport
  static const String getWeeklyReport = '$baseUrl/admin/getWeeklyReport';





  
  


  



  

  


  

}
