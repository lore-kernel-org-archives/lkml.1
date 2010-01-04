Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464Ab0ADUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0ADUSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035Ab0ADUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:18:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55806 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab0ADUSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:18:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14951] lockdep possible recursive lock in slab parent->list->rlock
Date: Mon, 4 Jan 2010 21:18:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.pdF.3mhOLB@chimera> <84144f021001030336y30444880vb6b9c251eb8a049a@mail.gmail.com>
In-Reply-To: <84144f021001030336y30444880vb6b9c251eb8a049a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001042118.53662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Pekka Enberg wrote:
> Hi Rafael,
> 
> On Tue, Dec 29, 2009 at 5:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14951
> > Subject         : lockdep possible recursive lock in slab parent->list->rlock
> > Submitter       : Andi Kleen <andi@firstfloor.org>
> > Date            : 2009-12-27 12:06 (3 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126191560531463&w=4
> > Handled-By      : Pekka Enberg <penberg@cs.helsinki.fi>
> > Patch           : http://patchwork.kernel.org/patch/69829/
> 
> This bug is fixed by the following commit in Linus' tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00afa758067ac1c947149ef766adcdfe30c44d7d

Thanks, closed.

Rafael
