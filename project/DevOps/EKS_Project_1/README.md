Tools and Services:

CI/CD Platform:
Jenkins: Open-source, popular choice, requires some server management.<br .>
Tekton: Kubernetes-native, good for containerized workloads, requires more Kubernetes knowledge.
AWS CodeBuild & CodePipeline: Cloud-based, integrates well with AWS services, might have limitations for complex pipelines. <br />
Version Control: Git (GitHub, GitLab, etc.)
Container Registry:
ECR: AWS-managed, integrates well with EKS, consider cost based on usage.
Docker Hub: Free for public repositories, limited storage/bandwidth for private.
Kubernetes Tools:
kubectl: Command-line tool for managing your EKS cluster.
Helm: Package manager for Kubernetes deployments.
Pipeline Stages:

Code Push: Trigger the pipeline on code push to a specific branch or tag.
Build: Build Docker images for your microservices using tools like Maven, Gradle, or npm.
Unit & Integration Tests: Run automated tests to ensure code quality and functionality.
Security Scans: Integrate tools like Snyk or Aqua to scan for vulnerabilities in your code and images.
Deploy to Staging: Deploy a smaller test environment of your microservices to validate stability and functionality.
Manual/Automated Approval: Implement a review or approval process before deploying to production.
Deploy to Production: Deploy your microservices to your EKS cluster in your main production environment.
Monitoring & Rollbacks: Implement monitoring and rollback strategies for quick response to potential issues.
Tips for Low Budget:

Utilize free tiers: Many CI/CD tools offer free tiers for limited usage.
Use Spot Fleet for build agents: Leverage AWS Spot Fleet for cost-effective build resources in your pipeline.
Optimize resource usage: Scale down or terminate pods in staging and production when not needed.
Monitor and automate cost management: Implement proactive cost-saving measures with AWS Cost Explorer and CloudWatch.
-----------------------------------------------
Starting point :
1.build up with EKS .
2.Build S3 and Cloud watch. 
3.Setup with Jenkins and cloud watch .<br />