defmodule DBListener.Users.User do
  use DBListener.Schema

  @type t :: %__MODULE__{
          name: String.t(),
          age: :integer
        }

  schema "users" do
    field :age, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
