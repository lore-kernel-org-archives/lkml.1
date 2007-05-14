Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXENUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXENUUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbXENUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:19:56 -0400
Received: from www.osadl.org ([213.239.205.134]:51332 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756335AbXENUTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:19:55 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
Cc: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <10373.1179173440@turing-police.cc.vt.edu>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705140217.11515.s0348365@sms.ed.ac.uk>
	 <1179138368.22481.334.camel@localhost.localdomain>
	 <10373.1179173440@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 14 May 2007 22:23:15 +0200
Message-Id: <1179174195.7074.18.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 16:10 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 May 2007 12:26:08 +0200, Thomas Gleixner said:
> 
> > Broken out version is available here:
> > http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v1.patches.tar.bz2
> 
> How unhappy am I likely to be if I try to apply this to a 21-mm2 kernel? It
> doesn't *look* like any of the patches are in -mm2 (at least not under the
> same name).

There are probably some conflicts, but the wreckage should be not that
big.

	tglx


