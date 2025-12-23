<template>
    <div class="profile-container">
        <div class="profile-card">
            <div class="section-header">
                <h1 class="section-title">个人信息</h1>
                <div class="section-subtitle">管理您的个人资料信息</div>
            </div>
            
            <div class="profile-content">
                <div class="profile-avatar">
                    <div class="avatar-container">
                        <img 
                            :src="form.head ? $baseFileUrl + form.head : require('@/assets/head.jpg')" 
                            alt="用户头像"
                            class="avatar-image" 
                        />
                        <div class="avatar-overlay">
                            <i class="fas fa-camera"></i>
                            <span>更换头像</span>
                        </div>
                        <input 
                            type="file" 
                            class="avatar-input" 
                            @change="handleAvatarChange" 
                            accept="image/*"
                        />
                    </div>
                    <div class="avatar-username">{{ form.username || '尊贵会员' }}</div>
                </div>
                
                <div class="profile-form">
                    <el-form :model="form" label-position="top" label-width="100px" class="user-form">
                        <div class="form-row">
                            <el-form-item label="账号">
                                <el-input 
                                    disabled 
                                    placeholder="您的登录账号" 
                                    v-model="form.username" 
                                    prefix-icon="fas fa-user"
                                    class="form-input"
                                ></el-input>
                            </el-form-item>
                            
                            <el-form-item label="密码">
                                <el-input 
                                    type="password" 
                                    placeholder="您的账号密码" 
                                    v-model="form.password" 
                                    prefix-icon="fas fa-lock"
                                    show-password
                                    class="form-input"
                                ></el-input>
                            </el-form-item>
                        </div>
                        
                        <div class="form-row">
                            <el-form-item label="姓名">
                                <el-input 
                                    placeholder="您的真实姓名" 
                                    v-model="form.name" 
                                    prefix-icon="fas fa-id-card"
                                    class="form-input"
                                ></el-input>
                            </el-form-item>
                            
                            <el-form-item label="性别">
                                <el-select 
                                    v-model="form.gender" 
                                    placeholder="请选择性别"
                                    class="form-input"
                                    popper-class="gender-dropdown"
                                >
                                    <el-option 
                                        v-for="item in genderOptions" 
                                        :key="item.value" 
                                        :label="item.label" 
                                        :value="item.value"
                                    >
                                        <span style="float: left">
                                            <i :class="item.value === 1 ? 'fas fa-mars' : 'fas fa-venus'" 
                                               :style="{ color: item.value === 1 ? '#409EFF' : '#FF6B6B' }"></i>
                                            {{ item.label }}
                                        </span>
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </div>
                        
                        <div class="form-row">
                            <el-form-item label="手机号码">
                                <el-input 
                                    placeholder="您的联系电话" 
                                    v-model="form.phone" 
                                    prefix-icon="fas fa-mobile-alt"
                                    class="form-input"
                                ></el-input>
                            </el-form-item>
                            
                            <el-form-item label="身份证号">
                                <el-input 
                                    placeholder="您的身份证号码" 
                                    v-model="form.idcard" 
                                    prefix-icon="fas fa-id-card"
                                    class="form-input"
                                ></el-input>
                            </el-form-item>
                        </div>
                        
                        <div class="form-footer">
                            <el-form-item>
                                <el-button type="primary" @click="handleModify" class="submit-button">
                                    <i class="fas fa-save"></i> 保存修改
                                </el-button>
                            </el-form-item>
                        </div>
                    </el-form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import request from '@/utils/request'
import { modifyMemberAPI } from "@/api/member";
import { mapMutations } from 'vuex'
import { getUserInfoByTokenAPI } from '@/api/system'
export default {
    name: 'Hotely5dWebMemberInfo',

    data() {
        return {
            genderOptions: [
                {
                    label: '男',
                    value: 1
                },
                {
                    label: '女',
                    value: 2
                }
            ],
            form: {},
            fileList: []
        };
    },

    async mounted() {
        // 加载FontAwesome图标
        this.loadFontAwesome();
        
        // 请求用户信息
        try {
            const result = await getUserInfoByTokenAPI();
            this.form = result.data;
            if (this.form.head) {
                this.fileList = [{
                    name: this.form.head,
                    url: this.$baseFileUrl + this.form.head
                }];
            }
        } catch (error) {
            console.error('获取用户信息失败', error);
            this.$message.error('获取用户信息失败，请稍后再试');
        }
    },

    methods: {
        ...mapMutations(['setUser']),
        
        // 加载FontAwesome图标
        loadFontAwesome() {
            if (!document.querySelector('link[href*="font-awesome"]')) {
                const link = document.createElement('link');
                link.setAttribute('rel', 'stylesheet');
                link.setAttribute('href', 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
                document.head.appendChild(link);
            }
        },

        async handleModify() {
            // 验证表单
            if (!this.validateForm()) {
                this.$message({
                    message: '请完善所有必填信息',
                    type: 'warning'
                });
                return;
            }

            try {
                const res = await modifyMemberAPI(this.form);
                
                this.$message({
                    message: res.message,
                    type: res.flag ? "success" : "error",
                });
                
                if (res.flag) {
                    this.setUser(this.form);
                    this.$message({
                        message: '个人信息修改成功，页面将在1秒后刷新',
                        type: 'success'
                    });
                    setTimeout(() => {
                        this.$router.go(0);
                    }, 1000);
                }
            } catch (error) {
                console.error('修改用户信息失败', error);
                this.$message.error('修改用户信息失败，请稍后再试');
            }
        },

        validateForm() {
            const form = this.form;
            const requiredFields = ['username', 'password', 'name', 'gender', 'phone', 'idcard'];
            for (let field of requiredFields) {
                if (!form[field]) {
                    return false;
                }
            }
            return true;
        },
        
        // 处理头像选择变更
        handleAvatarChange(e) {
            const file = e.target.files[0];
            if (!file) return;
            
            // 验证文件类型和大小
            const isImage = file.type.startsWith('image/');
            const isLt2M = file.size / 1024 / 1024 < 2;
            
            if (!isImage) {
                this.$message.error('只能上传图片文件!');
                return;
            }
            if (!isLt2M) {
                this.$message.error('图片大小不能超过 2MB!');
                return;
            }
            
            // 上传文件
            const formData = new FormData();
            formData.append("photo", file);
            
            this.$message({
                message: '头像上传中，请稍候...',
                type: 'info'
            });
            
            request.post("/file/uploadPhoto", formData, "form").then((resp) => {
                if (resp.data && resp.data.filename) {
                    this.form.head = resp.data.filename;
                    this.fileList = [{
                        name: this.form.head,
                        url: this.$baseFileUrl + this.form.head
                    }];
                    
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
        }
    },
};
</script>

<style lang="less" scoped>
.profile-container {
    width: 900px;
    margin: 30px auto;
    font-family: 'Arial', sans-serif;
}

.profile-card {
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 6px 30px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.section-header {
    background: linear-gradient(135deg, #1E3A8A, #274597);
    color: #fff;
    padding: 25px;
    text-align: center;
    
    .section-title {
        font-size: 28px;
        font-weight: 700;
        margin: 0;
        letter-spacing: 1px;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }
    
    .section-subtitle {
        font-size: 16px;
        margin-top: 8px;
        color: #FFD700;
        letter-spacing: 0.5px;
    }
}

.profile-content {
    display: flex;
    padding: 0;
    
    @media (max-width: 768px) {
        flex-direction: column;
    }
}

.profile-avatar {
    width: 250px;
    padding: 30px;
    display: flex;
    flex-direction: column;
    align-items: center;
    border-right: 1px solid #f0f0f0;
    
    @media (max-width: 768px) {
        width: 100%;
        border-right: none;
        border-bottom: 1px solid #f0f0f0;
    }
    
    .avatar-container {
        position: relative;
        width: 180px;
        height: 180px;
        border-radius: 50%;
        margin-bottom: 20px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        cursor: pointer;
        
        .avatar-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.3s ease;
        }
        
        .avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            opacity: 0;
            transition: all 0.3s ease;
            color: white;
            
            i {
                font-size: 32px;
                margin-bottom: 10px;
            }
            
            span {
                font-size: 14px;
            }
        }
        
        .avatar-input {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        
        &:hover {
            .avatar-image {
                transform: scale(1.05);
            }
            
            .avatar-overlay {
                opacity: 1;
            }
        }
    }
    
    .avatar-username {
        font-size: 18px;
        font-weight: 600;
        color: #1E3A8A;
        margin-top: 10px;
        text-align: center;
    }
}

.profile-form {
    flex: 1;
    padding: 30px;
    
    .user-form {
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 10px;
            
            @media (max-width: 768px) {
                flex-direction: column;
                gap: 0;
            }
            
            .el-form-item {
                flex: 1;
                
                /deep/ .el-form-item__label {
                    color: #1E3A8A;
                    font-weight: 600;
                    font-size: 14px;
                    padding-bottom: 5px;
                }
                
                /deep/ .el-input__inner {
                    border-radius: 8px;
                    height: 45px;
                    transition: all 0.3s ease;
                    
                    &:focus {
                        border-color: #1E3A8A;
                        box-shadow: 0 0 5px rgba(30, 58, 138, 0.2);
                    }
                }
                
                /deep/ .el-input-group__prepend {
                    background-color: #f8f9fa;
                }
            }
        }
        
        .form-footer {
            margin-top: 25px;
            text-align: center;
            
            .submit-button {
                background: linear-gradient(135deg, #1E3A8A, #274597);
                border: none;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 30px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 8px rgba(30, 58, 138, 0.2);
                
                i {
                    margin-right: 8px;
                }
                
                &:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 6px 12px rgba(30, 58, 138, 0.3);
                }
            }
        }
    }
}

/deep/ .gender-dropdown {
    .el-select-dropdown__item {
        display: flex;
        align-items: center;
        height: 40px;
        
        i {
            margin-right: 8px;
        }
    }
}
</style>