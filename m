Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbXEQWFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbXEQWFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXEQWE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:04:58 -0400
Received: from www.osadl.org ([213.239.205.134]:34260 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754972AbXEQWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:04:57 -0400
Subject: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v7
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1178485128.31213.98.camel@localhost.localdomain>
References: <1178485128.31213.98.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 18 May 2007 00:09:53 +0200
Message-Id: <1179439793.12981.39.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce an updated version of the x86_64 highres/dyntick
support patches against 2.6.22-rc1:

http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v7.patch

Broken out version is available here:
http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v7.patches.tar.bz2

Changes since the last version:

- suspend / resume fix
- pc speaker preliminary locking fix
- networking nohz problem workaround (Mikulas Patocka) 

Comments, bug reports, patches are welcome as usual

Thanks,

        tglx


