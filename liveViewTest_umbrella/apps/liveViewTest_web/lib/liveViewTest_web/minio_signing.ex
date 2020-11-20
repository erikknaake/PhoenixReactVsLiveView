defmodule LiveViewTestWeb.MinioSigning do
  @moduledoc false
  @type signed_post_policy :: %{
                                formData: %{
                                  key: String.t,
                                  bucket: String.t,
                                  "x-amz-date": String.t,
                                  "x-amz-algorithm": String.t,
                                  "x-amz-credential": String.t,
                                  "x-amz-signature": String.t,
                                  policy: String.t
                                },
                                postURL: String.t
                              }

  @type signing_config :: %{
                            expire_seconds: integer,
                            object: String.t,
                            bucket: String.t,
                            region: String.t,
                            access_key_id: String.t,
                            secret_key: String.t,
                            host: String.t,
                            port: integer,
                            protocol: String.t
                            # Should be http or https
                          }

  @type policy :: %{
                    formData: Map.t,
                    policy: %{
                      conditions: List.t,
                      expiration: DateTime.t
                    }
                  }

  @default_policy %{
    "formData" =>
    %{
      "key" => nil,
      "bucket" => nil,
      "x-amz-date" => nil,
      "x-amz-algorithm" => nil,
      "x-amz-credential" => nil,
      "x-amz-signature" => nil
    },
    "policy" => %{
      "conditions" => [],
      "expiration" => nil
    }
  }

  @spec pre_signed_post_policy(signing_config) :: signed_post_policy
  def pre_signed_post_policy(config, date_time \\ DateTime.utc_now()) do
    datetime_string = makeDate(date_time)
    policy =
      @default_policy
      |> add_expiration(date_time, config.expire_seconds)
      |> add_credential(config.access_key_id, config.region, date_time)
      |> add_algorithm()
      |> add_date(datetime_string)
      |> add_content_length(0, 209715200)
      |> add_bucket(config.bucket)
      |> add_key(config.object)
    #    IO.puts("Policy: #{IO.inspect(policy)}")
    #    IO.puts("Policy.policy: #{IO.inspect(policy)}")
    %{"policy" => policy_value} = policy
    IO.puts("Policy value:")
    IO.inspect(policy_value)
    json = Jason.encode!(policy_value)
    IO.puts("json")
    IO.inspect(json)
    base64_policy = Base.encode64(json)
    IO.puts("base64_policy:")
    IO.inspect(base64_policy)
    signature = post_pre_sign_signature_v4(config.region, date_time, config.secret_key, base64_policy)
    %{"formData" => policy_form_data} = policy
    formData = Map.merge(
      policy_form_data,
      %{
        "policy" => base64_policy,
        "x-amz-signature" => signature
      }
    )
    port_str = case config.port do
      80 -> ""
      443 -> ""
      value -> ":#{value}"
    end
    url = "#{config.protocol}://#{config.host}#{port_str}/#{config.bucket}"
    %{postURL: url, formData: formData}
  end

  @spec makeDate(DateTime.t) :: {String.t}
  defp makeDate(date_time) do
    Timex.format!(date_time, "{YYYY}{M}{D}T{h24}{m}{s}Z")
  end

  defp add_content_length(
         %{
           "formData" => _formData,
           "policy" => %{
             "conditions" => conditions,
             "expiration" => expiration
           }
         } = policy,
         min,
         max
       ) do
    %{
      policy |
      "policy" => %{
        "conditions" => [["content-length-range", min, max] | conditions],
        "expiration" => expiration
      }
    }
  end

  @spec add_key(policy, String.t) :: policy
  defp add_key(policy, key) do
    add_property(policy, "key", key)
  end

  @spec add_bucket(policy, String.t) :: policy
  defp add_bucket(policy, bucket) do
    add_property(policy, "bucket", bucket)
  end

  @spec add_expiration(policy, DateTime, integer) :: policy
  defp add_expiration(
         %{
           "formData" => _formData,
           "policy" => %{
             "conditions" => conditions,
             "expiration" => _
           }
         } = policy,
         datetime,
         expiration
       ) do
    %{
      policy |
      "policy" => %{
        "conditions" => conditions,
        "expiration" => DateTime.add(datetime, expiration, :second)
                        |> DateTime.to_iso8601()
      }
    }
  end

  @spec add_date(policy, String.t) :: policy
  defp add_date(policy, datetime_string) do
    add_property(policy, "x-amz-date", datetime_string)
  end

  @spec add_property(policy, String.t, string) :: policy
  defp add_property(
         %{
           "formData" => formData,
           "policy" => %{
             "conditions" => conditions,
             "expiration" => expiration
           }
         } = policy,
         key,
         value
       ) do
    %{
      policy |
      "formData" => %{
        formData |
        "#{key}" => value
      },
      "policy" => %{
        "conditions" => [["eq", "$#{key}", value] | conditions],
        "expiration" => expiration
      }
    }
  end

  @spec add_algorithm(policy) :: policy
  defp add_algorithm(policy) do
    add_property(policy, "x-amz-algorithm", "AWS4-HMAC-SHA256")
  end

  @spec add_credential(policy, String.t, String.t, DateTime.t) :: policy
  defp add_credential(
         policy,
         access_key_id,
         region,
         datetime
       ) do
    add_property(policy, "x-amz-credential", "#{access_key_id}/#{get_scope(region, datetime)}")
  end

  @spec get_scope(String.t, DateTime.t) :: String.t
  defp get_scope(region, datetime) do
    "#{make_short_date(datetime)}/#{region}/s3/aws4_request"
  end

  @spec make_short_date(DateTime.t) :: String.t
  defp make_short_date(date) do
    Timex.format!(date, "{YYYY}{M}{D}")
  end

  defp hmac(key, value) do
    :crypto.hmac(:sha256, key, value)
  end

  defp post_pre_sign_signature_v4(region, datetime, secret_key, base64_policy) do
    get_signing_key(datetime, region, secret_key)
    |> hmac(base64_policy)
    |> Base.encode16(case: :lower)
  end

  defp get_signing_key(date, region, secret_key) do
    # TODO check if this is correct
    "AWS4#{secret_key}"
    |> hmac(make_short_date(date))
    |> hmac(region)
    |> hmac("s3")
    |> hmac("aws4_request")
  end
end
