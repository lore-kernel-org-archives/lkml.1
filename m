Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbXIDOQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbXIDOQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXIDOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:16:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:36634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXIDOQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:16:28 -0400
Date: Tue, 4 Sep 2007 16:16:26 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] Update version information of ips driver
Message-ID: <20070904141626.GA9777@suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just makes the version number in ips.c and ips.h consistent. It
seems that this has been forgotten in a60768e2d43eb30a1adb8a119aeac35dc0d03ef6.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/ips.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -1175,9 +1175,9 @@ typedef struct {
 #define IPS_VER_MAJOR_STRING "7"
 #define IPS_VER_MINOR 12
 #define IPS_VER_MINOR_STRING "12"
-#define IPS_VER_BUILD 02
-#define IPS_VER_BUILD_STRING "02"
-#define IPS_VER_STRING "7.12.02"
+#define IPS_VER_BUILD 05
+#define IPS_VER_BUILD_STRING "05"
+#define IPS_VER_STRING "7.12.05"
 #define IPS_RELEASE_ID 0x00020000
 #define IPS_BUILD_IDENT 761
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. All Rights Reserved."
