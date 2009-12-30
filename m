Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZL3Vqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZL3Vqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZL3Vqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:46:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZL3Vqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:46:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ruud Linders <kernelml@xs4all.nl>
Subject: Re: [Bug #14910] Stable version 2.6.32.2 broke my KMS Radeon setup
Date: Wed, 30 Dec 2009 22:47:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.oNH.TnhOLB@chimera> <4B3B2B3D.40204@xs4all.nl>
In-Reply-To: <4B3B2B3D.40204@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302247.17239.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, Ruud Linders wrote:
> On 12/29/2009 04:09 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14910
> > Subject		: Stable version 2.6.32.2 broke my KMS Radeon setup
> > Submitter	: Ruud Linders <kernelml@xs4all.nl>
> > Date		: 2009-12-20 12:02 (10 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126131105608871&w=4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> This one can be closed as it's not an 2.6.33 issue  (I'm running
> 2.6.33-rc1 with KMS just fine)
> 
> See also  http://patchwork.kernel.org/patch/69076/ for stable patch to
> fix it in 2.6.32.3.

Thanks for the update.

This one has been dropped from the list of recent regressions already.  Please
close the bug when it's fixed in -stable (or let me know if you can't close it).

If the patch doesn't appear in .32.3, please send a notification to
stable@kernel.org.

Rafael
