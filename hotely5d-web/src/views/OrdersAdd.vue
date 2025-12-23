<template>
    <div class="orders-add-container">
        <!-- 标题区域 -->
        <div class="page-header">
            <div class="header-content">
                <h2 class="title">办理入住</h2>
                <p class="subtitle">选择客房并登记入住信息</p>
            </div>
        </div>
        
        <!-- 内容区域 -->
        <el-card class="content-card" shadow="hover">
            <!-- 搜索区域 -->
            <div class="search-section">
                <el-form :inline="true" :model="formInline" class="search-form">
                    <el-form-item label="入住日期">
                        <el-date-picker 
                            size="small" 
                            disabled 
                            :clearable="false" 
                            :picker-options="pickerOptions"
                            v-model="formInline.startDate" 
                            type="date" 
                            placeholder="入住日期" 
                            value-format="yyyy-MM-dd"
                            format="yyyy-MM-dd"
                            prefix-icon="el-icon-date">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="房型">
                        <el-select 
                            size="small" 
                            v-model="formInline.categoryId" 
                            placeholder="请选择房型" 
                            clearable
                            prefix-icon="el-icon-house">
                            <el-option 
                                v-for="item in categoryList" 
                                :label="item.categoryName" 
                                :value="item.id"
                                :key="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="状态">
                        <el-select 
                            size="small" 
                            v-model="formInline.canUse" 
                            placeholder="请选择状态" 
                            clearable>
                            <el-option label="可入住" :value="true"></el-option>
                            <el-option label="已满房" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button 
                            size="small" 
                            type="primary" 
                            icon="el-icon-search" 
                            @click="onSubmit"
                            :loading="searchLoading">
                            查询
                        </el-button>
                    </el-form-item>
                </el-form>
            </div>
            
            <!-- 房间列表 -->
            <div class="room-list">
                <div v-if="roomList.length === 0" class="empty-rooms">
                    <i class="el-icon-house empty-icon"></i>
                    <p>暂无符合条件的客房</p>
                </div>
                
                <div v-else class="room-grid">
                    <el-card 
                        v-for="item in roomList" 
                        :key="item.id" 
                        class="room-item"
                        shadow="hover"
                        :body-style="{ padding: '0px' }">
                        <div class="room-image">
                            <img :src="$baseFileUrl + item.category.photo" alt="房型图片">
                            <div class="room-status">
                                <el-tag size="small" :type="item.canUse ? 'success' : 'danger'" effect="dark">
                                    {{ item.canUse ? '可入住' : '已满房' }}
                                </el-tag>
                            </div>
                        </div>
                        <div class="room-info">
                            <h3 class="room-title">{{ item.category.categoryName }}-{{ item.roomNum }}</h3>
                            <div class="room-price">￥{{ item.category.price }}<span>/晚</span></div>
                            <div class="room-actions">
                                <el-button 
                                    v-if="item.canUse" 
                                    type="primary" 
                                    size="small" 
                                    icon="el-icon-key"
                                    @click="handleAdd(item)">
                                    办理入住
                                </el-button>
                                <el-button 
                                    v-else 
                                    type="info" 
                                    size="small" 
                                    disabled>
                                    已满房
                                </el-button>
                            </div>
                        </div>
                    </el-card>
                </div>
            </div>
        </el-card>

        <!-- 入住信息对话框 -->
        <el-dialog 
            title="办理入住" 
            :visible.sync="dialogVisible" 
            width="600px" 
            :close-on-click-modal="false"
            :before-close="handleDialogClose"
            center>
            <el-form 
                ref="form" 
                :model="form" 
                :rules="formRules"
                label-width="100px"
                status-icon>
                <div class="dialog-room-info">
                    <div class="room-basic-info">
                        <img :src="currentRoomImage" alt="房型图片" class="dialog-room-image">
                        <div class="room-details">
                            <h3>{{ form.categoryName }}-{{ form.roomNum }}</h3>
                            <p class="price-tag">￥{{ form.money }}<span v-if="form.days > 1">（{{ form.days }}晚）</span></p>
                        </div>
                    </div>
                </div>
                
                <el-row :gutter="20">
                    <el-col :span="12">
                        <el-form-item label="入住时间" prop="startDate">
                            <el-tag size="small" type="info">{{ formInline.startDate }}</el-tag>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="居住天数" prop="days">
                            <el-input-number 
                                v-model="form.days" 
                                :min="1" 
                                :max="30" 
                                size="small"
                                @change="updateTotalPrice">
                            </el-input-number>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="姓名" prop="name">
                            <el-input 
                                size="small" 
                                v-model="form.name"
                                placeholder="请输入姓名"
                                prefix-icon="el-icon-user">
                            </el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="性别" prop="gender">
                            <el-select 
                                size="small" 
                                v-model="form.gender" 
                                placeholder="请选择性别">
                                <el-option 
                                    v-for="item in genderOptions" 
                                    :key="item.value" 
                                    :label="item.label"
                                    :value="item.value">
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="电话" prop="phone">
                            <el-input 
                                size="small" 
                                v-model="form.phone"
                                placeholder="请输入电话号码"
                                prefix-icon="el-icon-phone">
                            </el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="身份证" prop="idcard">
                            <el-input 
                                size="small" 
                                v-model="form.idcard"
                                placeholder="请输入身份证号码"
                                prefix-icon="el-icon-document">
                            </el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button 
                    size="small" 
                    @click="handleDialogClose">
                    取 消
                </el-button>
                <el-button 
                    size="small" 
                    type="primary" 
                    @click="handleConfirm"
                    :loading="submitLoading">
                    确认入住
                </el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import { findAllCategoryAPI } from '@/api/category'
import { findRoomListAPI } from '@/api/room'
import { addOrdersAPI } from '@/api/orders'
import dayjs from 'dayjs'
export default {
    name: 'OrdersAdd',

    data() {
        // 手机号验证规则
        const validatePhone = (rule, value, callback) => {
            const phoneReg = /^1[3-9]\d{9}$/
            if (value === '') {
                callback(new Error('请输入手机号码'))
            } else if (!phoneReg.test(value)) {
                callback(new Error('请输入正确的手机号码'))
            } else {
                callback()
            }
        }
        
        // 身份证验证规则
        const validateIdCard = (rule, value, callback) => {
            const idCardReg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/
            if (value === '') {
                callback(new Error('请输入身份证号码'))
            } else if (!idCardReg.test(value)) {
                callback(new Error('请输入正确的身份证号码'))
            } else {
                callback()
            }
        }
        
        return {
            pickerOptions: {
                disabledDate: this.disabledDate
            },
            formInline: {
                startDate: dayjs().format('YYYY-MM-DD'),
                categoryId: null,
                canUse: null
            },
            categoryList: [],
            roomList: [],
            form: {
                gender: 1,
                categoryName: '',
                days: 1,
                name: '',
                phone: '',
                idcard: '',
                money: '',
                roomId: '',
                roomNum: ''
            },
            formRules: {
                days: [
                    { required: true, message: '请输入居住天数', trigger: 'change' },
                    { type: 'number', min: 1, message: '天数必须大于0', trigger: 'change' }
                ],
                name: [
                    { required: true, message: '请输入姓名', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ],
                phone: [
                    { required: true, message: '请输入电话号码', trigger: 'blur' },
                    { validator: validatePhone, trigger: 'blur' }
                ],
                idcard: [
                    { required: true, message: '请输入身份证号码', trigger: 'blur' },
                    { validator: validateIdCard, trigger: 'blur' }
                ]
            },
            dialogVisible: false,
            genderOptions: [
                { label: '男', value: 1 },
                { label: '女', value: 2 }
            ],
            currentRoomImage: '',
            searchLoading: false,
            submitLoading: false,
            currentRoomPrice: 0
        };
    },

    async mounted() {
        if (this.$route.query?.categoryId) {
            this.formInline.categoryId = parseInt(this.$route.query?.categoryId)
        }
        this.getCategoryList()
        this.getList()
    },

    methods: {
        updateTotalPrice(days) {
            this.form.money = this.currentRoomPrice * days;
        },
        handleDialogClose() {
            this.$confirm('确定要取消办理入住吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.dialogVisible = false
                this.resetForm()
            }).catch(() => {})
        },
        resetForm() {
            this.form = {
                gender: 1,
                categoryName: '',
                days: 1,
                name: '',
                phone: '',
                idcard: '',
                money: '',
                roomId: '',
                roomNum: ''
            }
            if (this.$refs.form) {
                this.$refs.form.resetFields()
            }
        },
        disabledDate(time) {
            //禁用今天之前的日期
            return dayjs(time).isBefore(dayjs(), 'day')
        },
        async getCategoryList() {
            try {
                const { data } = await findAllCategoryAPI()
                this.categoryList = data
            } catch (error) {
                this.$message.error('获取房型列表失败')
            }
        },
        async getList() {
            this.searchLoading = true
            try {
                const { data } = await findRoomListAPI(this.formInline)
                this.roomList = data
            } catch (error) {
                this.$message.error('获取房间列表失败')
            } finally {
                this.searchLoading = false
            }
        },
        onSubmit() {
            this.getList()
        },
        //点击入住按钮
        handleAdd({ category, roomNum, id }) {
            this.currentRoomPrice = category.price
            this.form.money = category.price * this.form.days
            this.form.roomId = id
            this.form.roomNum = roomNum
            this.form.categoryName = category.categoryName
            this.currentRoomImage = this.$baseFileUrl + category.photo
            this.dialogVisible = true
        },
        //点击弹框中的确认
        async handleConfirm() {
            this.$refs.form.validate(async (valid) => {
                if (valid) {
                    this.submitLoading = true
                    try {
                        const res = await addOrdersAPI(this.form)
                        this.$message({
                            message: res.message,
                            type: res.flag ? "success" : "error",
                        });
                        if (res.flag) {
                            this.dialogVisible = false
                            setTimeout(() => {
                                this.$router.push('/admin/orders')
                            }, 1000);
                        }
                    } catch (error) {
                        this.$message.error('提交失败，请重试')
                    } finally {
                        this.submitLoading = false
                    }
                } else {
                    return false
                }
            })
        }
    },
};
</script>

<style lang="less" scoped>
.orders-add-container {
    // 页面标题区域
    .page-header {
        margin-bottom: 20px;
        background: linear-gradient(to right, #1E3A8A, #3151B7);
        border-radius: 8px;
        padding: 20px;
        color: white;
        
        .header-content {
            .title {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
            }
            
            .subtitle {
                margin: 8px 0 0 0;
                font-size: 14px;
                color: rgba(255, 255, 255, 0.8);
            }
        }
    }
    
    // 内容卡片
    .content-card {
        margin-bottom: 20px;
        border-radius: 8px;
        
        .search-section {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #EBEEF5;
            
            .search-form {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                
                /deep/ .el-select {
                    width: 100%;
                    
                    .el-input__inner {
                        height: 32px;
                        line-height: 32px;
                    }
                    
                    .el-input__suffix {
                        display: flex;
                        align-items: center;
                        height: 100%;
                        
                        .el-input__icon {
                            line-height: normal;
                        }
                    }
                }
                
                /deep/ .el-form-item__label {
                    line-height: 32px;
                }
                
                /deep/ .el-date-editor.el-input {
                    width: 100%;
                    
                    .el-input__inner {
                        height: 32px;
                        line-height: 32px;
                    }
                    
                    .el-input__prefix, .el-input__suffix {
                        display: flex;
                        align-items: center;
                        height: 100%;
                        
                        .el-input__icon {
                            line-height: normal;
                        }
                    }
                }
            }
        }
        
        // 房间列表样式
        .room-list {
            .empty-rooms {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px 0;
                color: #909399;
                
                .empty-icon {
                    font-size: 48px;
                    margin-bottom: 16px;
                }
                
                p {
                    margin: 0;
                    font-size: 14px;
                }
            }
            
            .room-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
                
                .room-item {
                    border-radius: 8px;
                    overflow: hidden;
                    transition: all 0.3s;
                    height: 100%;
                    
                    &:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
                    }
                    
                    .room-image {
                        position: relative;
                        height: 180px;
                        overflow: hidden;
                        
                        img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                            transition: transform 0.3s;
                        }
                        
                        .room-status {
                            position: absolute;
                            top: 10px;
                            right: 10px;
                        }
                    }
                    
                    .room-info {
                        padding: 16px;
                        
                        .room-title {
                            margin: 0 0 10px 0;
                            font-size: 16px;
                            font-weight: 600;
                            color: #303133;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }
                        
                        .room-price {
                            color: #F56C6C;
                            font-size: 18px;
                            font-weight: 600;
                            margin-bottom: 16px;
                            
                            span {
                                font-size: 14px;
                                font-weight: normal;
                                color: #909399;
                            }
                        }
                        
                        .room-actions {
                            text-align: right;
                        }
                    }
                }
            }
        }
    }
    
    // 对话框样式
    .dialog-room-info {
        margin-bottom: 20px;
        
        .room-basic-info {
            display: flex;
            align-items: center;
            background-color: #F5F7FA;
            padding: 16px;
            border-radius: 8px;
            
            .dialog-room-image {
                width: 100px;
                height: 70px;
                object-fit: cover;
                border-radius: 4px;
                margin-right: 16px;
            }
            
            .room-details {
                h3 {
                    margin: 0 0 8px 0;
                    font-size: 16px;
                    color: #303133;
                }
                
                .price-tag {
                    margin: 0;
                    font-size: 16px;
                    font-weight: 600;
                    color: #F56C6C;
                    
                    span {
                        font-size: 14px;
                        font-weight: normal;
                        color: #909399;
                    }
                }
            }
        }
    }
    
    .dialog-footer {
        text-align: right;
    }
}

// 弹框中的表单样式
/deep/ .el-dialog {
    .el-form {
        .el-select {
            width: 100%;
            
            .el-input__suffix {
                display: flex;
                align-items: center;
                height: 100%;
                
                .el-input__icon {
                    line-height: normal;
                }
            }
        }
        
        .el-input, .el-input-number {
            width: 100%;
        }
    }
}
</style>