Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYHEGr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYHEGr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYHEGrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:20 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46564 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYHEGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:19 -0400
Date: Tue, 5 Aug 2008 00:26:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QZ8L003757@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 3/26] mdb: adding /debug Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.  adding this Makefile

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/Makefile	2008-08-04 15:49:51.000000000 -0600
@@ -0,0 +1,4 @@
+#
+obj-y		:=mdb.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o mdb-ia32-support.o 
+
+
