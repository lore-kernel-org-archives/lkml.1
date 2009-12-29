Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbZL2VHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbZL2VHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZL2VHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:07:15 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58430 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZL2VHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:07:14 -0500
Date: Tue, 29 Dec 2009 23:07:12 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       "linux-ide@vger.kernel.org"@ogre.sisk.pl
Subject: Re: [Bug #14909] pata_cmd64x broken in 2.6.33-rc1
In-Reply-To: <NJVdobuNFNK.A.DYH.UnhOLB@chimera>
Message-ID: <alpine.SOC.1.00.0912292306020.975@math.ut.ee>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.DYH.UnhOLB@chimera>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14909
> Subject		: pata_cmd64x broken in 2.6.33-rc1
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2009-12-19 22:23 (11 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d43744390e460dce6626fb8de2c02a24ff650005
> References	: http://marc.info/?l=linux-kernel&m=126126142501594&w=4

Fixed as of 2.6.33-rc2 - just retested the upstream fix.

-- 
Meelis Roos (mroos@linux.ee)
