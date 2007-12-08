Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbXLHIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbXLHIKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXLHIJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:09:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:35300 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXLHIJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id;
        b=lSuL2r9MxOJtMx7mrusKuRR8U+KmjpSB3N3pe1vdx9nSEBdo87Zinq5sMqxqQ/lUUYg+BngKXlOqjoGF9Bf+eupL1wk8yraVD29IEoitjGVBGpFGlXd8nKU5si3kvlWk/Xwk/ziPUupu0aTR+Mx8SU27VgY2y1vOBsTzh3s6dyE=
Date: Sat,  8 Dec 2007 16:09:25 +0800
From: crquan@gmail.com
To: open-iscsi@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Subject: iscsi project page changed
Message-ID: <475a514e.20d7720a.39af.fffffa38@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a merging news happened two years ago:

	http://www.open-iscsi.org/

	Linux-iSCSI(sfnet) and Open-iSCSI projects merged!(April 11, 2005)
	http://marc.theaimsgroup.com/?l=linux-kernel&m=111327337005048&w=2

so the information should change,

and there are needs about iscsi documentation under Documentation/scsi/,
or just some links to the documents on the website.

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a6676be..3e75b24 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -341,7 +341,7 @@ config ISCSI_TCP
 	 The userspace component needed to initialize the driver, documentation,
 	 and sample configuration files can be found here:
 
-	 http://linux-iscsi.sf.net
+	 http://www.open-iscsi.org/
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
