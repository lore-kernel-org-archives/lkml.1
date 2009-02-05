Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZBEWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZBEWig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBEWiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:38:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZBEWiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:38:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Date: Thu, 5 Feb 2009 23:37:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.EfB.d5YiJB@chimera> <1233862503.4823.1.camel@kulgan.wumi.org.au>
In-Reply-To: <1233862503.4823.1.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902052337.31259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Kevin Shanahan wrote:
> On Wed, 2009-02-04 at 11:58 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> > Subject		: KVM guests stalling on 2.6.28 (bisected)
> > Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> > Date		: 2009-01-17 03:37 (19 days old)
> 
> Yes, this should still be listed.

Thanks for the update.
 
> Please remove kmshanah@flexo.wumi.org.au from the CC list.

It gets added because it is present in the Author: field in
http://bugzilla.kernel.org/show_bug.cgi?id=12465#c5

This is how the script works, sorry for the inconvenience.

Rafael


> 
> Thanks,
> Kevin.
> 
> 
> 
> 


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
