Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYHUDRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYHUDRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYHUDQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:11 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50076 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYHUDQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:04 -0400
Date: Wed, 20 Aug 2008 20:50:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oZ8l028320@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 2/27] mdb: add makefile for Merkey's Linux Kernel Debugger module
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add makefile for Merkey's Linux Kernel Debugger module


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/Makefile	2008-08-18 23:40:26.000000000 -0600
@@ -0,0 +1,5 @@
+#
+# Makefile for kernel debugger modules
+#
+
+obj-$(CONFIG_MDB)		+= mdb/
