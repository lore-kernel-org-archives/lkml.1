Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbZJLVZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbZJLVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbZJLVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:25:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36139 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbZJLVZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:25:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Bug #14070] lockdep warning triggered by dup_fd
Date: Mon, 12 Oct 2009 23:26:13 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.LUE.p0l0KB@chimera> <e2e108260910121010l7855ad67g903cceac1a3ba024@mail.gmail.com>
In-Reply-To: <e2e108260910121010l7855ad67g903cceac1a3ba024@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122326.13496.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Bart Van Assche wrote:
> On Mon, Oct 12, 2009 at 1:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14070
> > Subject         : lockdep warning triggered by dup_fd
> > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > Date            : 2009-08-23 09:36 (50 days old)
> > References      : http://lkml.org/lkml/2009/8/23/8
> >
> 
> Hello Rafael,
> 
> Since I reported the above issue I haven't seen it reappearing yet.

Thanks, closing for now.  Please reopen if you see it again.

Rafael
