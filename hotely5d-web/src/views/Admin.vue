<template>
  <div class="admin-container">
    <!-- 标题区域 -->
    <div class="section-header">
      <h1 class="section-title">管理员管理</h1>
      <div class="section-subtitle">管理系统用户及权限</div>
    </div>
    
    <!-- 搜索和操作区域 -->
    <div class="admin-card">
      <el-form :inline="true" class="search-form" :model="searchForm">
        <el-form-item>
          <el-input 
            placeholder="请输入账号" 
            v-model="searchForm.username"
            prefix-icon="el-icon-user"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-input 
            placeholder="请输入姓名" 
            v-model="searchForm.name"
            prefix-icon="el-icon-s-custom"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button 
            type="primary" 
            @click="handleSearch" 
            icon="el-icon-search"
            class="search-button"
          >查询</el-button>
          <el-button 
            type="success" 
            @click="handleAdd" 
            icon="el-icon-plus"
            class="add-button"
          >新增管理员</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 表格区域 -->
      <div class="table-container">
        <el-table 
          v-loading="listLoading" 
          :data="list" 
          element-loading-text="数据加载中..." 
          border 
          fit 
          highlight-current-row
          :header-cell-style="{ background: '#f5f7fa', color: '#606266', fontWeight: 'bold' }"
          :row-class-name="tableRowClassName"
        >
          <el-table-column align="center" label="ID" prop="id" width="80"></el-table-column>
          
          <el-table-column align="center" label="头像" width="100">
            <template slot-scope="scope">
              <el-avatar 
                :size="40" 
                :src="scope.row.head ? $baseFileUrl + scope.row.head : require('@/assets/head.jpg')"
              ></el-avatar>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="账号" prop="username"></el-table-column>
          <el-table-column align="center" label="姓名" prop="name"></el-table-column>
          
          <el-table-column align="center" label="性别" width="100">
            <template slot-scope="scope">
              <el-tag 
                :type="scope.row.gender == 1 ? 'primary' : 'danger'"
                effect="plain"
                size="medium"
                class="gender-tag"
              >
                <div class="gender-content">
                  <i :class="scope.row.gender == 1 ? 'el-icon-male' : 'el-icon-female'"></i>
                  <span>{{ scope.row.gender == 1 ? '男' : '女' }}</span>
                </div>
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column label="操作" width="200" align="center">
            <template slot-scope="scope">
              <div class="action-buttons">
                <el-button 
                  @click="handleEdit(scope.row)" 
                  type="primary" 
                  size="small" 
                  icon="el-icon-edit"
                  plain
                  class="action-button"
                >编辑</el-button>
                <el-popconfirm 
                  title="确定删除该管理员吗？" 
                  @confirm="deleteCofirm(scope.row)"
                  icon="el-icon-warning"
                  confirm-button-text="确定"
                  cancel-button-text="取消"
                  confirm-button-type="danger"
                >
                  <el-button 
                    type="danger" 
                    size="small" 
                    icon="el-icon-delete" 
                    slot="reference"
                    plain
                    class="action-button"
                  >删除</el-button>
                </el-popconfirm>
              </div>
            </template>
          </el-table-column>
        </el-table>
        
        <!-- 空数据状态 -->
        <div class="empty-state" v-if="list && list.length === 0 && !listLoading">
          <i class="el-icon-user-solid"></i>
          <p>暂无管理员数据</p>
          <el-button type="primary" @click="handleAdd">添加管理员</el-button>
        </div>
        
        <!-- 分页区域 -->
        <el-pagination 
          class="pagination" 
          background 
          @size-change="handleSizeChange" 
          @current-change="handleCurrentChange"
          :current-page="pageNum" 
          :page-sizes="[10, 20, 50]" 
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper" 
          :total="total"
        >
        </el-pagination>
      </div>
    </div>
    
    <!-- 添加/修改的弹框 -->
    <el-dialog 
      :title="dialogTitle" 
      :visible.sync="dialogFormVisible"
      width="500px"
      center
      :close-on-click-modal="false"
      :before-close="handleDialogClose"
    >
      <el-form 
        label-position="right" 
        :model="dialogForm" 
        label-width="80px"
        class="dialog-form"
        :rules="formRules"
        ref="dialogFormRef"
      >
        <el-form-item label="头像" class="avatar-form-item">
          <div class="avatar-upload-container">
            <div class="avatar-preview-wrapper">
              <el-avatar 
                :size="100" 
                :src="dialogForm.head ? $baseFileUrl + dialogForm.head : require('@/assets/head.jpg')"
                class="avatar-preview"
                fit="cover"
              ></el-avatar>
            </div>
            <div class="avatar-controls">
              <input 
                type="file" 
                ref="fileInput" 
                accept="image/*" 
                style="display: none"
                @change="handleFileChange" 
              />
              <el-button 
                type="primary" 
                size="small" 
                icon="el-icon-upload2" 
                plain 
                @click="$refs.fileInput.click()"
              >
                选择头像
              </el-button>
              <div class="upload-tips">
                <p>支持JPG、PNG格式，最大2MB</p>
              </div>
            </div>
          </div>
        </el-form-item>
        
        <el-form-item label="账号" prop="username">
          <el-input 
            placeholder="请输入账号" 
            v-model="dialogForm.username" 
            prefix-icon="el-icon-user"
            autocomplete="off"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input 
            type="password" 
            placeholder="请输入密码" 
            v-model="dialogForm.password" 
            prefix-icon="el-icon-lock"
            autocomplete="off"
            show-password
          ></el-input>
        </el-form-item>
        
        <el-form-item label="姓名" prop="name">
          <el-input 
            placeholder="请输入姓名" 
            v-model="dialogForm.name" 
            prefix-icon="el-icon-s-custom"
            autocomplete="off"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="dialogForm.gender">
            <el-radio :label="1">
              <i class="el-icon-male" style="color: #409EFF;"></i> 男
            </el-radio>
            <el-radio :label="2">
              <i class="el-icon-female" style="color: #F56C6C;"></i> 女
            </el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleDialogClose" plain>取 消</el-button>
        <el-button type="primary" @click="dialogConfirm" :loading="submitLoading">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/utils/request'
import {
  findAdminPageAPI, // 导入查询管理员信息的 API
  addAdminAPI, // 导入新增管理员的 API
  modifyAdminAPI, // 导入修改管理员信息的 API
  removeAdminAPI, // 导入删除管理员的 API
} from "@/api/admin";

export default {
  data() {
    return {
      list: [], // 管理员列表数据
      listLoading: true, // 列表加载状态
      pageSize: 10, // 每页显示条数
      pageNum: 1, // 当前页码
      total: 0, // 总条数
      searchForm: {}, // 搜索表单数据
      dialogTitle: "添加管理员", // 弹框标题，默认为添加
      dialogFormVisible: false, // 弹框显示状态
      dialogForm: {}, // 弹框表单数据
      submitLoading: false, // 提交按钮加载状态
      genderOptions: [ // 性别选项
        {
          label: '男',
          value: 1
        },
        {
          label: '女',
          value: 2
        }
      ],
      // 表单验证规则
      formRules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        name: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        gender: [
          { required: true, message: '请选择性别', trigger: 'change' }
        ]
      }
    };
  },
  created() {
    this.fetchData();
  },
  methods: {
    // 表格行的样式
    tableRowClassName({row, rowIndex}) {
      return rowIndex % 2 === 0 ? 'even-row' : 'odd-row';
    },
    
    // 处理文件选择
    handleFileChange(e) {
      const file = e.target.files[0];
      if (!file) return;
      
      // 验证文件类型和大小
      if (!this.beforeAvatarUpload(file)) {
        return;
      }
      
      // 上传文件
      const formData = new FormData();
      formData.append("photo", file);
      
      this.$message({
        message: '头像上传中，请稍候...',
        type: 'info'
      });
      
      // 使用request模块上传文件
      request.post("/file/uploadPhoto", formData, "form").then((resp) => {
        if (resp.data && resp.data.filename) {
          this.dialogForm.head = resp.data.filename;
          
          this.$message({
            message: '头像上传成功',
            type: 'success'
          });
        } else {
          this.$message.error('头像上传失败，请重试');
        }
      }).catch(error => {
        console.error('头像上传失败', error);
        this.$message.error('头像上传失败，请重试');
      });
    },
    
    // 处理头像上传前的校验
    beforeAvatarUpload(file) {
      const isImage = file.type.startsWith('image/');
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isImage) {
        this.$message.error('只能上传图片文件!');
        return false;
      }
      if (!isLt2M) {
        this.$message.error('图片大小不能超过 2MB!');
        return false;
      }
      return true;
    },
    
    // 处理对话框关闭
    handleDialogClose() {
      this.$confirm('确认关闭？未保存的数据将会丢失', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.dialogFormVisible = false;
        // 完全清空表单数据
        this.$nextTick(() => {
          this.dialogForm = {};
          if (this.$refs.dialogFormRef) {
            this.$refs.dialogFormRef.clearValidate();
            this.$refs.dialogFormRef.resetFields();
          }
          // 重置文件输入
          if (this.$refs.fileInput) {
            this.$refs.fileInput.value = '';
          }
        });
      }).catch(() => {
        // 取消关闭
      });
    },
    
    handleSizeChange(val) {//每页显示条数改变
      this.pageSize = val;
      this.fetchData();
    },
    
    handleCurrentChange(val) {//当前页码改变
      this.pageNum = val;
      this.fetchData();
    },
    
    handleSearch() {//点击搜索按钮
      this.pageNum = 1; // 重置为第一页
      this.fetchData();
    },
    
    async fetchData() {//查询数据
      this.listLoading = true;
      try {
        const response = await findAdminPageAPI(
          this.pageNum,
          this.pageSize,
          this.searchForm
        );
        this.list = response.data.records;
        this.total = response.data.total;
      } catch (error) {
        console.error('获取管理员列表失败', error);
        this.$message.error('获取管理员列表失败');
      } finally {
        this.listLoading = false;
      }
    },
    
    handleAdd() {//点击新增按钮-显示弹框
      // 先完全清空表单数据
      this.dialogForm = {};
      if (this.$refs.dialogFormRef) {
        this.$refs.dialogFormRef.clearValidate();
        this.$refs.dialogFormRef.resetFields();
      }
      // 重置文件输入
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = '';
      }
      
      this.dialogTitle = "新增管理员";
      this.dialogFormVisible = true;
      
      // 设置默认值
      this.$nextTick(() => {
        this.dialogForm = {
          username: '',
          password: '',
          name: '',
          gender: 1,
          head: ''
        };
      });
    },
    
    handleEdit(row) {//点击修改按钮-显示弹框
      // 先完全清空表单数据
      this.dialogForm = {};
      if (this.$refs.dialogFormRef) {
        this.$refs.dialogFormRef.clearValidate();
        this.$refs.dialogFormRef.resetFields();
      }
      // 重置文件输入
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = '';
      }
      
      this.dialogTitle = "修改管理员";
      this.dialogFormVisible = true;
      
      // 使用深拷贝设置表单数据
      this.$nextTick(() => {
        this.dialogForm = JSON.parse(JSON.stringify(row));
      });
    },
    
    async dialogConfirm() {//点击弹框确定按钮
      // 表单验证
      this.$refs.dialogFormRef.validate(async (valid) => {
        if (!valid) {
          return false;
        }
        
        this.submitLoading = true;
        try {
          let res = null;
          if (this.dialogTitle === "新增管理员") {
            res = await addAdminAPI(this.dialogForm);
          } else {
            res = await modifyAdminAPI(this.dialogForm);
          }
          
          this.$message({
            message: res.message,
            type: res.flag ? "success" : "error",
          });
          
          if (res.flag) {
            this.dialogFormVisible = false;
            this.fetchData();
            
            // 操作成功后完全清空表单数据
            this.$nextTick(() => {
              this.dialogForm = {};
              if (this.$refs.dialogFormRef) {
                this.$refs.dialogFormRef.clearValidate();
                this.$refs.dialogFormRef.resetFields();
              }
              // 重置文件输入
              if (this.$refs.fileInput) {
                this.$refs.fileInput.value = '';
              }
            });
          }
        } catch (error) {
          console.error('操作失败', error);
          this.$message.error('操作失败，请重试');
        } finally {
          this.submitLoading = false;
        }
      });
    },
    
    async deleteCofirm(row) {//点击确定删除按钮
      try {
        const res = await removeAdminAPI(row.id);
        this.$message({
          message: res.message,
          type: res.flag ? "success" : "error",
        });
        
        if (res.flag) {
          // 如果当前页只有一条数据且不是第一页，则跳转到上一页
          if (this.list.length === 1 && this.pageNum > 1) {
            this.pageNum -= 1;
          }
          this.fetchData();
        }
      } catch (error) {
        console.error('删除失败', error);
        this.$message.error('删除失败，请重试');
      }
    },
  },
};
</script>

<style lang="less" scoped>
.admin-container {
  padding: 20px;
  
  .section-header {
    background: linear-gradient(135deg, #1E3A8A, #274597);
    color: #fff;
    padding: 25px;
    border-radius: 10px;
    margin-bottom: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    
    .section-title {
      font-size: 24px;
      font-weight: 700;
      margin: 0;
      letter-spacing: 1px;
    }
    
    .section-subtitle {
      font-size: 14px;
      margin-top: 8px;
      color: #ffd700;
      letter-spacing: 0.5px;
    }
  }
  
  .admin-card {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    padding: 20px;
    
    .search-form {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
      
      .el-form-item {
        margin-bottom: 0;
        margin-right: 15px;
      }
      
      .search-button {
        background: #1E3A8A;
        border-color: #1E3A8A;
        transition: all 0.3s;
        
        &:hover {
          background: darken(#1E3A8A, 10%);
          transform: translateY(-2px);
        }
      }
      
      .add-button {
        transition: all 0.3s;
        
        &:hover {
          transform: translateY(-2px);
        }
      }
    }
    
    .table-container {
      position: relative;
      
      .gender-tag {
        padding: 4px 8px;
        border-radius: 4px;
        
        .gender-content {
          display: flex;
          align-items: center;
          justify-content: center;
          
          i {
            margin-right: 4px;
            font-size: 14px;
          }
          
          span {
            line-height: 1;
          }
        }
      }
      
      .empty-state {
        text-align: center;
        padding: 40px 0;
        color: #909399;
        
        i {
          font-size: 60px;
          color: #DCDFE6;
          margin-bottom: 15px;
        }
        
        p {
          font-size: 16px;
          margin-bottom: 20px;
        }
      }
      
      .pagination {
        margin-top: 20px;
        display: flex;
        justify-content: flex-end;
      }
    }
  }
}

.dialog-form {
  .avatar-form-item {
    margin-bottom: 30px;
  }
  
  .avatar-upload-container {
    display: flex;
    align-items: center;
    padding: 20px 0;
    
    .avatar-preview-wrapper {
      display: flex;
      justify-content: center;
      width: 120px;
      
      .avatar-preview {
        border: 3px solid #fff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        transition: all 0.3s;
        
        &:hover {
          transform: scale(1.05);
          box-shadow: 0 3px 12px rgba(0, 0, 0, 0.2);
        }
      }
    }
    
    .avatar-controls {
      flex: 1;
      padding-left: 20px;
      
      .el-button {
        position: relative;
        overflow: hidden;
        margin-bottom: 8px;
        
        &:hover {
          transform: translateY(-2px);
        }
      }
      
      .upload-tips {
        font-size: 12px;
        color: #909399;
        margin-top: 5px;
      }
    }
  }
}

// 表格行样式
/deep/ .even-row {
  background-color: #fafafa;
}

/deep/ .odd-row {
  background-color: #ffffff;
}

// 表格hover样式
/deep/ .el-table__body tr:hover > td {
  background-color: rgba(30, 58, 138, 0.1) !important;
}

.action-buttons {
  display: flex;
  justify-content: center;
  gap: 12px;
  
  .action-button {
    margin: 0;
  }
}
</style>
