<template>
  <div class="category-container">
    <!-- 标题区域 -->
    <div class="section-header">
      <h1 class="section-title">房型管理</h1>
      <div class="section-subtitle">管理酒店各类型房间信息</div>
    </div>
    
    <!-- 搜索和操作区域 -->
    <div class="category-card">
      <el-form :inline="true" class="search-form" :model="searchForm">
        <el-form-item>
          <el-input 
            placeholder="请输入房间类型" 
            v-model="searchForm.categoryName"
            prefix-icon="el-icon-house"
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
          >新增房型</el-button>
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
          <el-table-column align="center" label="房间类型" prop="categoryName" min-width="120"></el-table-column>
          
          <el-table-column align="center" label="房间图片" width="120">
            <template slot-scope="scope">
              <el-image 
                :src="scope.row.photo ? $baseFileUrl + scope.row.photo : ''" 
                style="width: 80px; height: 60px; border-radius: 4px;"
                fit="cover"
                :preview-src-list="scope.row.photo ? [$baseFileUrl + scope.row.photo] : []"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="价格" min-width="100">
            <template slot-scope="scope">
              <span class="price">¥ {{ scope.row.price }}</span>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="可住人数" prop="liveNum" width="100">
            <template slot-scope="scope">
              <el-tag type="info" effect="plain">
                <i class="el-icon-user"></i> {{ scope.row.liveNum }} 人
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="床位数" prop="bedNum" width="100">
            <template slot-scope="scope">
              <el-tag type="warning" effect="plain">
                <i class="el-icon-office-building"></i> {{ scope.row.bedNum }} 张
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="面积" prop="area" width="100">
            <template slot-scope="scope">
              <span>{{ scope.row.area }} m²</span>
            </template>
          </el-table-column>
          
          <el-table-column align="center" label="介绍" prop="introduce" min-width="200">
            <template slot-scope="scope">
              <el-tooltip :content="scope.row.introduce" placement="top" :disabled="!scope.row.introduce">
                <span class="introduce-text">{{ scope.row.introduce || '暂无介绍' }}</span>
              </el-tooltip>
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
                  title="确定删除该房型吗？" 
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
          <i class="el-icon-house"></i>
          <p>暂无房型数据</p>
          <el-button type="primary" @click="handleAdd">添加房型</el-button>
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
      width="600px"
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
        <el-form-item label="房型名称" prop="categoryName">
          <el-input 
            placeholder="请输入房间类型" 
            v-model="dialogForm.categoryName" 
            prefix-icon="el-icon-house"
            autocomplete="off"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="房间图片" prop="photo" class="photo-form-item">
          <div class="photo-upload-container">
            <div class="photo-preview-wrapper">
              <el-image 
                :src="dialogForm.photo ? $baseFileUrl + dialogForm.photo : ''" 
                class="photo-preview"
                fit="cover"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
            </div>
            <div class="photo-controls">
              <el-upload
                class="photo-uploader"
                action="#"
                :http-request="uploadFile"
                :show-file-list="false"
                :file-list="fileList"
                accept="image/*"
              >
                <el-button type="primary" size="small" icon="el-icon-upload2" plain>
                  选择图片
                </el-button>
              </el-upload>
              <div class="upload-tips">
                <p>支持JPG、PNG格式，建议尺寸1080×720，最大2MB</p>
              </div>
            </div>
          </div>
        </el-form-item>
        
        <div class="form-row">
          <el-form-item label="价格" prop="price" class="half-width">
            <el-input 
              type="number" 
              placeholder="请输入价格" 
              v-model="dialogForm.price" 
              prefix-icon="el-icon-money"
              autocomplete="off"
            >
              <template slot="append">元/晚</template>
            </el-input>
          </el-form-item>
          
          <el-form-item label="面积" prop="area" class="half-width">
            <el-input 
              type="number" 
              placeholder="请输入面积" 
              v-model="dialogForm.area" 
              prefix-icon="el-icon-full-screen"
              autocomplete="off"
            >
              <template slot="append">m²</template>
            </el-input>
          </el-form-item>
        </div>
        
        <div class="form-row">
          <el-form-item label="可住人数" prop="liveNum" class="half-width">
            <el-input-number 
              v-model="dialogForm.liveNum" 
              :min="1" 
              :max="10"
              controls-position="right"
              placeholder="请输入可住人数"
            ></el-input-number>
          </el-form-item>
          
          <el-form-item label="床位数" prop="bedNum" class="half-width">
            <el-input-number 
              v-model="dialogForm.bedNum" 
              :min="1" 
              :max="5"
              controls-position="right"
              placeholder="请输入床位数"
            ></el-input-number>
          </el-form-item>
        </div>
        
        <el-form-item label="房型介绍" prop="introduce">
          <el-input 
            type="textarea" 
            :rows="4"
            placeholder="请输入房型介绍信息" 
            v-model="dialogForm.introduce" 
            maxlength="200"
            show-word-limit
            autocomplete="off"
          ></el-input>
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
  findCategoryPageAPI,
  addCategoryAPI,
  modifyCategoryAPI,
  removeCategoryAPI,
} from "@/api/category";
import request from '@/utils/request'
export default {
  data() {
    return {
      list: [],
      listLoading: true,
      pageSize: 10,
      pageNum: 1,
      total: 0,
      searchForm: {},
      dialogTitle: "添加房型",
      dialogFormVisible: false,
      dialogForm: {},
      fileList: [],
      submitLoading: false, // 提交按钮加载状态
      // 表单验证规则
      formRules: {
        categoryName: [
          { required: true, message: '请输入房型名称', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        photo: [
          { required: true, message: '请上传房间图片', trigger: 'change' }
        ],
        price: [
          { required: true, message: '请输入价格', trigger: 'blur' },
          { type: 'number', message: '价格必须为数字', trigger: 'blur', transform: value => Number(value) },
          { validator: (rule, value, callback) => {
              if (value && (value <= 0 || value > 10000)) {
                callback(new Error('价格必须大于0且不超过10000'));
              } else {
                callback();
              }
            }, 
            trigger: 'blur' 
          }
        ],
        liveNum: [
          { required: true, message: '请输入可住人数', trigger: 'blur' },
          { type: 'number', message: '可住人数必须为数字', trigger: 'blur' }
        ],
        bedNum: [
          { required: true, message: '请输入床位数', trigger: 'blur' },
          { type: 'number', message: '床位数必须为数字', trigger: 'blur' }
        ],
        area: [
          { required: true, message: '请输入面积', trigger: 'blur' },
          { type: 'number', message: '面积必须为数字', trigger: 'blur', transform: value => Number(value) }
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
          this.fileList = [];
          if (this.$refs.dialogFormRef) {
            this.$refs.dialogFormRef.clearValidate();
            this.$refs.dialogFormRef.resetFields();
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
        const response = await findCategoryPageAPI(
          this.pageNum,
          this.pageSize,
          this.searchForm
        );
        this.list = response.data.records;
        this.total = response.data.total;
      } catch (error) {
        console.error('获取房型列表失败', error);
        this.$message.error('获取房型列表失败');
      } finally {
        this.listLoading = false;
      }
    },
    
    handleAdd() {//点击新增按钮-显示弹框
      // 先完全清空表单数据
      this.dialogForm = {};
      this.fileList = [];
      if (this.$refs.dialogFormRef) {
        this.$refs.dialogFormRef.clearValidate();
        this.$refs.dialogFormRef.resetFields();
      }
      
      this.dialogTitle = "新增房型";
      this.dialogFormVisible = true;
      
      // 设置默认值
      this.$nextTick(() => {
        this.dialogForm = {
          categoryName: '',
          photo: '',
          price: null,
          liveNum: 2,
          bedNum: 1,
          area: null,
          introduce: ''
        };
      });
    },
    
    handleEdit(row) {//点击修改按钮-显示弹框
      // 先完全清空表单数据
      this.dialogForm = {};
      this.fileList = [];
      if (this.$refs.dialogFormRef) {
        this.$refs.dialogFormRef.clearValidate();
        this.$refs.dialogFormRef.resetFields();
      }
      
      this.dialogTitle = "修改房型";
      this.dialogFormVisible = true;
      
      // 使用深拷贝设置表单数据
      this.$nextTick(() => {
        this.dialogForm = JSON.parse(JSON.stringify(row));
        
        // 转换为数字类型，确保输入框正常显示
        this.dialogForm.price = Number(this.dialogForm.price);
        this.dialogForm.liveNum = Number(this.dialogForm.liveNum);
        this.dialogForm.bedNum = Number(this.dialogForm.bedNum);
        this.dialogForm.area = Number(this.dialogForm.area);
        
        this.fileList = row.photo ? [{
          name: this.dialogForm.photo,
          url: this.$baseFileUrl + this.dialogForm.photo
        }] : [];
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
          if (this.dialogTitle === "新增房型") {
            res = await addCategoryAPI(this.dialogForm);
          } else {
            res = await modifyCategoryAPI(this.dialogForm);
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
              this.fileList = [];
              if (this.$refs.dialogFormRef) {
                this.$refs.dialogFormRef.clearValidate();
                this.$refs.dialogFormRef.resetFields();
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
        const res = await removeCategoryAPI(row.id);
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
    
    uploadFile(item) {
      const file = item.file;
      
      // 验证文件类型和大小
      if (!this.validateFile(file)) {
        return;
      }
      
      const form = new FormData(); 
      form.append("photo", file);
      
      this.$message({
        message: '图片上传中，请稍候...',
        type: 'info'
      });
      
      request.post("/file/uploadPhoto", form, "form").then((resp) => {
        if (resp.data && resp.data.filename) {
          this.dialogForm.photo = resp.data.filename;
          this.fileList = [{
            name: this.dialogForm.photo,
            url: this.$baseFileUrl + this.dialogForm.photo
          }];
          
          this.$message({
            message: '图片上传成功',
            type: 'success'
          });
        } else {
          this.$message.error('图片上传失败，请重试');
        }
      }).catch(error => {
        console.error('图片上传失败', error);
        this.$message.error('图片上传失败，请重试');
      });
    },
    
    validateFile(file) {
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
    }
  },
};
</script>

<style lang="less" scoped>
.category-container {
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
  
  .category-card {
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
      
      .price {
        font-weight: bold;
        color: #f56c6c;
      }
      
      .introduce-text {
        display: inline-block;
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      
      .image-error {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100%;
        background: #f5f7fa;
        color: #909399;
        font-size: 20px;
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
  .form-row {
    display: flex;
    margin: 0 -10px;
    
    .half-width {
      width: 50%;
      padding: 0 10px;
    }
  }
  
  .photo-form-item {
    margin-bottom: 30px;
  }
  
  .photo-upload-container {
    display: flex;
    align-items: center;
    padding: 20px 0;
    
    .photo-preview-wrapper {
      width: 160px;
      height: 120px;
      
      .photo-preview {
        width: 100%;
        height: 100%;
        border: 3px solid #fff;
        border-radius: 4px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        transition: all 0.3s;
        
        &:hover {
          transform: scale(1.05);
          box-shadow: 0 3px 12px rgba(0, 0, 0, 0.2);
        }
      }
    }
    
    .photo-controls {
      flex: 1;
      padding-left: 20px;
      
      .photo-uploader {
        margin-bottom: 8px;
        
        /deep/ .el-button {
          position: relative;
          overflow: hidden;
          
          &:hover {
            transform: translateY(-2px);
          }
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
