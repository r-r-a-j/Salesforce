public class REST_RES_COMP_Result 
{
    public Integer statusCode;
    public REST_RES_COMP_Detail result;

    public REST_RES_COMP_Result(Integer statusCode, REST_RES_COMP_Detail result) 
    {
        this.statusCode = statusCode;
        this.result = result;
    }
}
