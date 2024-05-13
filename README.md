# infrastructure

Kiến trúc microservice là một phương pháp thiết kế phần mềm trong đó ứng dụng được cấu trúc dưới dạng một tập hợp các dịch vụ nhỏ, độc lập. Mỗi dịch vụ này thực hiện một chức năng kinh doanh cụ thể và có thể được phát triển, triển khai, vận hành và mở rộng một cách độc lập. Đối với một ứng dụng tương tự Grab, chúng ta cần xem xét các dịch vụ chính sau đây:

### 1. Thiết kế kiến trúc tổng quan

Trước khi đi vào chi tiết, cần xác định một số thành phần chính của ứng dụng như sau:

- **API Gateway:** Là điểm nhập duy nhất vào hệ thống, xử lý việc chuyển tiếp yêu cầu đến các microservices phù hợp, và cung cấp một lớp bảo mật.
- **Service Discovery:** Quản lý việc phát hiện và đăng ký các microservice trong hệ thống.
- **Load Balancer:** Phân phối tải và yêu cầu đến các instances của microservice.
- **Centralized Configuration:** Quản lý cấu hình chung cho tất cả microservices.
- **Distributed Tracing and Logging:** Theo dõi và ghi nhận các yêu cầu xuyên suốt hệ thống.
- **Authentication and Authorization:** Xác thực và phân quyền người dùng.

### 2. Thiết kế các Microservice chính

Dưới đây là một số microservice cần thiết cho ứng dụng tương tự Grab:

#### 2.1 User Service

- **Chức năng:** Quản lý thông tin người dùng, bao gồm khách hàng và tài xế.
- **APIs:** Đăng ký, đăng nhập, cập nhật thông tin cá nhân, quản lý điểm thưởng, v.v.

#### 2.2 Driver Service

- **Chức năng:** Quản lý thông tin và trạng thái của tài xế.
- **APIs:** Cập nhật vị trí, trạng thái sẵn sàng nhận chuyến, lịch sử chuyến đi, đánh giá tài xế, v.v.

#### 2.3 Ride Matching Service

- **Chức năng:** Ghép chuyến xe dựa trên vị trí của khách hàng và tài xế.
- **APIs:** Tạo yêu cầu chuyến đi, hủy yêu cầu, tìm kiếm tài xế phù hợp, thông báo cho tài xế, v.v.

#### 2.4 Trip Management Service

- **Chức năng:** Quản lý các chi tiết của chuyến đi.
- **APIs:** Theo dõi trạng thái chuyến đi, lưu trữ lộ trình, tính toán giá tiền, v.v.

#### 2.5 Payment Service

- **Chức năng:** Xử lý các giao dịch thanh toán.
- **APIs:** Thanh toán hóa đơn, quản lý phương thức thanh toán, phát hành hoá đơn, v.v.

#### 2.6 Notification Service

- **Chức năng:** Gửi thông báo đến người dùng.
- **APIs:** Gửi SMS, email, và thông báo qua app.

### 3. Dữ liệu và Lưu Trữ

Mỗi microservice sẽ có cơ sở dữ liệu riêng (database per service) để đảm bảo tính độc lập và dễ dàng mở rộng. Các loại cơ sở dữ liệu có thể bao gồm:

- **SQL Database** (ví dụ: PostgreSQL, MySQL) choviệc lưu trữ dữ liệu cấu trúc như thông tin người dùng, thông tin tài xế.
- **NoSQL Database** (ví dụ: MongoDB, Cassandra) cho dữ liệu không cấu trúc hoặc semi-cấu trúc, như thông tin chuyến đi, lịch sử đơn hàng.

### 4. Bảo mật

Bảo mật là một yếu tố quan trọng trong kiến trúc microservices:

- **Authentication:** Sử dụng OAuth2 và JWT để xác thực người dùng.
- **Authorization:** Áp dụng RBAC (Role-Based Access Control) để quản lý quyền truy cập theo vai trò người dùng.
- **Secure Communication:** Sử dụng HTTPS và TLS để đảm bảo an toàn cho dữ liệu truyền giữa các services.

### 5. DevOps và Môi trường Vận Hành

Việc triển khai và vận hành các microservices cần được tự động hóa để tối ưu hóa hiệu quả:

- **Containerization:** Sử dụng Docker để đóng gói ứng dụng và các phụ thuộc của nó.
- **Orchestration:** Sử dụng Kubernetes để quản lý và tự động hóa việc triển khai, mở rộng và quản lý các container.
- **CI/CD:** Thiết lập các pipeline Continuous Integration và Continuous Deployment để tự động hóa việc kiểm tra và triển khai code mới.
- **Monitoring and Logging:** Sử dụng Prometheus và Grafana cho monitoring; ELK Stack (Elasticsearch, Logstash, Kibana) hoặc Loki cho logging để theo dõi và phân tích các vấn đề.

### 6. Tính Năng Phục Hồi và Khả Năng Mở Rộng

- **Circuit Breaker:** Sử dụng mô hình Circuit Breaker để ngăn các lỗi trong một phần của hệ thống lan rộng.
- **Rate Limiting:** Áp dụng giới hạn tốc độ để bảo vệ các services khỏi lưu lượng quá tải.
- **Auto-scaling:** Thiết lập tự động mở rộng quy mô dựa trên nhu cầu thực tế sử dụng.

### 7. Kết luận

Việc thiết kế một kiến trúc microservices cho một ứng dụng đặt xe như Grab đòi hỏi sự cân nhắc kỹ lưỡng về việc phân chia chức năng, quản lý dữ liệu, bảo mật, và vận hành. Mỗi service cần được thiết kế để hoạt động độc lập nhưng vẫn có thể tương tác hiệu quả với các services khác. Điều này không chỉ giúp tăng cường khả năng mở rộng và bảo trì của ứng dụng mà còn cải thiện trải nghiệm người dùng cuối.
