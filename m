Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZL2Wna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZL2Wna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZL2Wn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:43:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZL2Wn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:43:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [Bug #14909] pata_cmd64x broken in 2.6.33-rc1
Date: Tue, 29 Dec 2009 23:44:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       "linux-ide@vger.kernel.org"@ogre.sisk.pl
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.DYH.UnhOLB@chimera> <alpine.SOC.1.00.0912292306020.975@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.0912292306020.975@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292344.13042.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Meelis Roos wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14909
> > Subject		: pata_cmd64x broken in 2.6.33-rc1
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2009-12-19 22:23 (11 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d43744390e460dce6626fb8de2c02a24ff650005
> > References	: http://marc.info/?l=linux-kernel&m=126126142501594&w=4
> 
> Fixed as of 2.6.33-rc2 - just retested the upstream fix.

Thanks, closing.

Rafael
