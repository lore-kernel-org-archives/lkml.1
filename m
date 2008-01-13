Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYAMBuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYAMBuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 20:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYAMBuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 20:50:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:38388 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYAMBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 20:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=F3hnFxVo+Bgf126TRXjjivC47ifmfv+ULhU6t1XQ4OVgR2J4kh0L0RomVdfzMnX6yOD1ZP0PNMHdeMHcSawSl+XAfHMlxsStzq6tu8SOsHXajv9W04mp6SajbfBCAiTnJp8r8ypYgyHXXc3yvdTFj+Buf/KfS5zx8KJw396L6N0=
Date: Sun, 13 Jan 2008 02:44:48 +0100 (CET)
To: linux-doc@vger.kernel.org
cc: "Ed L. Cashin" <ecashin@coraid.com>, Rob Landley <rob@landley.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Documentation: Add 00-INDEX file for AoE
Message-ID: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/aoe/ is missing a 00-INDEX file. Add one.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/aoe/00-INDEX	2008-01-13 02:37:29.000000000 +0100
@@ -0,0 +1,18 @@
+00-INDEX
+	- this file.
+aoe.txt
+	- ATA over Ethernet (AoE) driver user guide and pointer to tools.
+autoload.sh
+	- script for making the AoE driver autoload via /etc/modprobe.conf.
+mkdevs.sh
+	- script for creating required AoE device nodes.
+mkshelf.sh
+	- script for making one shelf's worth of block device nodes.
+status.sh
+	- script to collate and present sysfs information about AoE storage.
+todo.txt
+	- list of things yet to be done for the AoE driver.
+udev-install.sh
+	- script to install the aoe-specific udev rules from udev.txt.
+udev.txt
+	- list of udev rules for AoE device node creation.



