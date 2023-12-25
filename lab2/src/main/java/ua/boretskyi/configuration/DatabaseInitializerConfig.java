package ua.boretskyi.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.sql.DataSource;
import java.util.List;

@Configuration
public class DatabaseInitializerConfig {

    @PersistenceContext
    private final EntityManager entityManager;
    private final DataSource dataSource;
    private final String setupScript;
    private final String schemaName;
    private static final Logger log = LoggerFactory.getLogger(DatabaseInitializerConfig.class);


    @Autowired
    public DatabaseInitializerConfig(EntityManager entityManager, DataSource dataSource,
                                     @Value("${db-setup-script}") String setupScript,
                                     @Value("${schema-name}") String schemaName) {
        this.entityManager = entityManager;
        this.dataSource = dataSource;
        this.setupScript = setupScript;
        this.schemaName = schemaName;
    }

    @Bean
    public ApplicationRunner databaseInitializerRunner() {
        return new ApplicationRunner() {
            @Override
            @Transactional
            public void run(ApplicationArguments args) {
                if (databaseIsEmpty()) {
                    log.info("Database is empty. Executing setup script.");
                    executeScript();
                    log.info("Script executed successfully.");
                } else {
                    log.info("Database is not empty. No need to execute setup script.");
                }
            }

            private boolean databaseIsEmpty() {
                String sqlQuery = "SELECT table_name FROM information_schema.tables WHERE table_schema = :schemaName";

                List<?> tableNames = entityManager.createNativeQuery(sqlQuery)
                        .setParameter("schemaName", schemaName)
                        .getResultList();

                return tableNames.isEmpty();
            }

            private void executeScript() {
                ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
                populator.addScripts(new ClassPathResource(setupScript));
                populator.setSeparator(";");
                populator.execute(dataSource);
            }
        };
    }
}
