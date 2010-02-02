Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0BBVDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:03:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab0BBVDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:03:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Backlund <tmb@mandriva.org>
Subject: Re: [Bug #14482] kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Date: Tue, 2 Feb 2010 22:04:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Clouter <alex@digriz.org.uk>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.85G.9HiZLB@chimera> <4B66F79E.1040606@mandriva.org>
In-Reply-To: <4B66F79E.1040606@mandriva.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022204.34787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Thomas Backlund wrote:
> 01.02.2010 02:43, Rafael J. Wysocki skrev:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
> > Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
> > Submitter	: Alexander Clouter<alex@digriz.org.uk>
> > Date		: 2009-10-23 10:30 (101 days old)
> > References	: http://lkml.org/lkml/2009/10/23/50
> >
> >
> 
> Afaik this is the same issue as the one referenced here:
> 
> http://lkml.org/lkml/2010/1/28/292
> 
> The patch in the above thread should fix the issue.

Thanks, updated.

Rafael
