<template>
  <div class="room-container">
    <!-- 标题区域 -->
    <div class="section-header">
      <h1 class="section-title">房间管理</h1>
      <div class="section-subtitle">管理酒店所有房间信息及状态</div>
    </div>
    
    <!-- 搜索和操作区域 -->
    <div class="room-card">
      <el-form :inline="true" class="search-form" :model="searchForm">
        <el-form-item>
          <el-input 
            placeholder="请输入房间号" 
            v-model="searchForm.roomNum" 
            prefix-icon="el-icon-office-building"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-select 
            v-model="searchForm.categoryId" 
            placeholder="请选择房型" 
            clearable
            class="custom-select"
          >
            <el-option 
              v-for="item in categoryList" 
              :key="item.id" 
              :label="item.categoryName" 
              :value="item.id"
            >
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-select 
            v-model="searchForm.status" 
            placeholder="请选择状态" 
            clearable
            class="custom-select"
          >
            <el-option 
              v-for="item in statusList" 
              :key="item.value" 
              :label="item.label" 
              :value="item.value"
            >
              <span :style="{color: item.value === 1 ? '#67C23A' : '#F56C6C'}">
                <i :class="item.value === 1 ? 'el-icon-check' : 'el-icon-close'"></i>
                {{ item.label }}
              </span>
            </el-option>
          </el-select>
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
          >新增房间</el-button>
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
          style="width: 100%"
        >
          <el-table-column align="center" label="ID" prop="id" width="70"></el-table-column>
          <el-table-column align="center" label="房间号" prop="roomNum" min-width="120">
            <template slot-scope="scope">
              <el-tag type="primary" effect="plain" class="room-number">
                {{ scope.row.roomNum }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="房型" prop="category.categoryName" min-width="150"></el-table-column>
          
          <el-table-column align="center" label="状态" width="120">
            <template slot-scope="scope">
              <el-tag 
                :type="scope.row.status == 1 ? 'success' : 'danger'"
                effect="light"
                size="medium"
              >
                <i :class="scope.row.status == 1 ? 'el-icon-check' : 'el-icon-close'"></i>
                {{ scope.row.status == 1 ? '正常' : '停用' }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column label="操作" width="180" align="center">
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
                  title="确定删除该房间吗？" 
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
          <i class="el-icon-office-building"></i>
          <p>暂无房间数据</p>
          <el-button type="primary" @click="handleAdd">添加房间</el-button>
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
        <el-form-item label="房间号" prop="roomNum">
          <el-input 
            placeholder="请输入房间号" 
            v-model="dialogForm.roomNum" 
            prefix-icon="el-icon-office-building"
            autocomplete="off"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="房型" prop="categoryId">
          <el-select 
            v-model="dialogForm.categoryId" 
            placeholder="请选择房型"
            style="width: 100%"
          >
            <el-option 
              v-for="item in categoryList" 
              :key="item.id" 
              :label="item.categoryName" 
              :value="item.id"
            >
            </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="dialogForm.status">
            <el-radio :label="1">
              <i class="el-icon-check" style="color: #67C23A;"></i> 正常
            </el-radio>
            <el-radio :label="2">
              <i class="el-icon-close" style="color: #F56C6C;"></i> 停用
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
import {
  findRoomPageAPI,
  addRoomAPI,
  modifyRoomAPI,
  removeRoomAPI,
} from "@/api/room";
import { findAllCategoryAPI } from '@/api/category'
export default {
  data() {
    return {
      list: [],
      listLoading: true,
      pageSize: 10,
      pageNum: 1,
      total: 0,
      searchForm: {},
      dialogTitle: "添加房间",
      dialogFormVisible: false,
      dialogForm: {},
      categoryList: [],
      submitLoading: false, // 提交按钮加载状态
      statusList: [
        { label: '正常', value: 1 },
        { label: '停用', value: 2 },
      ],
      // 表单验证规则
      formRules: {
        roomNum: [
          { required: true, message: '请输入房间号', trigger: 'blur' },
          { pattern: /^\d{3,4}$/, message: '房间号应为3-4位数字', trigger: 'blur' }
        ],
        categoryId: [
          { required: true, message: '请选择房型', trigger: 'change' }
        ],
        status: [
          { required: true, message: '请选择状态', trigger: 'change' }
        ]
      }
    };
  },
  created() {
    this.fetchData();
    this.getCategoryList()
  },
  methods: {
    // 表格行的样式
    tableRowClassName({row, rowIndex}) {
      return rowIndex % 2 === 0 ? 'even-row' : 'odd-row';
    },
    
    // 处理对话框关闭
    handleDialogClose() {
      this.$confirm('确认关闭？未保存的数据将会丢失', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.dialogFormVisible = false;
        // 重置表单
        if (this.$refs.dialogFormRef) {
          this.$refs.dialogFormRef.resetFields();
        }
      }).catch(() => {
        // 取消关闭
      });
    },
    
    async getCategoryList() {
      try {
        const { data } = await findAllCategoryAPI();
        this.categoryList = data;
      } catch (error) {
        console.error('获取房型列表失败', error);
        this.$message.error('获取房型列表失败');
      }
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
        const response = await findRoomPageAPI(
          this.pageNum,
          this.pageSize,
          this.searchForm
        );
        this.list = response.data.records;
        this.total = response.data.total;
      } catch (error) {
        console.error('获取房间列表失败', error);
        this.$message.error('获取房间列表失败');
      } finally {
        this.listLoading = false;
      }
    },
    
    handleAdd() {//点击新增按钮-显示弹框
      this.dialogTitle = "新增房间";
      this.dialogFormVisible = true;
      
      // 确保categoryList已加载
      if (this.categoryList && this.categoryList.length > 0) {
        this.dialogForm = {
          categoryId: this.categoryList[0].id,
          status: 1 // 默认状态为正常
        };
      } else {
        this.dialogForm = {
          status: 1
        };
      }
      
      // 重置表单验证
      this.$nextTick(() => {
        if (this.$refs.dialogFormRef) {
          this.$refs.dialogFormRef.resetFields();
        }
      });
    },
    
    handleEdit(row) {//点击修改按钮-显示弹框
      this.dialogTitle = "修改房间";
      this.dialogFormVisible = true;
      this.dialogForm = { ...row };
      
      // 重置表单验证
      this.$nextTick(() => {
        if (this.$refs.dialogFormRef) {
          this.$refs.dialogFormRef.resetFields();
        }
      });
    },
    
    async dialogConfirm() {//点击弹框确定按钮
      this.$refs.dialogFormRef.validate(async (valid) => {
        if (!valid) {
          return false;
        }
        
        this.submitLoading = true;
        try {
          let res = null;
          if (this.dialogTitle === "新增房间") {
            res = await addRoomAPI(this.dialogForm);
          } else {
            res = await modifyRoomAPI(this.dialogForm);
          }
          
          this.$message({
            message: res.message,
            type: res.flag ? "success" : "error",
          });
          
          if (res.flag) {
            this.dialogFormVisible = false;
            this.fetchData();
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
        const res = await removeRoomAPI(row.id);
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
.room-container {
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
  
  .room-card {
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    padding: 20px;
    
    .search-form {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      margin-bottom: 20px;
      
      .el-form-item {
        margin-bottom: 10px;
        margin-right: 15px;
      }
      
      .custom-select {
        width: 140px;
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
      overflow-x: hidden; // 防止水平滚动条
      
      .room-number {
        font-weight: bold;
        font-size: 14px;
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
  .el-select {
    width: 100%;
  }
  
  .el-radio-group {
    display: flex;
    
    .el-radio {
      margin-right: 20px;
      
      i {
        margin-right: 4px;
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
