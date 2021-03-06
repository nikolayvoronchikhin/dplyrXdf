% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zzz_non_xdf_srcs.R
\name{nonxdf}
\alias{nonxdf}
\alias{non_xdf}
\title{Methods for non-Xdf RevoScaleR data sources}
\description{
Despite the name, dplyrXdf can work with any RevoScaleR data source, not just Xdf files. These are the verbs that can accept as inputs non-Xdf data sources.
}
\details{
There are a number of ways in which dplyrXdf verbs handle non-Xdf data sources:
\enumerate{
  \item File data sources, including delimited text (\code{\link{RxTextData}}), Avro (\code{RxAvroData}), SAS datasets (\code{\link{RxSasData}}) and SPSS datasets (\code{\link{RxSpssData}}), are generally handled inline, ie, they are read and processed much like an Xdf file would be.
  \item ODBC data sources, including \code{\link{RxOdbcData}}, \code{\link{RxSqlServerData}} and \code{\link{RxTeradata}} usually represent tables in a SQL database. These data sources are converted into a dplyr tbl, which is then processed by dplyr (\emph{not} dplyrXdf) in-database.
 \item A Hive table (\code{\link{RxHiveData}}) in HDFS is turned into a sparklyr tbl and processed by sparklyr.
 \item Other data sources are converted to Xdf format and then processed. The main difference between this and 1) above is that the data is written to an Xdf file first, before being transformed; this is less efficient due to the extra I/O involved.
}

Running a pipeline in-database requires that a suitable dplyr backend for the DBMS in question be available. There are backends for many popular commercial and open-source DBMSes, including SQL Server, PostgreSQL and Apache Hive; a Teradata backend is not yet available, but is in development at the time of writing (September 2017). For more information on how dplyr executes pipelines against database sources, see the \href{http://dbplyr.tidyverse.org/articles/dbplyr.html}{database vignette} on the Tidyverse website. Using this functionality does require you to install a few additional packages, namely odbc and dbplyr (and their dependencies).

Similarly, running a pipeline on a Hive data source with sparklyr requires that package to be installed. You must also be running on the edge node of a Spark cluster (not on a remote client, and not on a Hadoop cluster). For best results it's recommended that you use \code{\link[=rxSparkConnect]{rxSparkConnect(interop="sparklyr")}} to set the compute context; otherwise, dplyrXdf will open a separate sparklyr connection via \code{spark_connect(master="yarn-client")}, which may or may not be appropriate for your cluster. More information about sparklyr is available on the \href{https://spark.rstudio.com/}{Rstudio Sparklyr site}.

While running a pipeline in-database or in-Spark can often be much more efficient than running the code locally, there are a few points to be aware of.
\itemize{
  \item For in-database pipelines, each pipeline will open a separate connection to the database; this connection remains open while any tbl objects related to the pipeline still exist. This is unlikely to cause problems for interactive use, but may do so if the code is reused for batch jobs, eg as part of a predictive web service.
  \item Which verbs are supported will vary by backend. For example, \code{factorise} and \code{do_xdf} are meant for Xdf files, and will probably fail inside a database.
  \item The Xdf-specific arguments \code{.outFile} and \code{\link{.rxArgs}} are not available in-database or in sparklyr. In particular, this means you cannot use a \link[=rxTransform]{transformFunc} to carry out arbitrary transformations on the data.
}
}
