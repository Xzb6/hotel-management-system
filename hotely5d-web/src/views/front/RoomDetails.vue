<template>
    <div class="room-details-container">
        <div class="room-details-card">
            <div class="section-header">
                <h1 class="section-title">客房详情</h1>
                <div class="section-subtitle">浏览完整信息，开启您的舒适住宿体验</div>
            </div>
            
            <div class="room-content">
                <div class="room-gallery">
                    <div class="main-image-container">
                        <img :src="$baseFileUrl + category.photo" class="main-image" alt="房间图片">
                        <div class="room-status-badge" v-if="room.canUse">
                            <i class="fas fa-check-circle"></i> 可预订
                        </div>
                        <div class="room-status-badge unavailable" v-else>
                            <i class="fas fa-ban"></i> 已满房
                        </div>
                    </div>
                    <div class="room-features">
                        <div class="feature-item">
                            <i class="fas fa-users"></i>
                            <div class="feature-text">
                                <div class="feature-value">{{ category.liveNum }}</div>
                                <div class="feature-label">可住人数</div>
                            </div>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-bed"></i>
                            <div class="feature-text">
                                <div class="feature-value">{{ category.bedNum }}</div>
                                <div class="feature-label">床位数</div>
                            </div>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-expand-arrows-alt"></i>
                            <div class="feature-text">
                                <div class="feature-value">{{ category.area }}</div>
                                <div class="feature-label">平方米</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="room-info">
                    <div class="room-header">
                        <div class="room-title">
                            <h2>{{ category.categoryName }} - {{ room.roomNum }}</h2>
                            <div class="room-price">
                                <span class="price-value">¥{{ category.price }}</span>
                                <span class="price-label">/ 晚</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="room-description">
                        <h3>房间介绍</h3>
                        <p>{{ category.introduce || '这是一间精心设计的高品质客房，为您提供舒适宜人的住宿环境和完善的设施配套。无论是商务出行还是休闲度假，都能满足您的需求。' }}</p>
                    </div>
                    
                    <div class="booking-section">
                        <h3>预订信息</h3>
                        <p v-if="!token" class="login-reminder">
                            <i class="fas fa-info-circle"></i> 温馨提示：请<el-button type="text" @click="$router.push('/login')">登录</el-button>后再预订
                        </p>
                        
                        <el-form :model="form" class="booking-form">
                            <div class="form-row">
                                <el-form-item label="入住日期">
                                    <el-date-picker 
                                        :clearable="false" 
                                        :picker-options="pickerOptions" 
                                        v-model="form.startTime"
                                        type="date" 
                                        placeholder="选择入住日期" 
                                        value-format="yyyy-MM-dd" 
                                        format="yyyy-MM-dd"
                                        class="date-picker">
                                    </el-date-picker>
                                </el-form-item>
                                
                                <el-form-item label="入住天数">
                                    <el-input-number 
                                        v-model="form.days" 
                                        :min="1" 
                                        :max="30"
                                        placeholder="入住天数"
                                        class="days-input">
                                    </el-input-number>
                                </el-form-item>
                            </div>
                            
                            <div class="booking-summary" v-if="form.days">
                                <div class="summary-item">
                                    <span>房间类型:</span>
                                    <span>{{ category.categoryName }}</span>
                                </div>
                                <div class="summary-item">
                                    <span>入住日期:</span>
                                    <span>{{ form.startTime || '未选择' }}</span>
                                </div>
                                <div class="summary-item">
                                    <span>入住天数:</span>
                                    <span>{{ form.days }}晚</span>
                                </div>
                                <div class="summary-item total">
                                    <span>总价:</span>
                                    <span class="total-price">¥{{ calculateTotal() }}</span>
                                </div>
                            </div>
                            
                            <el-form-item>
                                <el-button 
                                    @click="handleAppointment" 
                                    type="primary" 
                                    :disabled="!room.canUse || !token"
                                    class="booking-button">
                                    <i class="fas fa-calendar-check"></i> 立即预订
                                </el-button>
                                <el-button @click="$router.push('/front/room')" class="return-button">
                                    <i class="fas fa-arrow-left"></i> 返回房间列表
                                </el-button>
                            </el-form-item>
                        </el-form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { findRoomByIdAPI } from '@/api/room'
import { addAppointmentAPI } from '@/api/appointment'
import { mapState } from 'vuex'
import dayjs from 'dayjs'
export default {
    name: 'FrontCategoryDetails',

    data() {
        return {
            pickerOptions: {
                disabledDate: this.disabledDate
            },
            room: {},
            category: {},
            form: {
                roomId: this.$route.params.id,
                startTime: dayjs().format('YYYY-MM-DD'),
                days: 1
            },
            timeArr: null
        };
    },

    computed: {
        ...mapState(['user', 'role', 'token'])
    },

    async mounted() {
        // 获取客房信息
        const { data } = await findRoomByIdAPI(this.$route.params.id)
        this.room = data
        this.category = data.category
        
        // 加载FontAwesome图标
        this.loadFontAwesome()
    },

    methods: {
        // 加载FontAwesome图标
        loadFontAwesome() {
            if (!document.querySelector('link[href*="font-awesome"]')) {
                const link = document.createElement('link');
                link.setAttribute('rel', 'stylesheet');
                link.setAttribute('href', 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
                document.head.appendChild(link);
            }
        },
        
        // 计算总价
        calculateTotal() {
            if (this.form.days && this.category.price) {
                return (this.form.days * this.category.price).toFixed(2);
            }
            return '0.00';
        },
        
        disabledDate(time) {
            //禁用今天之前的日期
            if(dayjs(time).isBefore(dayjs(), 'day')){
                return true
            }
            //禁用其它日期
            return this.room.notUseDateList && this.room.notUseDateList.includes(dayjs(time).format('YYYY-MM-DD'));
        },
        
        //预订
        async handleAppointment() {
            // 未登录时提示用户登录并跳转登录页面
            if (!this.token) {
                this.$message({
                    type: 'warning',
                    message: '请先登录后再进行预订！'
                });
                setTimeout(() => this.$router.push('/login'), 1000);
                return;
            }
            
            // 未选择入住时间时提示用户选择
            if (!this.form.startTime) {
                this.$message({
                    type: 'warning',
                    message: '请选择入住日期！'
                });
                return;
            }
            
            // 未选择居住天数时提示用户选择
            if (!this.form.days) {
                this.$message({
                    type: 'warning',
                    message: '请选择入住天数！'
                });
                return;
            }
            
            try {
                // 调用预订接口，传递表单数据
                const res = await addAppointmentAPI({
                    ...this.form,
                    startTime: this.form.startTime + " 00:00:00"
                });
                
                // 显示预订结果信息
                this.$message({
                    message: res.message,
                    type: res.flag ? "success" : "error",
                });
                
                if (res.flag) {
                    // 预订成功后跳转到客房列表页面
                    this.$router.push("/front/room");
                }
            } catch (error) {
                console.error('预订失败:', error);
                
                // 处理后端返回的错误信息
                if (error && error.message) {
                    // 如果是业务逻辑错误（如重复预订），显示后端返回的错误信息
                    this.$message({
                        type: 'error',
                        message: error.message
                    });
                } else {
                    // 如果是网络错误等其他错误，显示通用错误提示
                    this.$message({
                        type: 'error',
                        message: '预订失败，请稍后重试'
                    });
                }
            }
        }
    },
};
</script>

<style lang="less" scoped>
.room-details-container {
    width: 1200px;
    margin: 30px auto;
    font-family: 'Arial', sans-serif;
}

.room-details-card {
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

.room-content {
    display: flex;
    padding: 0;
    
    @media (max-width: 1000px) {
        flex-direction: column;
    }
}

.room-gallery {
    width: 40%;
    padding: 30px;
    
    @media (max-width: 1000px) {
        width: 100%;
    }
    
    .main-image-container {
        position: relative;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        
        .main-image {
            width: 100%;
            height: 380px;
            object-fit: cover;
            transition: transform 0.6s ease;
            
            &:hover {
                transform: scale(1.03);
            }
        }
        
        .room-status-badge {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(103, 194, 58, 0.9);
            color: white;
            padding: 8px 16px;
            border-radius: 30px;
            font-weight: 600;
            display: flex;
            align-items: center;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            
            i {
                margin-right: 5px;
            }
            
            &.unavailable {
                background: rgba(245, 108, 108, 0.9);
            }
        }
    }
    
    .room-features {
        display: flex;
        justify-content: space-between;
        margin-top: 25px;
        
        .feature-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            width: 30%;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            
            i {
                font-size: 24px;
                color: #1E3A8A;
                margin-bottom: 10px;
            }
            
            .feature-text {
                text-align: center;
                
                .feature-value {
                    font-size: 20px;
                    font-weight: 700;
                    color: #333;
                }
                
                .feature-label {
                    font-size: 12px;
                    color: #777;
                    margin-top: 2px;
                }
            }
        }
    }
}

.room-info {
    width: 60%;
    padding: 30px;
    border-left: 1px solid #f0f0f0;
    
    @media (max-width: 1000px) {
        width: 100%;
        border-left: none;
        border-top: 1px solid #f0f0f0;
    }
    
    .room-header {
        margin-bottom: 25px;
        
        .room-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            
            h2 {
                font-size: 26px;
                color: #1E3A8A;
                margin: 0;
                font-weight: 600;
            }
            
            .room-price {
                display: flex;
                align-items: baseline;
                
                .price-value {
                    font-size: 28px;
                    font-weight: 700;
                    color: #ff5252;
                }
                
                .price-label {
                    font-size: 16px;
                    color: #777;
                    margin-left: 5px;
                }
            }
        }
    }
    
    .room-description {
        margin-bottom: 25px;
        padding-bottom: 25px;
        border-bottom: 1px solid #f0f0f0;
        
        h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
            position: relative;
            padding-left: 15px;
            
            &:before {
                content: '';
                position: absolute;
                left: 0;
                top: 5px;
                height: 15px;
                width: 4px;
                background: #1E3A8A;
                border-radius: 2px;
            }
        }
        
        p {
            font-size: 15px;
            line-height: 1.6;
            color: #555;
            margin: 0;
        }
    }
    
    .booking-section {
        h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
            position: relative;
            padding-left: 15px;
            
            &:before {
                content: '';
                position: absolute;
                left: 0;
                top: 5px;
                height: 15px;
                width: 4px;
                background: #1E3A8A;
                border-radius: 2px;
            }
        }
        
        .login-reminder {
            background-color: #fff8e6;
            border-left: 4px solid #FFD700;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            
            i {
                color: #f0ad4e;
                margin-right: 8px;
                font-size: 16px;
            }
            
            .el-button--text {
                color: #1E3A8A;
                font-weight: 600;
                padding: 0 5px;
            }
        }
        
        .booking-form {
            .form-row {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 20px;
                
                .el-form-item {
                    margin-bottom: 0;
                    
                    /deep/ .el-form-item__label {
                        color: #1E3A8A;
                        font-weight: 600;
                    }
                }
                
                .date-picker, .days-input {
                    width: 200px;
                }
            }
            
            .booking-summary {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                
                .summary-item {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                    font-size: 14px;
                    
                    &:last-child {
                        margin-bottom: 0;
                    }
                    
                    &.total {
                        margin-top: 15px;
                        padding-top: 15px;
                        border-top: 1px dashed #ddd;
                        font-weight: 600;
                        
                        .total-price {
                            font-size: 20px;
                            color: #ff5252;
                        }
                    }
                }
            }
            
            .booking-button {
                background: linear-gradient(135deg, #1E3A8A, #274597);
                border: none;
                padding: 12px 24px;
                font-size: 16px;
                border-radius: 30px;
                font-weight: 600;
                box-shadow: 0 4px 10px rgba(30, 58, 138, 0.2);
                transition: all 0.3s ease;
                
                &:hover:not(:disabled) {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 15px rgba(30, 58, 138, 0.3);
                }
                
                &:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                }
                
                i {
                    margin-right: 8px;
                }
            }
            
            .return-button {
                margin-left: 15px;
                
                i {
                    margin-right: 5px;
                }
            }
        }
    }
}
</style>