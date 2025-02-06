# Machine-MyBandit: A CTF Learning Environment

Machine-MyBandit is an educational Capture The Flag (CTF) environment designed to help beginners learn Linux command-line basics and common security concepts. Inspired by OverTheWire's Bandit, this containerized challenge series provides a safe, isolated environment for hands-on practice.

## 🎯 Overview

This project contains 11 levels (lab0 to lab10), each teaching different Linux concepts and security principles. Players must find passwords to progress through increasingly challenging levels.

## 🚀 Getting Started

### Prerequisites
- Docker Desktop installed on your system
- SSH client (built into Linux/Mac, use PuTTY or Windows Terminal for Windows)

### Setup Instructions

1. Install and launch Docker Desktop

2. Clone this repository and navigate to the project folder:
   ```bash
   git clone https://github.com/yourusername/Machine-MyBandit.git
   cd Machine-MyBandit
   ```

3. Build the Docker image:
   ```bash
   docker build -t mybandit .
   ```

4. Run the container:
   ```bash
   docker run -d -p 2222:22 --name mybandit mybandit
   ```

5. Get the initial password:
   ```bash
   docker logs mybandit
   ```

6. Start playing! Connect to lab0:
   ```bash
   ssh lab0@localhost -p 2222
   ```

## 🎮 How to Play

1. Start at level 0 (lab0) using the password from the container logs
2. Each level contains a password for the next level
3. Use the password to log into the next level
4. Read the hints provided at login for each level
5. Use Linux commands and problem-solving skills to find the next password

## 🔍 Level Overview

- **Level 0**: Basic file reading
- **Level 1**: Pattern searching
- **Level 2**: Hidden files
- **Level 3**: File permissions
- **Level 4**: File identification
- **Level 5**: File compression
- **Level 6**: Base64 encoding
- **Level 7**: Log analysis
- **Level 8**: Environment variables
- **Level 9**: Script permissions
- **Level 10**: Python debugging

## 🛠 Skills Practiced

- File manipulation
- Text processing
- File permissions
- Hidden files
- Command-line tools
- Basic cryptography
- Log analysis
- Debugging
- And more!

## 🔒 Security Note

This CTF is designed for educational purposes and runs in an isolated container. All challenges are self-contained and pose no risk to your host system.

## 🙏 Acknowledgments

- Inspired by OverTheWire's Bandit
- Thanks to the CTF community for inspiration and ideas

## ⚠️ Troubleshooting

If you can't connect to the container:
- Ensure Docker Desktop is running
- Check if the container is running: `docker ps`
- Verify port 2222 isn't being used by another service
- Try restarting the container: `docker restart mybandit`

Happy Hacking! 🚀
