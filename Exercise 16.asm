.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014
.data
A: .space 10000
newline:  .asciz "\n"
stopmsg:  .asciz "Đã dừng phát nhạc.\n"
message: .asciz "Key scan code: "
B: .space 10000

# Bản nhạc 1
music1: .word 60, 500, 1, 100
        .word 60, 500, 1, 100
        .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 69, 500, 1, 100
        .word 69, 500, 1, 100
        .word 67, 10000, 1, 100
        .word 67, 10000, 1, 0
        .word 65, 500, 1, 100
        .word 65, 500, 1, 100
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 500, 1, 100
        .word 62, 500, 1, 100
        .word 60, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 65, 10000, 1, 100
        .word 64, 10000, 1, 0
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 65, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 10000, 1, 100
        .word -1

# Bản nhạc 2
music2: .word 68, 500, 1, 100
        .word 64, 500, 1, 100
        .word 68, 500, 1, 100
        .word 69, 500, 1, 100
        .word 68, 500, 1, 100
        .word 68, 15000, 1, 100
        .word 68, 10000, 1, 0
        .word 68, 500, 1, 100
        .word 64, 500, 1, 100
        .word 68, 500, 1, 100
        .word 71, 500, 1, 100
        .word 64, 500, 1, 100
        .word 64, 15000, 1, 100
        .word 68, 10000, 1, 0
        .word 68, 500, 1, 100
        .word 64, 500, 1, 100
        .word 68, 500, 1, 100
        .word 71, 500, 1, 100
        .word 68, 500, 1, 100
        .word 68, 500, 1, 100
        .word 63, 500, 1, 100
        .word 68, 500, 1, 100
        .word 63, 500, 1, 100
        .word 68, 500, 1, 100
        .word 71, 500, 1, 100
        .word 68, 500, 1, 100
        .word 64, 500, 1, 100
        .word 64, 10000, 2, 100
        .word -1

# Bản nhạc 3
music3: .word 60, 500, 1, 100
        .word 60, 500, 1, 100
        .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 69, 500, 1, 100
        .word 69, 500, 1, 100
        .word 67, 10000, 1, 100
        .word 67, 10000, 1, 0
        .word 65, 500, 1, 100
        .word 65, 500, 1, 100
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 500, 1, 100
        .word 62, 500, 1, 100
        .word 60, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word -1

# Bản nhạc 4
music4: .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 65, 10000, 1, 100
        .word 64, 10000, 1, 0
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word 67, 500, 1, 100
        .word 67, 500, 1, 100
        .word 65, 10000, 1, 100
        .word 60, 10000, 1, 0
        .word 64, 500, 1, 100
        .word 64, 500, 1, 100
        .word 62, 10000, 1, 100
        .word -1

.text

# -----------------------------------------------------------------
# MAIN Procedure
# -----------------------------------------------------------------
.text
main:
    li a0, 0                   # Khởi tạo a0 = 0 (sử dụng để kiểm tra trong vòng lặp)

loop:
    li s0, 0x11                # Địa chỉ phím số 0 trên bàn phím trong DLS
    li s1, 0x21                # Địa chỉ phím số 1 trên bàn phím trong DLS
    li s2, 0x41                # Địa chỉ phím số 2 trên bàn phím trong DLS
    li s3, 0xffffff81          # Địa chỉ phím số 3 trên bàn phím trong DLS

    la t0, handler             # Tải địa chỉ trình xử lý ngắt vào thanh ghi t0
    csrrs zero, utvec, t0      # Gán địa chỉ handler vào thanh ghi utvec để xử lý ngắt ở chế độ người dùng

    li t1, 0x100               # Giá trị có bit 8 = 1 để bật ngắt ngoài ở thanh ghi UIE
    csrrs zero, uie, t1        # Thiết lập bit UEIE trong thanh ghi UIE (bật ngắt ngoài ở chế độ người dùng)

    csrrsi zero, ustatus, 1    # Bật bit UIE trong thanh ghi USTATUS để cho phép ngắt ở chế độ người dùng

    li a6, IN_ADDRESS_HEXA_KEYBOARD   # Địa chỉ điều khiển ngắt của bàn phím trong DLS
    li a7, 0x80                       # Giá trị có bit 7 = 1 để bật ngắt cho bàn phím, kích hoạt hàng 1
    sb a7, 0(a6)                      # Ghi vào thanh ghi điều khiển để bật ngắt bàn phím

# ---------------------------------------------------------
# Vòng lặp chính của chương trình để chờ và xử lý phím nhấn
# ---------------------------------------------------------
loop1:
    csrrsi zero, ustatus, 1    # Đảm bảo bit UIE luôn được bật trong thanh ghi ustatus
    beq a0, zero, loop1        # Nếu a0 vẫn bằng 0 thì tiếp tục lặp lại (chờ ngắt xảy ra và thay đổi a0)

continue:
# Xác định địa chỉ bản nhạc cần phát dựa theo giá trị trong a0
    mv t0, a0              # Sao chép giá trị từ a0 sang t0 để so sánh
    li t1, 1
    beq t0, t1, set_music1 # Nếu a0 = 1, chọn bản nhạc 1
    li t1, 2
    beq t0, t1, set_music2 # Nếu a0 = 2, chọn bản nhạc 2
    li t1, 3
    beq t0, t1, set_music3 # Nếu a0 = 3, chọn bản nhạc 3
    li t1, 4
    beq t0, t1, set_music4 # Nếu a0 = 4, chọn bản nhạc 4

    j loop                 # Nếu giá trị không hợp lệ, quay về vòng lặp chờ

set_music1: 
    la t2, music1          # Tải địa chỉ mảng music1 vào t2
    j play_music
set_music2: 
    la t2, music2          # Tải địa chỉ mảng music2 vào t2
    j play_music
set_music3: 
    la t2, music3          # Tải địa chỉ mảng music3 vào t2
    j play_music
set_music4: 
    la t2, music4          # Tải địa chỉ mảng music4 vào t2
    j play_music

# ============= PHÁT NHẠC =============
# t2: địa chỉ hiện tại trong mảng nhạc

play_music:
next_note:
    lw a0, 0(t2)           # Đọc giá trị pitch (cao độ) từ mảng nhạc
    li t3, -1
    beq a0, t3, loop  # Nếu pitch = -1, kết thúc bản nhạc
    lw a1, 4(t2)           # Đọc thời lượng nốt nhạc
    lw a2, 8(t2)           # Đọc loại nhạc cụ
    lw a3, 12(t2)          # Đọc âm lượng

    li a7, 31              # Gọi syscall 31 để phát âm
    ecall

    li a0, 300             # Đặt thời gian nghỉ giữa các nốt là 300ms
    li a7, 32              # Gọi syscall 32 để tạm dừng
    ecall

    li t4, -1
    beq a0, t4, continue_play   # Nếu không có phím nhấn, tiếp tục phát nhạc

    li t5, '0'                  # Mã ASCII của phím '0'
    beq a0, t5, pause_loop      # Nếu nhấn phím '0', chuyển sang trạng thái tạm dừng

continue_play:
    addi t2, t2, 16        # Chuyển đến nốt tiếp theo (mỗi nốt chiếm 16 byte)
    j next_note            # Lặp lại phát nốt tiếp theo

pause_loop:
wait_resume:
    

end_main:
# -----------------------------------------------------------------
# Trình phục vụ ngắt
# -----------------------------------------------------------------
handler:
# Xử lý ngắt

prn_msg:
    li a7, 4              	# Gọi syscall để in thông báo ra màn hình
    la a0, message              # Tải địa chỉ chuỗi thông báo 'message' vào thanh ghi a0
    ecall                       

get_key_code:
    li t1, IN_ADDRESS_HEXA_KEYBOARD     # Tải địa chỉ nhập từ bàn phím hexa vào t1
    li t2, 0x01                          # Chọn hàng 4 của bàn phím và bật lại bit 7 (nếu có sử dụng bit enable)
    sb t2, 0(t1)                         # Ghi giá trị vào địa chỉ để chọn hàng 4 trên bàn phím
    li t1, OUT_ADDRESS_HEXA_KEYBOARD    # Tải địa chỉ đọc dữ liệu từ bàn phím hexa vào t1
    lb a0, 0(t1)                         # Đọc mã phím được nhấn và lưu vào a0
    beq a0, zero, i                      # Nếu không có phím nào được nhấn (a0 = 0), nhảy đến nhãn i
    beq a0, s0, a                        # Nếu phím tương ứng với giá trị trong s0 được nhấn, nhảy đến nhãn a
    beq a0, s1, b                        # Nếu phím tương ứng với giá trị trong s1 được nhấn, nhảy đến nhãn b
    beq a0, s2, c                        # Nếu phím tương ứng với giá trị trong s2 được nhấn, nhảy đến nhãn c
    beq a0, s3, d                        # Nếu phím tương ứng với giá trị trong s3 được nhấn, nhảy đến nhãn d

a:
    li a0, 0           # Gán giá trị 0 vào thanh ghi a0
    j next             # Nhảy đến nhãn next

b:
    li a0, 1           # Gán giá trị 1 vào thanh ghi a0
    j next             # Nhảy đến nhãn next

c:
    li a0, 2           # Gán giá trị 2 vào thanh ghi a0
    j next             # Nhảy đến nhãn next

d:
    li a0, 3           # Gán giá trị 3 vào thanh ghi a0
    j next             # Nhảy đến nhãn next

i:
    li a0, 4           # Gán giá trị 4 vào thanh ghi a0

next:
    csrrci zero, ustatus, 0x10   # Xóa bit 4 (pending)(0x10) trong thanh ghi ustatus (cờ ngắt) - đã xử lí xong ngắt
    csrrsi zero, ustatus, 1      # Đặt bit 0 trong thanh ghi ustatus - ngắt mới
    li s4, 1                     # Gán giá trị 1 vào thanh ghi s4 (dùng để so sánh)
    li s5, 2                     # Gán giá trị 2 vào thanh ghi s5
    li s6, 3                     # Gán giá trị 3 vào thanh ghi s6
    li s7, 4                     # Gán giá trị 4 vào thanh ghi s7
    beq a0, zero, h             # Nếu a0 = 0 thì nhảy đến nhãn h
    beq a0, s4, e               # Nếu a0 = 1 thì nhảy đến nhãn e
    beq a0, s5, f               # Nếu a0 = 2 thì nhảy đến nhãn f
    beq a0, s6, g               # Nếu a0 = 3 thì nhảy đến nhãn g
    beq a0, s7, j               # Nếu a0 = 4 thì nhảy đến nhãn j

h:
    la s8, loop         # Nạp địa chỉ của nhãn 'loop' vào thanh ghi s8.
    csrrw zero, uepc, s8  # Ghi giá trị từ s8 (địa chỉ của 'loop') vào uepc, đồng thời đọc uepc nhưng kết quả được ghi vào thanh ghi zero (bị mất).
    uret                # Thực hiện lệnh uret, nhảy đến địa chỉ được lưu trong uepc (chính là 'loop').

e:
    li a0, 1            # Nạp giá trị 1 vào thanh ghi a0 (có thể dùng để xác định trạng thái hay in ra thông tin).
    la s8, loop         # Nạp địa chỉ của nhãn 'loop' vào thanh ghi s8.
    csrrw zero, uepc, s8  # Ghi giá trị từ s8 vào uepc, đồng thời đọc giá trị cũ của uepc nhưng lưu vào thanh ghi zero (bị loại bỏ).
    uret                # Thực hiện lệnh uret, nhảy đến địa chỉ lưu trong uepc (lại là 'loop').

f:
    li a0, 2            # Nạp giá trị 2 vào thanh ghi a0.
    la s8, loop         # Nạp địa chỉ của 'loop' vào thanh ghi s8.
    csrrw zero, uepc, s8  # Ghi địa chỉ của 'loop' từ s8 vào uepc, bỏ qua giá trị cũ.
    uret                # Thực hiện lệnh uret, nhảy về địa chỉ được lưu trong uepc.

g:
    li a0, 3            # Nạp giá trị 3 vào thanh ghi a0.
    la s8, loop         # Nạp địa chỉ của nhãn 'loop' vào thanh ghi s8.
    csrrw zero, uepc, s8  # Ghi giá trị từ s8 (địa chỉ 'loop') vào uepc, thực hiện cập nhật CSR.
    uret                # Thực hiện lệnh uret, nhảy đến địa chỉ được lưu trong uepc.

j:
    li a0, 4            # Nạp giá trị 4 vào thanh ghi a0.
    la s8, loop         # Nạp địa chỉ của nhãn 'loop' vào thanh ghi s8.
    csrrw zero, uepc, s8  # Ghi giá trị từ s8 vào uepc, đồng thời đọc giá trị cũ của uepc nhưng kết quả lưu vào thanh ghi zero.
    uret                # Thực hiện lệnh uret, nhảy đến địa chỉ lưu trong uepc.

