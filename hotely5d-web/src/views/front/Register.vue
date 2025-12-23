<template>
    <div class="container">
        <div class="register-box">
            <h2 class="title" @click="$router.push('/front')">{{ $sysTitle }}-注册</h2>
            
            <!-- 错误提示 -->
            <el-alert
                v-if="showError"
                :title="errorMessage"
                type="error"
                show-icon
                :closable="true"
                @close="showError = false"
                class="error-alert"
            ></el-alert>
            
            <el-form :model="form" label-position="left" label-width="70px">
                <el-form-item label="账号">
                    <el-input placeholder="请输入账号" v-model="form.username" autocomplete="off" prefix-icon="el-icon-user"></el-input>
                </el-form-item>
                <el-form-item label="密码">
                    <el-input type="password" placeholder="请输入密码" v-model="form.password" autocomplete="off" prefix-icon="el-icon-lock" show-password></el-input>
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input placeholder="请输入姓名" v-model="form.name" autocomplete="off" prefix-icon="el-icon-s-custom"></el-input>
                </el-form-item>
                <el-form-item label="性别">
                    <div class="select-with-icon">
                        <i class="el-icon-coordinate select-prefix-icon"></i>
                        <el-select v-model="form.gender" placeholder="请选择" style="width: 100%;">
                            <el-option
                                v-for="item in genderOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                        </el-select>
                    </div>
                </el-form-item>
                <el-form-item label="手机">
                    <el-input placeholder="请输入手机" v-model="form.phone" autocomplete="off" prefix-icon="el-icon-mobile-phone"></el-input>
                </el-form-item>
                <el-form-item label="身份证">
                    <el-input placeholder="请输入身份证" v-model="form.idcard" autocomplete="off" prefix-icon="el-icon-document"></el-input>
                </el-form-item>
                <el-form-item label="头像">
                    <div class="avatar-upload-container">
                        <el-upload 
                            name="photo" 
                            class="avatar-uploader" 
                            action="#" 
                            :http-request="uploadHeadFile"
                            :file-list="fileList" 
                            list-type="picture"
                            :disabled="uploadLoading">
                            <div class="upload-btn-wrapper" v-if="fileList.length === 0">
                                <el-button type="primary" icon="el-icon-upload" class="upload-btn" size="mini" :loading="uploadLoading">{{ uploadLoading ? '上传中...' : '点击上传' }}</el-button>
                                <div class="upload-tip">支持JPG、PNG格式，大小不超过2MB</div>
                            </div>
                            <div v-else class="has-uploaded-tip">
                                <i class="el-icon-check"></i> 已上传头像
                            </div>
                        </el-upload>
                    </div>
                </el-form-item>
                <el-form-item class="action-btn">
                    <el-button type="primary" style="width: 100%;" @click="submitForm" :loading="submitLoading">注册</el-button>
                    <div class="text-right">
                        已有账号?去<router-link to="/login">登录</router-link>
                    </div>
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>

<script>
import { registerAPI } from '@/api/system'
import request from '@/utils/request'
import axios from 'axios'

export default {
    name: 'Register',
    data() {
        return {
            form: {
                username: '', 
                password: '',
                name: '',
                gender: '', // 空值默认显示"请选择"
                phone: '',
                idcard: '',
                head: '', // 使用head字段来保持与后端一致
            },
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
            fileList: [],
            uploadLoading: false, // 添加上传状态
            submitLoading: false, // 添加提交状态
            errorMessage: '', // 添加错误信息
            showError: false // 显示错误信息
        }
    },
    methods: {
        async submitForm() {
            // 清除错误信息
            this.showError = false;
            this.errorMessage = '';
            
            // 检查是否有任何必填字段为空
            const requiredFields = ['username', 'password', 'name', 'gender', 'phone', 'idcard'];
            for (const key of requiredFields) {
                if (!this.form[key]) {
                    this.$message.error(`请填写${this.getFieldLabel(key)}`);
                    return;
                }
            }

            try {
                // 所有字段都填写了，继续注册
                this.submitLoading = true;
                const res = await registerAPI(this.form);
                this.$message({
                    message: res.message,
                    type: res.flag ? "success" : "error",
                });
                if (res.flag) {
                    setTimeout(() => {
                        this.$router.push('/login')
                    }, 1000);
                }
            } catch (error) {
                this.errorMessage = '注册请求发送失败';
                this.showError = true;
                this.$message.error(this.errorMessage);
            } finally {
                this.submitLoading = false;
            }
        },
        
        // 获取字段对应的中文标签
        getFieldLabel(field) {
            const fieldLabels = {
                username: '账号',
                password: '密码',
                name: '姓名',
                gender: '性别',
                phone: '手机',
                idcard: '身份证'
            };
            return fieldLabels[field] || field;
        },
        
        // 上传头像文件 - 使用后端接口
        uploadHeadFile(param) {
            this.uploadLoading = true;
            this.showError = false;
            this.errorMessage = '';
            
            // 文件类型和大小验证
            const file = param.file;
            const isJPG = file.type === 'image/jpeg';
            const isPNG = file.type === 'image/png';
            const isLt2M = file.size / 1024 / 1024 < 2;
            
            if (!isJPG && !isPNG) {
                this.$message.error('上传头像图片只能是 JPG 或 PNG 格式!');
                this.uploadLoading = false;
                return;
            }
            
            if (!isLt2M) {
                this.$message.error('上传头像图片大小不能超过 2MB!');
                this.uploadLoading = false;
                return;
            }
            
            // 创建FormData对象用于上传
            const formData = new FormData();
            formData.append("photo", file);
            
            // 直接使用axios发送请求，避免request拦截器可能的问题
            axios.post('/api/file/uploadPhoto', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {
                this.uploadLoading = false;
                const res = response.data;
                if (res.flag) {
                    // 上传成功，获取头像URL
                    const filename = res.data.filename;
                    this.form.head = filename;
                    
                    // 更新文件列表以显示预览
                    this.fileList = [{
                        name: file.name,
                        url: this.$baseFileUrl ? this.$baseFileUrl + filename : res.data.url
                    }];
                    
                    this.$message.success('头像上传成功');
                    console.log('头像上传成功：', filename);
                } else {
                    this.errorMessage = res.message || '上传失败';
                    this.showError = true;
                    this.$message.error(this.errorMessage);
                }
            }).catch(error => {
                this.uploadLoading = false;
                console.error('上传失败:', error);
                this.errorMessage = '头像上传失败，请稍后重试';
                this.showError = true;
                this.$message.error(this.errorMessage);
                
                // 如果上传失败，仍然提供本地预览
                this.useLocalPreview(file);
            });
        },
        
        // 本地预览备用方案
        useLocalPreview(file) {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => {
                const localUrl = reader.result;
                // 仅用于预览，不会提交给后端
                this.fileList = [{
                    name: file.name,
                    url: localUrl
                }];
                this.$message.info('已切换到本地预览模式，提交表单时可能无法保存头像');
            };
        }
    }
}
</script>

<style lang="less" scoped>
.container {
    width: 100vw;
    height: 100vh;
    background-image: url("../../assets/3.png");
    background-size: 100% 100%;
    display: flex;
    
    .register-box {
        padding: 30px 40px;
        min-width: 450px;
        min-height: 580px;
        background-color: #ffffff;
        margin: auto;
        border-radius: 8px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        position: relative;
        transition: all 0.3s ease;
        overflow-y: auto;
        max-height: 90vh;

        &:hover {
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            transform: translateY(-3px);
        }

        .title {
            text-align: center;
            margin-bottom: 25px;
            font-size: 28px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
            letter-spacing: 1px;
            
            &:hover {
                color: #409EFF;
            }
        }

        .error-alert {
            margin-bottom: 15px;
        }

        /deep/ .el-alert--error {
            background-color: #fef0f0;
            color: #f56c6c;
        }

        /deep/ .el-alert__title {
            font-size: 14px;
            line-height: 1.5;
        }

        /deep/ .el-form-item__label {
            padding-right: 12px;
            font-weight: 500;
            color: #606266;
            font-size: 14px;
        }

        /deep/ .el-form-item.is-required .el-form-item__label:before {
            color: #f56c6c;
        }

        /deep/ .el-input__inner {
            height: 40px;
            border-radius: 4px;
            padding-left: 35px;
            font-size: 14px;
            border: 1px solid #dcdfe6;
            transition: all 0.3s ease;
            
            &:focus {
                border-color: #409EFF;
                box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
            }

            &:hover {
                border-color: #c0c4cc;
            }
        }

        /deep/ .el-input__prefix {
            left: 10px;
            transition: all 0.3s;
            color: #909399;
        }

        /deep/ .el-input:hover .el-input__prefix {
            color: #409EFF;
        }

        /deep/ .el-select .el-input {
            width: 100%;
        }

        /deep/ .el-select-dropdown__item.selected {
            color: #409EFF;
            font-weight: bold;
        }

        .select-with-icon {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;

            .select-prefix-icon {
                position: absolute;
                left: 10px;
                z-index: 2;
                color: #909399;
                transition: all 0.3s;
                font-size: 16px;
            }

            &:hover .select-prefix-icon {
                color: #409EFF;
            }
        }

        /deep/ .el-button--primary {
            height: 40px;
            font-size: 16px;
            font-weight: 500;
            background: #409EFF;
            border: none;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(64, 158, 255, 0.2);
            transition: all 0.3s ease;
            margin-top: 5px;
            
            &:hover {
                background: #66b1ff;
                box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
                transform: translateY(-2px);
            }
            
            &:active {
                transform: translateY(0);
            }
        }

        .avatar-upload-container {
            width: 100%;
            margin-bottom: 5px;
        }

        .upload-btn-wrapper {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .upload-btn {
            font-size: 12px !important;
            margin-bottom: 8px;
        }

        /deep/ .el-upload {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .upload-tip {
            font-size: 12px;
            color: #909399;
            margin-bottom: 8px;
        }

        /deep/ .el-upload-list {
            margin-top: 5px;
            width: 100%;
        }

        .has-uploaded-tip {
            color: #67c23a;
            font-size: 13px;
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            
            i {
                margin-right: 5px;
                font-weight: bold;
            }
        }

        /deep/ .el-upload-list__item {
            transition: all 0.3s;
            margin-top: 5px;
            border-radius: 4px;
            overflow: hidden;
            padding: 5px;
            background: #f9f9f9;
            border: 1px solid #ebeef5;
            
            &:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                background: #f5f7fa;
            }
        }

        /deep/ .el-upload-list__item-name {
            color: #606266;
        }

        /deep/ .el-upload-list__item-thumbnail {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 4px;
        }

        /deep/ .el-upload-list__item-status-label {
            right: 5px;
            top: 5px;
            font-size: 20px;
            color: #67c23a;
        }

        .action-btn {
            margin-top: 15px;
        }

        .text-right {
            text-align: right;
            margin-top: 12px;
            font-size: 14px;
            color: #606266;
            
            a {
                color: #409EFF;
                text-decoration: none;
                margin-left: 4px;
                transition: all 0.3s;
                
                &:hover {
                    color: #66b1ff;
                    text-decoration: underline;
                }
            }
        }

        /deep/ .el-form-item {
            margin-bottom: 16px;
            transition: all 0.3s;
        }
    }
}

@media screen and (max-width: 768px) {
    .container {
        .register-box {
            padding: 25px 20px;
            min-width: 340px;
            min-height: 520px;
            
            .title {
                font-size: 22px;
                margin-bottom: 20px;
            }

            /deep/ .el-form-item__label {
                font-size: 13px;
            }
        }
    }
}

@media screen and (max-width: 480px) {
    .container {
        .register-box {
            padding: 20px 15px;
            min-width: 280px;
            
            .title {
                font-size: 20px;
            }
            
            /deep/ .el-button--primary {
                width: 100% !important;
            }
        }
    }
}
</style>
