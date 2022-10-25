const String appLogo = "logo-transparent.png";
const String appLogoWhite = "logo-white.png";

const String authHeader = "Authorization";
// const String rootUrl = "http://139.177.185.213:8080";
// const String cmsUrl = 'http://cms.stnta.com';

// const String rootUrl = "http://18.142.112.152:3001";
// const String cmsUrl = 'http://18.142.112.152:1337';

const String rootUrl = "https://api-test.hypermonhml.xyz";
const String cmsUrl = 'https://cms-test.hypermonhml.xyz';
const String baseUrl = '$rootUrl/api';
const String jwtTokenKey = 'jwt_access_token';
const String fcmTokenKey = 'fcm_access_token';

// X-Authorization if server doesn't support Authorization header
const String isBearer = authHeader == "X-Authorization" ? "" : "Bearer";

//** Change Company Name to show on Payment pages
const String companyName = "Super English";
const String bundleName = "com.stn.lms";

//** Change Currency
const String appCurrency = 'vnđ';
