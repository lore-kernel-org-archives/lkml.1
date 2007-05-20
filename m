Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbXETHTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbXETHTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXETHS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:18:58 -0400
Received: from www.osadl.org ([213.239.205.134]:53509 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759957AbXETHS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:18:57 -0400
Subject: [PATCH] x86-64 highres/dyntick support 2.6.22-rc2-v1
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain
Date: Sun, 20 May 2007 09:25:02 +0200
Message-Id: <1179645902.21827.16.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce an updated version of the x86_64 highres/dyntick
support patches against 2.6.22-rc2:

http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc2-x86_64-highres-v1.patch

Broken out version is available here:
http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc2-x86_64-highres-v1.patches.tar.bz2

Changes since the last version:

- update to -rc2
- maxcpus=1 boot hang fix


Comments, bug reports, patches are welcome as usual

Thanks,

        tglx


