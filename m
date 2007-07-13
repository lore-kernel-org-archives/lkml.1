Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXGMLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXGMLWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXGMLWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:22:41 -0400
Received: from www.osadl.org ([213.239.205.134]:54111 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753953AbXGMLWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:22:40 -0400
Subject: v2.6.22.1-rt3
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 13:22:32 +0200
Message-Id: <1184325752.12353.312.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

we are pleased to announce the v2.6.22.1-rt3 kernel

Attention! 

Ingo is off for a long weekend and therefor the download location for
this release is:

 http://www.tglx.de/projects/preempt-rt/2.6.22.1
  
more info about the -rt patchset can be found in the RT wiki:
  
   http://rt.wiki.kernel.org
 
This release is bugfix release:

- update of the x8664 -hrt queue (resolve boot problems)
- gtod vsyscall fix from Gregory Haskins

to build a 2.6.22.1-rt3 tree, the following patches should be applied:
 
   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
   http://www.tglx.de/projects/preempt-rt/2.6.22.1-rt3/patch-2.6.22.1-rt3.patch


	Thomas


