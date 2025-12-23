<template>
  <div class="app-container">
  <!-- Vue Router 视图容器 -->
    <router-view>
  <!-- 路由视图将渲染在这里 -->
    </router-view>
  </div>
</template>

<script>
export default {
  name: 'VueTemplateApp',  // 组件名称为 VueTemplateApp

  data() {
    return {
      
    };
  },

  mounted() {
    //设置网页Title
    document.getElementsByTagName("title")[0].innerText = this.$sysTitle
  },

  methods: {
    
  },
};
</script>

<style lang="less">
/* 全局样式，去除滚动条 */
html, body {
  overflow-x: hidden;
  overflow-y: auto;
  
  /* 隐藏滚动条但保留功能 - Webkit浏览器 */
  &::-webkit-scrollbar {
    width: 0;
    height: 0;
    display: none;
  }
  
  /* IE, Edge 等浏览器 */
  -ms-overflow-style: none;
  
  /* Firefox */
  scrollbar-width: none;
  
  margin: 0;
  padding: 0;
}

/* 确保所有内容区域也不显示滚动条 */
.el-main, .section, .content, .page-container, 
.el-card__body, .orders-add-container, .home {
  overflow-x: hidden;
  
  /* 隐藏滚动条但保留功能 - Webkit浏览器 */
  &::-webkit-scrollbar {
    width: 0;
    height: 0;
    display: none;
  }
  
  /* IE, Edge 等浏览器 */
  -ms-overflow-style: none;
  
  /* Firefox */
  scrollbar-width: none;
}
</style>

<style lang="less" scoped>
.app-container{
  // 根容器的样式，可设置背景颜色等
  // background-color: #f2f4fb;
}
</style>