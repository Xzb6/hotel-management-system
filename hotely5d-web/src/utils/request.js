import axios from 'axios'
import { Message } from 'element-ui'
import { getToken,removeToken } from '@/utils/auth'

// create an axios instance
const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API, 
  timeout: 5000
})

// request interceptor
service.interceptors.request.use(
  config => {
    //设置token
    config.headers['Authorization'] = getToken()
    return config
  },
  error => {
    // do something with request error
    console.log(error) // for debug
    return Promise.reject(error)
  }
)

// response interceptor
service.interceptors.response.use(
  /**
   * If you want to get http information such as headers or status
   * Please return  response => response
  */

  /**
   * Determine the request status by custom status
   * Here is just an example
   * You can also judge the status by HTTP Status status
   */
  response => {
    const res = response.data

    // if the custom status is not 20000, it is judged as an error.
    if (res.code !== 20000) {
      // 不在这里显示错误信息，让调用者处理
      // Message({
      //   message: res.message || 'Error',
      //   type: 'error',
      //   duration: 5 * 1000
      // })

      if (res.code === 20006) {//token失效
        Message({
          message: '登录已过期，请重新登录',
          type: 'error',
          duration: 5 * 1000
        })
        removeToken()
        localStorage.removeItem('vuex')
        setTimeout(() => {
          location.href = "/"
        }, 1000);
      }
      // 返回完整的响应数据，让调用者可以访问错误信息
      return Promise.reject(res)
    } else {
      return res
    }
  },
  error => {
    console.log('err' + error) // for debug
    // 处理网络错误等非业务逻辑错误
    Message({
      message: '网络请求失败，请检查您的网络连接',
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service