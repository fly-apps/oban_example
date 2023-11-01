defmodule Fly do
  @doc """
  Execute the MFA on a node in the primary region.
  """
  @spec rpc_primary(module(), atom(), [any()], keyword()) :: any()
  def rpc_primary(module, func, args, opts \\ []) do
    Fly.RPC.rpc_region(:primary, {module, func, args}, opts)
  end
end
