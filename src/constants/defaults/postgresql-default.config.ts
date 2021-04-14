import { join } from 'path';
import { LiquibaseConfig } from 'models';

export const POSTGRESQL_DEFAULT_CONFIG: LiquibaseConfig = {
	changeLogFile: '/examples/change-log-examples/postgreSQL/changelog.xml',
	url: 'jdbc:postgresql://localhost:5432/postgres',
	username: 'postgres',
	password: '',
	classpath: join(__dirname, '../../../drivers/postgresql-42.2.8.jar')
}
