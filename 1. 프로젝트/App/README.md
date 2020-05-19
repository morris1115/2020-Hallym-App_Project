#### DB 생성 쿼리  
CREATE SEQUENCE seq_id START 1; 

-- Table: public.temporage_data

-- DROP TABLE public.temporage_data;
```
CREATE TABLE public.temporage_data   
(
    id integer NOT NULL DEFAULT nextval('seq_id'::regclass),
    key text COLLATE pg_catalog."default" NOT NULL,
    value text COLLATE pg_catalog."default" NOT NULL,
    create_time timestamp without time zone NOT NULL,
    CONSTRAINT temporage_data_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.temporage_data OWNER to postgres;

```

#### 기능
1. key, value를 받아 DB에 저장한다.
2. key 값으로 DB에 있는 값을 Searching 해서 결과를 반환한다.
3. (예정)저장 후 이틀 이상 지난 값은 삭제한다. 
(매일 00시 마다 DB에서 삭제. Searching 해서 return 할 때 한번 더 check 해서 이틀이 지난 값은 return 되지 않게 함)

### API
#### /save : parameter - key, value
##### 해당 parameter로 request를 보내 DB에 저장. 현재 시간도 함께 저장.
#### /getData : parameter - key
##### key로 값을 찾아 return함. key, value, datetime이 return 됨.

#### 추가 기능 예정
##### [ ]SNS와 연동. 내용을 바로 SNS에 올릴 수 있게 해줌
---

# PROJECT 04/25 
### API
- /sign-up : parameter - email, password, name 
    - return type : String 
- /sign-in : parameter - email, password 
    - return type : String

# PROJECT 04/27
- 회원가입, 로그인 기능 추가. 
- 세션 기능 추가 예정 
- CI/CD git 연동 및 배포 완료. 

# PROJECT 05/05
- Get 메소드 파트 수정
- DataBase 연동 수정

# PROJECT 05/19
- 세션 오류로 세션 파트 수정
- ddl-auto 수정 / 서버가 종료 되어도 아이디, 비밀번호가 유지되도록 수정
---

# result_code

```
0 : unexecpt error
1 : success
2 : email is not correct
3 : password is not correct
4 : Session ID is not correct 
```

---
# 메소드 설명
### @RunWith(SpringRunner.class)
- 테스트를 진행할 때 JUnit에 내장된 실행자 외에 다른 실행자를 실행시킨다.
여기서는 SpringRunner라는 스프링 실행자를 사용한다. 즉 스프링 부트 테스트와 JUnit 사이에 연결자 역할을 한다.
### @WebMvcTest
- 여러 스프링 어노테이션중 Web에 집중할 수 있는 어노테이션 전체 어노테이션의 자동완성을 중단하는 대신, MVC설정에 해당하는 자동완성만 활성화를 한다.
### @WebMvcTest annotation is used for Spring MVC tests. It disables full auto-configuration and instead apply only configuration relevant to MVC tests.
### @Autowired
- 스프링이 관리하는 Bean을 주입받는다.
### private  MockMvc mvc
- 웹 API를 테스트할 떄 사용한다. 테스트의 시작점이다. 이 클래스로 HTTP GET, POST 등의 API를 테스트 할 수 있음

### mvc.perform(get("/hello"))
### MockMvc를 통해 /hello 로 HTTP GET 을 request 한다
### status().isOk() 
### mvc.perform의 결과를 검증한다. http status(200, 404, 500 등) 의 반환값을 가진다.
### content().string(hello)
### mvc.perform 의 결과를 검증한다. 본문의 내용에서 값이 맞는지 검증한다.
