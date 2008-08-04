Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbYHDGtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbYHDGtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbYHDGtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:49:22 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48526 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYHDGtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:49:21 -0400
Message-ID: <51623.166.70.238.45.1217831336.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:28:56 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 3/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/Makefile	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,5 @@
+
+#
+obj-y		:=mdb.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o
mdb-ia32-support.o
+
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



