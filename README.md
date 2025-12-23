# 酒店管理系统 (Hotel Management System)

[![GitHub license](https://img.shields.io/github/license/Xzb6/hotel-management-system)](https://github.com/Xzb6/hotel-management-system) <!-- 可选的许可证徽章 -->

> 一个基于SpringBoot + Vue.js的现代化、全栈酒店管理解决方案。系统实现了从前台用户预订到后台管理的全业务流程数字化，旨在提升酒店运营效率与客户体验。

## 核心特性
*   **双端分离架构**：清晰的前台用户端与后台管理端，提供差异化的交互体验。
*   **全流程管理**：覆盖客房展示、在线预订、订单处理、入住/退房、留言反馈、公告发布等核心酒店业务。
*   **响应式设计**：前端适配多种屏幕尺寸，确保在桌面和移动设备上均有良好表现。
*   **安全与权限**：基于JWT的接口鉴权，管理员与用户权限分离，保障数据安全。

## 快速开始

### 先决条件

*   **JDK 11+**
*   **Node.js 14+** (及npm)
*   **MySQL 8.0+**
*   **Maven 3.6+**
*   **Git**

### 安装与运行

1.  **克隆项目**
    ```bash
    git clone https://github.com/Xzb6/hotel-management-system.git
    cd hotel-management-system
    ```

2.  **初始化数据库**
    *   使用MySQL客户端执行根目录下的 `hotely5d.sql` 文件，创建数据库和表结构。

3.  **启动后端服务**
    ```bash
    cd hotely5d
    # 可根据实际情况修改 src/main/resources/application.yml 中的数据库连接配置
    mvn clean install
    mvn spring-boot:run
    ```
    *   后端服务默认运行在 `http://localhost:8080`

4.  **启动前端服务**
    ```bash
    cd ../hotely5d-web
    npm install
    npm run serve
    ```
    *   前端开发服务器默认运行在 `http://localhost:8081`
    *   在浏览器中访问此地址即可使用系统。

## 项目结构
hotel-management-system/
├── hotely5d/ # SpringBoot后端项目
│ ├── src/
│ │ ├── main/java/com/hotely5d/ # Java源代码 (Controller, Service, Entity等)
│ │ └── main/resources/ # 配置文件、MyBatis映射文件
│ └── pom.xml # Maven依赖管理
├── hotely5d-web/ # Vue.js前端项目
│ ├── src/
│ │ ├── api/ # 所有后端API请求封装
│ │ ├── assets/ # 静态资源（图片、样式）
│ │ ├── router/ # 前端路由配置
│ │ ├── store/ # Vuex状态管理
│ │ └── views/ # 所有Vue页面组件（分admin和front目录）
│ ├── public/ # 公共HTML模板
│ └── package.json # 前端依赖管理
├── hotely5d.sql # MySQL数据库初始化脚本
├── README.md # 本文件
└── .gitignore # Git忽略文件配置

## 如何贡献
我们欢迎任何形式的贡献！请阅读我们的 [贡献指南](CONTRIBUTING.md) 了解开发工作流和代码规范。

## 许可证
本项目基于 [MIT](LICENSE) 许可证开源。

## 获取帮助

*   [提交 Issue](https://github.com/Xzb6/hotel-management-system/issues) - 报告Bug或提出新特性建议。
*   **讨论区** - 可在GitHub仓库的 [Discussions](https://github.com/Xzb6/hotel-management-system/discussions) 板块发起技术或使用讨论（若已开启）。