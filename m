Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbXKIXu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbXKIXu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXKIXuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:50:15 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57255 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbXKIXuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:50:14 -0500
Message-id: <705663791195430567.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 11/13] Char: nozomi, remove unused includes
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:50:14 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, remove unused includes

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 1ab5d64fc4a2dd7a50b8971c67b9793511b4c47a
tree d169718adab1aaf82ee655dc2048535eae3742a7
parent 2bd359aea85cf712d4d161a83e940fe5e1202ee8
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 15:25:18 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:14:51 +0100

 drivers/char/nozomi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 3e0b18e..e87ded2 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -101,9 +101,7 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/kfifo.h>
-#include <linux/list.h>
 #include <linux/uaccess.h>
-#include <asm/atomic.h>
 
 #include <linux/delay.h>
 
