<template>
  <div>
    <!-- 头部导航栏 -->
    <div class="navbar-wrapper">
      <el-menu :default-active="activeIndex" router class="el-menu-demo" mode="horizontal" 
        background-color="#1E3A8A" text-color="#fff" active-text-color="#FFD700">
        <div class="nav-container">
          <!-- 网站logo和标题 -->
          <div class="logo-container">
            <el-menu-item style="height: 70px; padding: 0 15px; border: none;" index="/front">
              <div class="logo-wrapper">
                <div class="logo-image-container">
                  <img src="@/assets/luxury-hotel-logo.svg" class="logo-image" />
                </div>
                <div class="brand-text">
                  <span class="logo-text">{{ $sysTitle }}</span>
                  <span class="logo-tagline">尊享舒适与优雅</span>
                </div>
              </div>
            </el-menu-item>
          </div>
          
          <!-- 导航链接 -->
          <div class="nav-links">
            <el-menu-item index="/front" class="nav-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-home"></i>
                <span>首页</span>
              </div>
            </el-menu-item>
            <el-menu-item v-if="!token" index='/login' class="nav-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-sign-in-alt"></i>
                <span>登录</span>
              </div>
            </el-menu-item>
            <el-menu-item v-if="!token" index='/register' class="nav-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-user-plus"></i>
                <span>注册</span>
              </div>
            </el-menu-item>
            <el-menu-item index="/front/notice" class="nav-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-bullhorn"></i>
                <span>系统公告</span>
              </div>
            </el-menu-item>
            <el-menu-item index="/front/message" class="nav-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-comments"></i>
                <span>用户留言</span>
              </div>
            </el-menu-item>
            <el-menu-item @click="handleAppointmentClick" class="nav-item highlight-item">
              <div class="menu-item-content">
                <i class="nav-icon fas fa-concierge-bell"></i>
                <span>预约入住</span>
              </div>
            </el-menu-item>
          </div>
          
          <!-- 用户菜单 -->
          <div class="user-menu">
            <el-submenu v-if="token" index="#" class="user-submenu">
              <!-- 用户头像和名称 -->
              <template slot="title">
                <div class="user-info">
                  <el-avatar v-if="head" :src="$baseFileUrl+head" class="user-avatar"></el-avatar>
                  <img v-else src="@/assets/head.jpg" class="user-avatar" />
                  <span class="username">{{ user?.name }}</span>
                  <i class="el-icon-arrow-down user-arrow"></i>
                </div>
              </template>
              <!-- 用户相关链接 -->
              <el-menu-item index="/front/userInfo">
                <div class="submenu-item-content">
                  <i class="fas fa-user menu-icon"></i>
                  <span>个人信息</span>
                </div>
              </el-menu-item>
              <el-menu-item index="/front/appointment">
                <div class="submenu-item-content">
                  <i class="fas fa-calendar-check menu-icon"></i>
                  <span>我的预约</span>
                </div>
              </el-menu-item>
              <el-menu-item index="/front/orders">
                <div class="submenu-item-content">
                  <i class="fas fa-receipt menu-icon"></i>
                  <span>我的入住</span>
                </div>
              </el-menu-item>
              <el-menu-item index="#" @click.native="logout">
                <div class="submenu-item-content">
                  <i class="fas fa-sign-out-alt menu-icon"></i>
                  <span>退出登录</span>
                </div>
              </el-menu-item>
            </el-submenu>
          </div>
        </div>
      </el-menu>
    </div>
    
    <!-- 中间区域 -->
    <div class="content">
      <router-view />
    </div>
    
    <!-- 底部版权信息 -->
<!--    <div class="footer">-->
<!--      <div class="footer-content">-->
<!--        <p>Copyright © {{ year }} {{ $sysTitle }}</p>-->
<!--        <p>为您提供最优质的住宿体验</p>-->
<!--      </div>-->
<!--    </div>-->
  </div>
</template>
    
<script>
import { mapState, mapMutations } from 'vuex'
import { removeToken } from '@/utils/auth'
export default {
  name: "Index",

  data() {
    return {
      activeIndex: "1",
      head: '',
      year: ''
    };
  },

  async mounted() {
    // 获取当前年份
    this.year = new Date().getFullYear();
    // 获取用户头像
    this.head = this.user?.head;
    // 加载FontAwesome图标
    this.loadFontAwesome();
  },

  computed: {
    ...mapState(['user', 'role', 'token'])
  },

  methods: {
    ...mapMutations(['setUser', 'setRole', 'setToken']),
    
    // 加载FontAwesome图标
    loadFontAwesome() {
      const link = document.createElement('link');
      link.setAttribute('rel', 'stylesheet');
      link.setAttribute('href', 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
      document.head.appendChild(link);
    },
    
    // 用户退出登录
    logout() {
      this.$confirm('确定退出吗?', '温馨提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 移除token
        removeToken()
        // 清空用户信息
        this.setUser({})
        // 清空token
        this.setToken('')
        // 跳转至首页
        this.$router.replace('/front')

      }).catch(() => { });
    },
    
    // 处理预约入住点击事件
    handleAppointmentClick() {
      this.$router.push('/front/room'); // 跳转到预约入住页面
    }
  },
}
</script>
    
<style lang="less" scoped>
.navbar-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 999;
}

.el-menu-demo {
  box-shadow: 0 3px 16px rgba(0, 0, 0, 0.15);
  height: 70px;
  border: none;
  background-image: linear-gradient(to right, #1E3A8A, #274597);
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto;
  height: 100%;
  padding: 0 20px;
}

/* 网站logo和品牌名称 */
.logo-container {
  display: flex;
  align-items: center;
  height: 70px;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 5px;
}

.logo-image-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 36px;
  width: 36px;
  margin-right: 12px;
}

.logo-image {
  max-height: 100%;
  max-width: 100%;
  object-fit: contain;
}

.brand-text {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 40px;
}

.logo-text {
  font-size: 16px;
  font-weight: 600;
  color: white;
  line-height: 1.2;
  background-image: linear-gradient(to right, #fff, #FFD700);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 0 2px rgba(0, 0, 0, 0.1);
  display: block;
}

.logo-tagline {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1;
  margin-top: 3px;
  display: block;
}

/* 导航链接 */
.nav-links {
  display: flex;
  align-items: center;
  flex: 1;
  justify-content: center;
}

.nav-item {
  height: 70px;
  line-height: 70px;
  padding: 0 20px;
}

.menu-item-content, .submenu-item-content {
  display: flex;
  align-items: center;
  height: 100%;
}

.nav-icon, .menu-icon {
  margin-right: 6px;
}

.highlight-item {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  margin: 0 5px;
}

.highlight-item:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* 用户菜单 */
.user-menu {
  display: flex;
  align-items: center;
  height: 70px;
}

.user-submenu {
  height: 70px;
  line-height: 70px;
}

/* 覆盖el-submenu默认样式 */
/deep/ .el-submenu__title {
  height: 70px;
  line-height: 70px;
  padding: 0;
  border: none;
}

/deep/ .el-submenu__icon-arrow {
  display: none;
}

.user-info {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 10px;
  transition: all 0.3s;
  border-radius: 4px;
}

.user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
  cursor: pointer;
}

.user-avatar {
  height: 36px;
  width: 36px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.7);
  margin-right: 8px;
  object-fit: cover;
  transition: all 0.3s;
}

.user-info:hover .user-avatar {
  transform: scale(1.05);
  border-color: #FFD700;
}

.username {
  margin-right: 4px;
  max-width: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #ffffff;
  font-size: 14px;
  transition: all 0.3s;
}

.user-arrow {
  font-size: 12px;
  margin-left: 4px;
  color: #ffffff;
  transition: all 0.3s;
}

.user-info:hover .user-arrow {
  transform: rotate(180deg);
}

/* 内容区域 */
.content {
  min-height: calc(100vh - 70px - 80px);
  padding-top: 70px;
  padding-bottom: 0;
  background-color: #f5f7fa;
  overflow-x: hidden;
}

/* 底部区域 */
.footer {
  background-color: #1E293B;
  color: white;
  text-align: center;
  padding: 25px 0;
  margin-top: 0;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.footer p {
  margin: 5px 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

@media screen and (max-width: 768px) {
  .nav-container {
    flex-wrap: wrap;
    padding: 0 10px;
  }
  
  .nav-links {
    order: 3;
    width: 100%;
    justify-content: flex-start;
    overflow-x: auto;
    overflow-y: hidden;
    
    /* 隐藏水平滚动条 */
    &::-webkit-scrollbar {
      height: 0;
      display: none;
    }
    scrollbar-width: none;
  }
  
  .nav-item {
    padding: 0 10px;
  }
  
  .logo-text {
    font-size: 16px;
  }
  
  .user-menu {
    order: 2;
    margin-left: auto;
  }
  
  .user-info {
    padding: 0 5px;
  }
  
  .user-info .username {
    display: none;
  }

  .user-avatar {
    margin-right: 0;
  }

  .user-arrow {
    margin-left: 2px;
  }
}
</style>
