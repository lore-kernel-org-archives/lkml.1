Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYHRVxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYHRVxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYHRVvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:51:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYHRVvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:51:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Subject: Re: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
Date: Mon, 18 Aug 2008 23:54:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.ugH.CdzpIB@albercik> <20080819014544.390ff3c2@gmail.com>
In-Reply-To: <20080819014544.390ff3c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182354.49669.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Mikhail Kshevetskiy wrote:
> As of 2.6.26-rc3-git3 bug still exist.
> It affect both i386 and x86_64 architectures.
> 
> Mikhail

Thanks for the update,
Rafael

> On Sat, 16 Aug 2008 21:02:46 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
> > Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
> > Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> > Date		: 2008-07-24 03:22 (24 days old)
> > References	: http://lkml.org/lkml/2008/7/23/317
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
