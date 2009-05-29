Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZE2NQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZE2NQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZE2NQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:16:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63999 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbZE2NQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:16:18 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-fsdevel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 29 May 2009 18:09:29 +0300
Message-Id: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/2] Use hrtimers in UBIFS
X-OriginalArrivalTime: 29 May 2009 13:15:40.0739 (UTC) FILETIME=[907CE930:01C9E05F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Resending this to lkml. No comments from fsdevel:
http://marc.info/?l=linux-fsdevel&m=124351121304115&w=2

I guess no one cares, which is fine with me as long as my patch
which exports ktime_add_safe is accepted :-)

Could the relevant people accept the following patch please:
[PATCH 1/2] hrtimer: export ktime_add_safe
for 2.6.31 merge window?

I've CC'ed people suggested by:
$ scripts/get_maintainer.pl -f kernel/hrtimer.c

Artem.
