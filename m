Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXKMQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXKMQRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXKMQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:17:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXKMQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:17:28 -0500
Date: Tue, 13 Nov 2007 17:17:19 +0100
From: andre@bitwigglers.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/3] gameport: remove duplicate include
Message-ID: <20071113161719.GB19470@ahaupt-debian-vm.localdomain>
References: <20071113161613.902793126@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-gameport-remove-duplicate-include.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX1+zo/a1/K9jCi89atJYAVJn7f7blj7oGt3/bMM
 GR2f1TeToJvTJLp4y08/gcYIbKPyDjpDmrphrBzoLHW4EafAbi
 7J3pPRE2opE8ctQ9mcDifBq1LldnfjG2bbpjjlhOOk=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 drivers/input/gameport/gameport.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/drivers/input/gameport/gameport.c
===================================================================
--- linus.orig/drivers/input/gameport/gameport.c	2007-11-13 16:27:10.000000000 +0100
+++ linus/drivers/input/gameport/gameport.c	2007-11-13 16:27:37.000000000 +0100
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>

--
