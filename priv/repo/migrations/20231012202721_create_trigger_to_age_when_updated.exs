defmodule DBListener.Repo.Migrations.CreateTriggerToAgeWhenUpdated do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION notify_age_updated()
      RETURNS trigger AS $trigger$
      DECLARE
        payload TEXT;
      BEGIN
        IF (TG_OP = 'UPDATE') AND (OLD.age != NEW.age) THEN
          payload := json_build_object('id',OLD.id,'old',row_to_json(OLD),'new',row_to_json(NEW));
          PERFORM pg_notify('notify_age_updated', payload);
        END IF;

        RETURN NEW;
      END;
      $trigger$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER notify_age_updated_trigger
      AFTER UPDATE ON users FOR EACH ROW
      WHEN ( OLD.age IS DISTINCT FROM NEW.age )
      EXECUTE PROCEDURE notify_age_updated();
    """
  end

  def down do
    execute """
    DROP TRIGGER notify_age_updated_trigger ON users;
    """

    execute """
    DROP FUNCTION notify_age_updated();
    """
  end
end
