Return-Path: <linux-kernel-owner+w=401wt.eu-S1030948AbXDPUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030948AbXDPUQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030949AbXDPUQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:16:41 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:39664 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030948AbXDPUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:16:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=35Jkg1pwnL/gGvbl2lt6VbnVwtGFYhIRXTYdauoS5ZEWCLnlg7gK0tSn+MgZmNvFh3AVVymxBisQuV4M+fNYnfTMQs/kwEdGZ/7meUiIt16wKudclp6YM+SHXT1AAmXrqGRuR/1VgedB0+NsfaR9E4awtZwYsjSgwmG5NHcLEME=  ;
X-YMail-OSG: G68VqV0VM1ml.6DF1Wf2IsAMvd522Sb_J3_RTyNbiTPtH067Y7RS4mb8DUtyynt.ggmfp8sxdTwlZr_OG3V0vBm4nv8SheT3oPUz3oKmbQomrEh3hp6Ti7_Dl3Tf8s7oAMFxAKGHQyLQALazBC02VAS.lDk_oYacGzYqV2aX8fB94XUhryXy
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: [patch 2.6.21-rc7] MAINTAINERS uses lists.linux-foundation.org
Date: Mon, 16 Apr 2007 11:53:14 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161153.14457.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update various mailing list addresses to use "lists.linux-foundation.org"
instead of "lists.osdl.org", to help phase out the old addresses.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
I *think* this generalizes beyond linux-pm ... and hey, maybe now I know why
the PM list spends so much time on swsusp instead of real power management.

 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

--- g26.orig/MAINTAINERS	2007-04-11 13:37:50.000000000 -0700
+++ g26/MAINTAINERS	2007-04-16 11:48:01.000000000 -0700
@@ -1318,7 +1318,7 @@ S:	Maintained
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	bridge@lists.osdl.org
+L:	bridge@lists.linux-foundation.org
 W:	http://bridge.sourceforge.net/
 S:	Maintained
 
@@ -1951,7 +1951,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -1978,7 +1978,7 @@ S:	Maintained 
 
 KERNEL JANITORS
 P:	Several
-L:	kernel-janitors@lists.osdl.org
+L:	kernel-janitors@lists.linux-foundation.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
@@ -2001,7 +2001,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 S:	Maintained
 
 KPROBES
@@ -2339,7 +2339,7 @@ S:	Maintained
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	netem@lists.osdl.org
+L:	netem@lists.linux-foundation.org
 S:	Maintained
 
 NETFILTER/IPTABLES/IPCHAINS
@@ -3068,7 +3068,7 @@ S:	Supported
 SOFTWARE SUSPEND:
 P:	Pavel Machek
 M:	pavel@suse.cz
-L:	linux-pm@lists.osdl.org
+L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
 
 SONIC NETWORK DRIVER
