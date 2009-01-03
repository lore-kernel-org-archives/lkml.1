Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbZACIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbZACIBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 03:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 03:01:12 -0500
Received: from vps1.tull.net ([66.180.172.116]:36669 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZACIBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 03:01:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 11/11] Fix misspelling of "firmware" in docs for	ncr53c8xx/sym53c8xx
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 19:00:37 +1100
Message-ID: <20090103080026.27466.25064.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in docs for ncr53c8xx/sym53c8xx

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 Documentation/scsi/ChangeLog.ncr53c8xx |    2 +-
 Documentation/scsi/ChangeLog.sym53c8xx |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/Documentation/scsi/ChangeLog.ncr53c8xx b/Documentation/scsi/ChangeLog.ncr53c8xx
index a9f721a..8b278c1 100644
--- a/Documentation/scsi/ChangeLog.ncr53c8xx
+++ b/Documentation/scsi/ChangeLog.ncr53c8xx
@@ -19,7 +19,7 @@ Sun Sep 24 21:30 2000 Gerard Roudier (groudier@club-internet.fr)
 
 Wed Jul 26 23:30 2000 Gerard Roudier (groudier@club-internet.fr)
 	* version ncr53c8xx-3.4.1
-	- Provide OpenFirmare path through the proc FS on PPC.
+	- Provide OpenFirmware path through the proc FS on PPC.
 	- Remove trailing argument #2 from a couple of #undefs.
 
 Sun Jul 09 16:30 2000 Gerard Roudier (groudier@club-internet.fr)
diff --git a/Documentation/scsi/ChangeLog.sym53c8xx b/Documentation/scsi/ChangeLog.sym53c8xx
index ef985ec..02ffbc1 100644
--- a/Documentation/scsi/ChangeLog.sym53c8xx
+++ b/Documentation/scsi/ChangeLog.sym53c8xx
@@ -81,7 +81,7 @@ Sun Sep 24 21:30 2000 Gerard Roudier (groudier@club-internet.fr)
 
 Wed Jul 26 23:30 2000 Gerard Roudier (groudier@club-internet.fr)
 	* version sym53c8xx-1.7.1
-	- Provide OpenFirmare path through the proc FS on PPC.
+	- Provide OpenFirmware path through the proc FS on PPC.
 	- Download of on-chip SRAM using memcpy_toio() doesn't work 
 	  on PPC. Restore previous method (MEMORY MOVE from SCRIPTS).
 	- Remove trailing argument #2 from a couple of #undefs.

