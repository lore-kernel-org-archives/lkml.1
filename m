Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0BUVvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:51:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0BUVvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:51:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Lin Ming" <ming.m.lin@intel.com>,
       "Mike Galbraith" <efault@gmx.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
In-Reply-To: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ClJsQB_ZlxO.A.ZFH.AeagLB@chimera>
Subject: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:30:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2010-01-25 10:03 (28 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/1b9508f6831e10d53256825de8904caa22d1ca2c
References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
Handled-By	: Mike Galbraith <efault@gmx.de>
		  Peter Zijlstra <peterz@infradead.org>
		  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Patch		: http://patchwork.kernel.org/patch/78544/


