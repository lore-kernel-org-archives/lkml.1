Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYERMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYERMRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbYERMNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194AbYERMNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:22 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
Subject: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
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
Date		: 2008-05-07 4:55 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


