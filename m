Return-Path: <linux-kernel-owner+w=401wt.eu-S937101AbXG0MW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937101AbXG0MW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765178AbXG0MWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:22:46 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:41531 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760527AbXG0MWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:22:46 -0400
X-Greylist: delayed 2122 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 08:22:45 EDT
Subject: SD still better than CFS for 3d  =?ISO-8859-1?Q?=20=08(was?= Re: 2.6.23-rc1)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, ck@vds.kolivas.org
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 13:43:30 +0200
Message-Id: <1185536610.502.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 14:04 -0700, Linus Torvalds wrote: 
> Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.
> 
> And it has a *ton* of changes as usual for the merge window, way too much 
> for me to be able to post even just the shortlog or diffstat on the 
> mailing list (but I had many people who wanted to full logs to stay 
> around, so you'll continue to see those being uploaded to kernel.org).
> 
> Lots of architecture updates (for just about all of them - x86[-64], arm, 
> alpha, mips, ia64, powerpc, s390, sh, sparc, um..), lots of driver updates 
> (again, all over - usb, net, dvb, ide, sata, scsi, isdn, infiniband, 
> firewire, i2c, you name it).
> 
> Filesystems, VM, networking, ACPI, it's all there. And virtualization all 
> over the place (kvm, lguest, Xen).
> 
> Notable new things might be the merge of the cfs scheduler, and the UIO 
> driver infrastructure might interest some people.

Im still not so keen about this, Ingo never did get CFS to match SD in
smoothness for 3d applications, where my test subjects are quake(s),
world of warcraft via wine, unreal tournament 2004. And this is despite
many patches he sent me to try and tweak it. As far as im concerned, i
may be forced to unofficially maintain SD for my own systems(allthough
lots in the gaming community is bound to be interrested, as it does make
games lots better)


<snip>

