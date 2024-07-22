# Debian

* <https://wiki.debian.org/UpstreamMetadata>
  + <https://wiki.debian.org/debian/upstream>
  + <https://dep-team.pages.debian.net/deps/dep12/>

```sql
-- DuckDB
-- $ duckdb

.read 'sketch/debian-udd/attach-pg-udd-mirror.duckdb.sql'

.read 'sketch/debian-udd/sources-tesseract-lang.duckdb.sql'

```

```sql
-- PostgreSQL
-- $ psql "postgresql://udd-mirror:udd-mirror@udd-mirror.debian.net/udd"

\i sketch/debian-udd/upstream-watch_file.postgres.sql

```

* <https://wiki.debian.org/RDF>
  + <https://packages.qa.debian.org/common/RDF.html>
  + <https://wiki.debian.org/qa.debian.org/pts/RdfInterface>
  + <http://www-public.telecom-sudparis.eu/~berger_o/papier-oss2013/>
    + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/tag/adms-sw/>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2012/08/24/generating-rdf-description-of-debian-package-sources-with-adms-sw/index.html>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2012/08/29/debian-package-tracking-system-now-produces-rdf-description-of-source-packages/index.html>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2012/11/25/presented-generating-linked-data-descriptions-of-debian-packages-in-the-debian-pts-at-the-paris-mini-debconf/index.html>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2013/02/01/the-debian-package-tracking-system-now-publishes-turtle-rdf-meta-data/index.html>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2013/05/24/first-deployment-of-the-fusionforge-adms-sw-plugin-publishing-projects-meta-data-as-linked-data/index.html>
      + <https://www-public.imtbs-tsp.eu/~berger_o/weblog/2013/06/06/new-paper-authoritative-linked-data-descriptions-of-debian-source-packages-using-adms-sw-accepted-at-oss-2013/index.html>
      + <http://www-public.telecom-sudparis.eu/~berger_o/weblog/2013/07/08/experimenting-with-linked-open-data-about-floss-projects-matching-debian-upstream-projects/index.html>
    + <https://www-public.imtbs-tsp.eu/~berger_o/weblog/2013/04/05/using-rdf-metadata-for-traceability-among-projects-and-distributions-presented-at-distrorecipes-2013/index.html>



* <https://github.com/tannewt/open-source-watershed>
    * <https://tannewt.org/slides/shawcroft-thesis_presentation.pdf>
    * <https://tannewt.org/docs/shawcroft-thesis.pdf>
* <https://github.com/iksaif/euscan>
    * <https://gitweb.gentoo.org/proj/euscan.git/log/>
