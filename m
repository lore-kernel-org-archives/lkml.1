Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbYEXVgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbYEXVgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbYEXVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762624AbYEXVc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:56 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.sEF.6fIOIB@albercik>
Subject: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-07 4:55 (18 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
		  http://lkml.org/lkml/2008/5/18/177
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


