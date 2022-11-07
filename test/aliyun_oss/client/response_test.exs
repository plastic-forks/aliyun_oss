defmodule Aliyun.Oss.Client.ResponseTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Response

  alias Aliyun.Oss.Client.Response

  describe "parse/1" do
    test "parse plain text" do
      assert %Response{
               data: "plain text",
               headers: [
                 {"Content-Length", "250"}
               ]
             } = Response.parse("plain text", [{"Content-Length", "250"}])
    end

    @xml """
    <?xml version="1.0" encoding="UTF-8"?>
    <ListAllMyBucketsResult>
      <Owner>
        <ID>12345</ID>
        <DisplayName>12345</DisplayName>
      </Owner>
      <Buckets>
        <Bucket>
          <CreationDate>2018-10-12T07:57:51.000Z</CreationDate>
          <ExtranetEndpoint>oss-cn-shenzhen.aliyuncs.com</ExtranetEndpoint>
          <IntranetEndpoint>oss-cn-shenzhen-internal.aliyuncs.com</IntranetEndpoint>
          <Location>oss-cn-shenzhen</Location>
          <Name>Bucket1</Name>
          <StorageClass>Standard</StorageClass>
        </Bucket>
        <Bucket>
          <CreationDate>2018-09-20T01:49:43.000Z</CreationDate>
          <ExtranetEndpoint>oss-cn-shenzhen.aliyuncs.com</ExtranetEndpoint>
          <IntranetEndpoint>oss-cn-shenzhen-internal.aliyuncs.com</IntranetEndpoint>
          <Location>oss-cn-shenzhen</Location>
          <Name>Bucket2</Name>
          <StorageClass>Standard</StorageClass>
        </Bucket>
      </Buckets>
      <Prefix></Prefix>
      <Marker></Marker>
      <MaxKeys>2</MaxKeys>
      <IsTruncated>true</IsTruncated>
      <NextMarker>Bucket2</NextMarker>
    </ListAllMyBucketsResult>
    """
    test "parse xml to map" do
      bucket1 = %{
        "Name" => "Bucket1",
        "Location" => "oss-cn-shenzhen",
        "StorageClass" => "Standard",
        "CreationDate" => "2018-10-12T07:57:51.000Z",
        "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
        "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com"
      }

      bucket2 = %{
        "Name" => "Bucket2",
        "Location" => "oss-cn-shenzhen",
        "StorageClass" => "Standard",
        "CreationDate" => "2018-09-20T01:49:43.000Z",
        "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
        "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com"
      }

      assert %Response{
               data: %{
                 "ListAllMyBucketsResult" => %{
                   "Owner" => %{"ID" => "12345", "DisplayName" => "12345"},
                   "Prefix" => nil,
                   "Marker" => nil,
                   "MaxKeys" => 2,
                   "IsTruncated" => true,
                   "NextMarker" => "Bucket2",
                   "Buckets" => %{"Bucket" => [^bucket1, ^bucket2]}
                 }
               },
               headers: [
                 {"Content-Length", "250"},
                 {"Content-Type", "application/xml"}
               ]
             } =
               Response.parse(@xml, [
                 {"Content-Length", "250"},
                 {"Content-Type", "application/xml"}
               ])
    end

    test "parse json to map" do
      assert %Response{
               data: %{"foo" => "bar"},
               headers: [
                 {"Content-Length", "250"},
                 {"Content-Type", "application/json"}
               ]
             } =
               Response.parse(~S[{"foo":"bar"}], [
                 {"Content-Length", "250"},
                 {"Content-Type", "application/json"}
               ])
    end
  end
end
