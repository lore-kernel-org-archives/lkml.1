Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXEOIOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXEOIOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXEOIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:14:29 -0400
Received: from www.osadl.org ([213.239.205.134]:46946 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755278AbXEOIO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:14:28 -0400
Subject: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
From: Thomas Gleixner <tglx@linutronix.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705142342.29994.s0348365@sms.ed.ac.uk>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>
	 <200705142342.29994.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Tue, 15 May 2007 10:18:02 +0200
Message-Id: <1179217082.7074.47.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've uploaded a new version of the x86_64 highres/dyntick patches:

http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v4.patch

Broken out version:

http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v4.patches.tar.bz2

Changes since last version:

- TSC calibration against PM-Timer

	tglx


