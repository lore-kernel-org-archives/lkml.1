Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYI0Rp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYI0Rp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYI0RkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbYI0RkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gregory Haskins" <ghaskins@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.lcH.P8m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11505]=20oltp=20~10%=20regression=20with=202.6.27-rc5=20on=20stoakley=20machine?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11505
Subject		: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2008-09-04 7:06 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=122051202202373&w=4
		  http://marc.info/?t=122089704700005&r=1&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Gregory Haskins <ghaskins@novell.com>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&m=122194673932703&w=4


