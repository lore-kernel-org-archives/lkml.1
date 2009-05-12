Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZELJaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZELJaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbZELJ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:28:26 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34786 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZELJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:28:00 -0400
X-Auth-Info: IeFB5inhHJvOUJiFfrjglV2k1Tzebo2/gryh21fYr7k=
Message-Id: <20090512092757.435595815@denx.de>
User-Agent: quilt/0.47-1
Date: Tue, 12 May 2009 11:27:59 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: [PATCH v2 2/7] [PATCH 2/8] can: Update MAINTAINERS and CREDITS file
References: <20090512092757.048938233@denx.de>
Content-Disposition: inline; filename=02-driver-maintainers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 CREDITS     |    4 ++++
 MAINTAINERS |    7 +++++++
 2 files changed, 11 insertions(+)

Index: net-next-2.6/CREDITS
===================================================================
--- net-next-2.6.orig/CREDITS	2009-05-12 10:47:10.501721461 +0200
+++ net-next-2.6/CREDITS	2009-05-12 10:47:24.371720546 +0200
@@ -1253,6 +1253,10 @@
 S: Sterling Heights, Michigan 48313
 S: USA
 
+N: Wolfgang Grandegger
+E: wg@grandegger.com
+D: Controller Area Network (device drivers)
+
 N: William Greathouse
 E: wgreathouse@smva.com
 E: wgreathouse@myfavoritei.com
Index: net-next-2.6/MAINTAINERS
===================================================================
--- net-next-2.6.orig/MAINTAINERS	2009-05-12 10:47:10.501721461 +0200
+++ net-next-2.6/MAINTAINERS	2009-05-12 10:47:24.374720415 +0200
@@ -1278,6 +1278,13 @@
 F:	include/linux/can/
 F:	include/linux/can.h
 
+CAN NETWORK DRIVERS
+P:	Wolfgang Grandegger
+M:	wg@grandegger.com
+L:	socketcan-core@lists.berlios.de (subscribers-only)
+W:	http://developer.berlios.de/projects/socketcan/
+S:	Maintained
+
 CELL BROADBAND ENGINE ARCHITECTURE
 P:	Arnd Bergmann
 M:	arnd@arndb.de

