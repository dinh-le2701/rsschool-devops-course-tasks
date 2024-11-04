# DevOps Course

## The goal

The course aims to offer in-depth knowledge of DevOps principles and essential AWS services necessary for efficient automation and infrastructure management. Participants will gain practical skills in setting up, deploying, and managing Kubernetes clusters on AWS, using tools like Kops and Terraform.

# Task 4: Jenkins Installation and Configuration

## File Structure
- **```.github/workflows/```**:
  The directory is where GitHub-specific files are stored, particularly workflows for GitHub Actions.
- **```Screenshots/```**:  
  The directory contains screenshots that are required in some of the tasks.
- **```.gitignore```**:  
  The file specifies which folders or files should be ignored when tracking changes with Git.
- **```README.md```**:  
  This file you're reading.
- **```*.tf```**:  
  Configuration files of Terraform.

## How to Use

1. **Clone the repository**
Clone the repository and navigate to the project directory:
```
git clone git@github.com:CiscoSA/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
git branch task_4
```
2. **Initialize Terraform:**  
   ```terraform init```

3. **Plan and Apply Changes:**  

   ```terraform plan```  

   ```terraform apply```

5. **Install Helm**

   - Follow the instructions to install [Helm](https://helm.sh/).
   - Verify your Helm installation by deploying and removing the Nginx chart from [Bitnami](https://artifacthub.io/packages/helm/bitnami/nginx).

6. **Prepare the Cluster**

   - Ensure your cluster has a solution for managing persistent volumes (PV) and persistent volume claims (PVC). Refer to the [K8s documentation](https://kubernetes.io/docs/concepts/storage/volumes/) and [k3s documentation](https://docs.k3s.io/storage) for more details.

7. **Install Jenkins**

   - Follow the instructions from the [Jenkins documentation](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-helm-v3) to install Jenkins using Helm. Ensure Jenkins is installed in a separate namespace.
     [Debug init container](https://kubernetes.io/docs/tasks/debug/debug-application/debug-init-containers/#accessing-logs-from-init-containers)

8. **Verify Jenkins Installation**

   - Create a simple freestyle project in Jenkins that writes "Hello world" into the log.

9. **Additional Tasks**
   - Set up a GitHub Actions (GHA) pipeline to deploy Jenkins.
   - Configure authentication and security settings for Jenkins.
