<template>
    <div class="page-container">
        <el-card class="box-card">
            <div slot="header" class="clearfix">
                <span class="card-title">个人信息</span>
            </div>
            <el-form label-position="left" :model="form" label-width="80px">
                <el-form-item label="头像" class="avatar-form-item">
                    <div class="avatar-upload-container">
                        <div class="avatar-preview-wrapper">
                            <el-avatar 
                                :size="100" 
                                :src="form.head ? $baseFileUrl + form.head : require('@/assets/head.jpg')"
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
                <el-form-item label="账号">
                    <el-input disabled prefix-icon="el-icon-user" v-model="form.username" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="密码">
                    <el-input type="password" prefix-icon="el-icon-lock" placeholder="请输入密码" v-model="form.password" autocomplete="off" show-password></el-input>
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input prefix-icon="el-icon-s-custom" placeholder="请输入姓名" v-model="form.name" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="性别">
                    <el-radio-group v-model="form.gender">
                        <el-radio :label="1">
                            <i class="el-icon-male" style="color: #409EFF;"></i> 男
                        </el-radio>
                        <el-radio :label="2">
                            <i class="el-icon-female" style="color: #F56C6C;"></i> 女
                        </el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="handleModify" :loading="submitLoading">
                        <i class="el-icon-check"></i> 保存修改
                    </el-button>
                </el-form-item>
            </el-form>
        </el-card>
    </div>
</template>

<script>
import request from '@/utils/request'
import { modifyAdminAPI } from "@/api/admin";
import { mapMutations } from 'vuex'
import { getUserInfoByTokenAPI } from '@/api/system'
export default {
    name: 'Hotely5dWebAdminInfo',

    data() {
        return {
            form: {}, // 表单数据
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
        };
    },

    async mounted() {
        //请求用户信息
        try {
            const result = await getUserInfoByTokenAPI()
            // 将获取到的用户信息赋值给表单数据
            this.form = result.data
        } catch (error) {
            console.error('获取用户信息失败', error)
            this.$message.error('获取用户信息失败，请稍后再试')
        }
    },

    methods: {
        ...mapMutations(['setUser']),
        
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
                    this.form.head = resp.data.filename;
                    
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
        
        async handleModify() {
            this.submitLoading = true;
            try {
                // 调用修改管理员信息的 API
                const res = await modifyAdminAPI(this.form);

                // 显示提示消息
                this.$message({
                    message: res.message,
                    type: res.flag ? "success" : "error",
                });
                
                if (res.flag) {
                    // 更新用户信息
                    this.setUser(this.form)
                    // 刷新页面
                    this.$message({
                        message: '个人信息修改成功，页面将在1秒后刷新',
                        type: 'success'
                    });
                    setTimeout(() => {
                        this.$router.go(0)
                    }, 1000);
                }
            } catch (error) {
                console.error('修改用户信息失败', error);
                this.$message.error('修改用户信息失败，请稍后再试');
            } finally {
                this.submitLoading = false;
            }
        },
    },
};
</script>

<style lang="less" scoped>
.page-container {
    width: 600px;
    margin: 30px auto;
}

.box-card {
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    
    .card-title {
        font-size: 18px;
        font-weight: 700;
        color: #303133;
    }
}

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

.el-form-item {
    margin-bottom: 25px;
}

.el-button {
    padding: 12px 25px;
    border-radius: 4px;
    font-weight: 500;
    transition: all 0.3s ease;
    
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    
    i {
        margin-right: 5px;
    }
}
</style>