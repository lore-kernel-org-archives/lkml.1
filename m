Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbYBMQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbYBMQb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbYBMQbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:31:06 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:40616 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbYBMQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:31:04 -0500
Date: Wed, 13 Feb 2008 10:30:48 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 6/8] IPMI: Update driver version
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080213163048.GF9830@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Enough bug fixes and changes that we need a new driver version.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.23/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.23.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.23/drivers/char/ipmi/ipmi_msghandler.c
@@ -47,7 +47,7 @@
 
 #define PFX "IPMI message handler: "
 
-#define IPMI_DRIVER_VERSION "39.1"
+#define IPMI_DRIVER_VERSION "39.2"
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
