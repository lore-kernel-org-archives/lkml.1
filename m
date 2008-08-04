Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYHDCbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYHDCbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbYHDCa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:30:56 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:45149 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbYHDCaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:30:55 -0400
Message-ID: <57467.166.70.238.45.1217815833.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:10:33 -0600 (MDT)
Subject: [PATCH 2.6.26 3/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey


--- linux-2.6.26/debug/Makefile	1969-12-31 17:00:00.000000000 -0700 +++
linux-2.6.26-mdb/debug/Makefile	2008-08-03 12:49:01.000000000 -0600 @@
-0,0 +1,5 @@
+
+#
+obj-y		:=mdb.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o
mdb-ia32-support.o
+
+


By making a contribution to this project, I certify that the contribution was
created in whole or in part by me and I have the right to submit it under
the open source license indicated in the file

Jeffrey Vernon Merkey





