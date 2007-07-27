Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbXG0S2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbXG0S2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbXG0S1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:27:53 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:59115 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbXG0S1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DQSmjiLfme5xa6KRSMVrAyGOT25yj43vBcnsZ2VXZR0njjWCOqCNp0m1PX4nfRDGBSHBkKEWWTlUA4qSre1DbPp9ZOZw5UlMUfKNreMhoqK/R/VW7XGFERoGdw/hMbqUYUWy83Yj9cLmp69Cpdx6z/QjhwtouKwnK/f9IAkxNOE=
Message-ID: <499d6ed30707271127q4c918648q2509c5e09862af8c@mail.gmail.com>
Date: Fri, 27 Jul 2007 13:27:51 -0500
From: "Kent Yoder" <shpedoikal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: tpmdd maintainers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I probably won't have time to look at the latest tpm_tis bug until
next week, but here's a patch fix up the maintainers info in the tpm
drivers.  Kylene will be out for some time, so copying the sourceforge
list is the best way to get some attention.

Thanks,
Kent

diff -purN a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
--- a/drivers/char/tpm/tpm_atmel.c      2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm_atmel.c      2007-07-27 13:14:07.000000000 -0500
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -purN a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
--- a/drivers/char/tpm/tpm_atmel.h      2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm_atmel.h      2007-07-27 13:14:54.000000000 -0500
@@ -4,7 +4,7 @@
  * Authors:
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -purN a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c       2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm_bios.c       2007-07-27 13:14:25.000000000 -0500
@@ -7,6 +7,8 @@
  *     Reiner Sailer <sailer@watson.ibm.com>
  *     Kylene Hall <kjhall@us.ibm.com>
  *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
  * Access to the eventlog extended by the TCG BIOS of PC platform
  *
  * This program is free software; you can redistribute it and/or
diff -purN a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c    2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm.c    2007-07-27 13:13:28.000000000 -0500
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -purN a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h    2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm.h    2007-07-27 13:13:50.000000000 -0500
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -purN a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
--- a/drivers/char/tpm/tpm_nsc.c        2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm_nsc.c        2007-07-27 13:14:39.000000000 -0500
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -purN a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c        2007-07-10 13:56:30.000000000 -0500
+++ b/drivers/char/tpm/tpm_tis.c        2007-07-27 13:13:40.000000000 -0500
@@ -5,6 +5,8 @@
  * Leendert van Doorn <leendert@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
  *
diff -purN a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS       2007-07-10 13:56:30.000000000 -0500
+++ b/MAINTAINERS       2007-07-27 13:11:31.000000000 -0500
@@ -3316,7 +3316,7 @@ S:        Maintained

 TPM DEVICE DRIVER
 P:     Kylene Hall
-M:     kjhall@us.ibm.com
+M:     tpmdd-devel@lists.sourceforge.net
 W:     http://tpmdd.sourceforge.net
 P:     Marcel Selhorst
 M:     tpm@selhorst.net


-- 
Kent Yoder
IBM LTC Security Dev.
