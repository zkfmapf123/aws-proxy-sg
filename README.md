# SG-Best-Architecture (SG를 Proxy 형태로 사용하기)

## EC2에 mysql 설치

```sh
    ## Install mysql
    sudo yum install mysql -y 

    ## mysql connect
    mysql -h [host] -P [port] -u [name]
```

## Required

- [x] Proxy 형태로 SG 구성하는 방법
- [x] Proxy 형태로 3306 만 통신 가능한가?
- [x] External IP들로만 구성하기
- [x] Internal IP들로만 구성하기
- [x] 특정 그룹은 특정 SG만 사용하게끔 구성하기 (ABAC)

```json
// Describe는 기본적으로 PrincipalTag를 가지고있지만 ABAC형태로는 불가능하다...
{
"Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "ec2:Describe*"
   ],
   "Resource": "*"
  },
  {
   "Effect": "Allow",
   "Action": [
    "ec2:AuthorizeSecurityGroupIngress"
   ],
   "Resource": "*",
   "Condition": {
    "StringEquals": {
     "ec2:ResourceTag/Team": "${aws:PrincipalTag/Team}"
    }
   }
  }
 ]
 }
```

- <a href="https://aws.amazon.com/ko/blogs/tech/ec2-iam-policy-for-abac/"> ABAC </a>
