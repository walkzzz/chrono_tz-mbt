.PHONY: check test fmt info clean all

# 工程严格度：四后端 --deny-warn 零警告强制
check:
	moon check --deny-warn --target all

# 四后端测试
test:
	moon test --target all

# 格式化 + 接口更新
fmt:
	moon fmt
	moon info

# 完整检查：格式 + 接口 + deny-warn + 测试
all: fmt check test

clean:
	moon clean