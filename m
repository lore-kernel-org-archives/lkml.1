Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029Ab0ANKwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0ANKwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878Ab0ANKwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:52:00 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:34653 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab0ANKv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:51:59 -0500
Date: Thu, 14 Jan 2010 12:51:55 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14952] instant reboot on loading 2.6.33-rc on Celeron
 900
In-Reply-To: <NJVdobuNFNK.A.3WF.2mhOLB@chimera>
Message-ID: <alpine.SOC.1.00.1001141251130.11661@math.ut.ee>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.3WF.2mhOLB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14952
> Subject		: instant reboot on loading 2.6.33-rc on Celeron 900
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2009-12-29 13:57 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=126209508500393&w=4

Fixed in upstream now, 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1373411ae4cd0caf2e1a35fb801dd9a00b64dea2

-- 
Meelis Roos (mroos@linux.ee)
