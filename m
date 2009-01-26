Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZAZCHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZAZCHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZAZCHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:07:18 -0500
Received: from vps1.tull.net ([66.180.172.116]:36463 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754149AbZAZCHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:07:17 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 02/20] Fix misspelling of "firmware" in firmware.txt
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:00:28 +1100
Message-ID: <20090126020028.15168.2071.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in firmware.txt

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 .../dts-bindings/fsl/cpm_qe/qe/firmware.txt        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
index 6c238f5..249db3a 100644
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
+++ b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
@@ -1,6 +1,6 @@
 * Uploaded QE firmware
 
-      If a new firwmare has been uploaded to the QE (usually by the
+      If a new firmware has been uploaded to the QE (usually by the
       boot loader), then a 'firmware' child node should be added to the QE
       node.  This node provides information on the uploaded firmware that
       device drivers may need.

