Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXENKXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXENKXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbXENKW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:22:56 -0400
Received: from www.osadl.org ([213.239.205.134]:33671 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755683AbXENKW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:22:56 -0400
Subject: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705140217.11515.s0348365@sms.ed.ac.uk>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705140217.11515.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Mon, 14 May 2007 12:26:08 +0200
Message-Id: <1179138368.22481.334.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce an updated version of the x86_64 highres/dyntick
support patches against 2.6.22-rc1:

To build a highres / dyntick enabled kernel for x86_64:

http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.22-rc1.bz2
http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v1.patch

Broken out version is available here:
http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v1.patches.tar.bz2

Changes since the last version:

- Various fixups from Chris Wright
- TSC calibration fix (pointed out by Alistair John Strachan)

Comments, bugreports, patches are welcome as ususal

Thanks,

        tglx


