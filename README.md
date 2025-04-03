Here's a **simple and clean README.md** for your GitHub repository:  

---

### **README.md**  

```md
# Terraform AWS EC2 Web Server Deployment 🚀

This project uses **Terraform** to create an **AWS EC2 instance** with **Apache2** installed inside a custom VPC. The web server serves a basic HTML page.

## 📌 Features
- Deploys an **EC2 instance** in a public subnet.
- Configures **security groups** to allow HTTP and SSH access.
- Installs **Apache2** automatically.
- Outputs the **public IP** of the instance.

## 🔧 Prerequisites
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (`terraform -v`)
- An AWS key pair for SSH access

## 🚀 Deployment Steps
1. **Clone the Repository**  
   ```sh
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Initialize Terraform**  
   ```sh
   terraform init
   ```

3. **Apply the Terraform Configuration**  
   ```sh
   terraform apply -auto-approve
   ```

4. **Get the Public IP of the EC2 Instance**  
   ```sh
   terraform output
   ```

5. **Access the Web Server**  
   Open your browser and go to:  
   ```
   http://<your-public-ip>
   ```

## 🛠 Managing the Infrastructure
- **Destroy Resources**:  
  ```sh
  terraform destroy -auto-approve
  ```

## 📜 License
This project is licensed under the MIT License.

---

🚀 Happy Coding!  
```

---

### **Next Steps**
- **Save this as** `README.md`
- **Push it to GitHub**:
  ```sh
  git add README.md
  git commit -m "Added README"
  git push origin main
  ```
- **Done!** 🎉  

Let me know if you need any modifications! 🚀🔥