Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZBXIs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZBXIs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZBXIsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:48:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZBXIso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:48:44 -0500
Subject: Re: [Bug #12618] hackbench [pthread mode] regression with
 2.6.29-rc3
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <vP9hdyF4fL.A.HyE.ppzoJB@chimera>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
	 <vP9hdyF4fL.A.HyE.ppzoJB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Feb 2009 09:48:16 +0100
Message-Id: <1235465296.15790.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 22:48 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12618
> Subject		: hackbench [pthread mode] regression with 2.6.29-rc3
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-02-01 7:30 (23 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=490dea45d00f01847ebebd007685d564aaf2cd98
> References	: http://marc.info/?l=linux-kernel&m=123347347726527&w=4
> Handled-By	: Peter Zijlstra <peterz@infradead.org>
> Patch		: http://marc.info/?l=linux-kernel&m=123383366122146&w=4
> 		  http://marc.info/?l=linux-kernel&m=123383366222152&w=4


I thought this was all upstream by now, Yanmin, are we still seeing some
badness?
