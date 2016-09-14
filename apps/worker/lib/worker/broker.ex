defmodule Worker.Broker do
  @callback handle(String.t) :: {:ok, String.t} | {:partial, String.t} | {:error, String.t}
end
