Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0BHGWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:22:04 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36892 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0BHGV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:21:59 -0500
Message-ID: <4B6FAD84.5070804@linux.vnet.ibm.com>
Date: Mon, 08 Feb 2010 11:51:56 +0530
From: Rishikesh <risrajak@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: risrajak@in.ibm.com, subrata@linux.vnet.ibm.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, svishuku@in.ibm.com,
       "paul.larson" <paul.larson@ubuntu.com>,
       Garrett Cooper <yanegomi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       iranna.ankad@in.ibm.com
Subject: [PATCH]: Changed in LTP maintainership responsibilities
Content-Type: multipart/mixed;
 boundary="------------020900030104020201000202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020900030104020201000202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi List,

Please include this patch in mainline kernel.

LTP maintainer responsibities have changed from 2010.

Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2

Signed-off By : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
---
Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS  2010-02-08 11:27:59.000000000 +0530
+++ linux-2.6/MAINTAINERS       2010-02-08 11:44:42.000000000 +0530
@@ -3411,6 +3411,7 @@
  F:     drivers/scsi/sym53c8xx_2/

  LTP (Linux Test Project)
+M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
  M:     Subrata Modak <subrata@linux.vnet.ibm.com>
  M:     Mike Frysinger <vapier@gentoo.org>
  L:     ltp-list@lists.sourceforge.net (subscribers-only)


--------------020900030104020201000202
Content-Type: text/plain;
 name="maintainr-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="maintainr-changes.patch"

Changed the LTP maintainer responsibities from 2010.

Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2

Signed-off By : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
---
Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2010-02-08 11:27:59.000000000 +0530
+++ linux-2.6/MAINTAINERS	2010-02-08 11:44:42.000000000 +0530
@@ -3411,6 +3411,7 @@
 F:	drivers/scsi/sym53c8xx_2/
 
 LTP (Linux Test Project)
+M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
 M:	Subrata Modak <subrata@linux.vnet.ibm.com>
 M:	Mike Frysinger <vapier@gentoo.org>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)

--------------020900030104020201000202--
