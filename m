Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0BOAOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:14:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab0BOANz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:13:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera>
In-Reply-To: <fQEllunEdO.A.-LB.HyIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Xv2rBFCTXTH.A.cdB.NyIeLB@chimera>
Subject: [Bug #15304] SMT scheduler regression in find_busiest_queue()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:52:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15304
Subject		: SMT scheduler regression in find_busiest_queue()
Submitter	: Suresh Siddha <suresh.b.siddha@intel.com>
Date		: 2010-02-13 1:14 (2 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1
Message-ID	: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
References	: http://marc.info/?l=linux-kernel&m=126602374511831&w=4
Handled-By	: Suresh Siddha <suresh.b.siddha@intel.com>
Patch		: http://patchwork.kernel.org/patch/79039/


