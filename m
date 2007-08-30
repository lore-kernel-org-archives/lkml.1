Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbXH3Sq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbXH3Sq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXH3SqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:46:19 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40139
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751579AbXH3SqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:46:18 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/00-INDEX notice ecryptfs.txt moved.
Date: Thu, 30 Aug 2007 14:46:17 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301446.18024.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

ecryptfs.txt moved into Documentation/filesystems, so move the 00-INDEX entry.

--- linux-2.6.23-rc4/Documentation/00-INDEX	2007-08-27 20:32:35.000000000 -0500
+++ linux-new/Documentation/00-INDEX	2007-08-30 14:43:15.000000000 -0500
@@ -134,8 +134,6 @@
 	- info on Linux Digital Video Broadcast (DVB) subsystem.
 early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
-ecryptfs.txt
-	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 eisa.txt
 	- info on EISA bus support.
 exception.txt
--- linux-2.6.23-rc4/Documentation/filesystems/00-INDEX	2007-08-27 20:32:35.000000000 -0500
+++ linux-new/Documentation/filesystems/00-INDEX	2007-08-30 14:42:08.000000000 -0500
@@ -32,6 +32,8 @@
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
+ecryptfs.txt
+	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
