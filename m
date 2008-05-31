Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYEaSx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYEaSx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbYEaSve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbYEaSvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:31 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A._zF.ctZQIB@albercik>
Subject: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:05 +0200 (CEST)
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
Date		: 2008-05-07 4:55 (25 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
		  http://lkml.org/lkml/2008/5/18/177
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


