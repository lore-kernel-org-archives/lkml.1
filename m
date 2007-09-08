Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXIHATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXIHATB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 20:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXIHASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 20:18:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:31878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXIHASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 20:18:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,223,1186383600"; 
   d="scan'208";a="290266338"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jgarzik@pobox.com, jason.d.gaston@intel.com
Subject: [PATCH 2.6.23-rc5] ata_piix: replace spaces with tabs
Date: Fri, 7 Sep 2007 17:21:03 -0700
User-Agent: KMail/1.9.1
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709071721.04170.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some incorrect formatting spaces and replaces them with tabs.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc5/drivers/ata/ata_piix.c.orig	2007-09-07 17:11:55.000000000 -0700
+++ linux-2.6.23-rc5/drivers/ata/ata_piix.c	2007-09-07 17:13:24.000000000 -0700
@@ -445,15 +445,15 @@
 };
 
 static const struct piix_map_db tolapai_map_db = {
-        .mask = 0x3,
-        .port_enable = 0x3,
-        .map = {
-                /* PM   PS   SM   SS       MAP */
-                {  P0,  NA,  P1,  NA }, /* 00b */
-                {  RV,  RV,  RV,  RV }, /* 01b */
-                {  RV,  RV,  RV,  RV }, /* 10b */
-                {  RV,  RV,  RV,  RV },
-        },
+	.mask = 0x3,
+	.port_enable = 0x3,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  NA,  P1,  NA }, /* 00b */
+		{  RV,  RV,  RV,  RV }, /* 01b */
+		{  RV,  RV,  RV,  RV }, /* 10b */
+		{  RV,  RV,  RV,  RV },
+	},
 };
 
 static const struct piix_map_db *piix_map_db_table[] = {
