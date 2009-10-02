Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZJBRUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZJBRUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZJBRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:20:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbZJBRUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:20:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #14133] WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
Date: Fri, 2 Oct 2009 19:21:28 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <1254466855.3531.6.camel@ht.satnam> <20091002073425.GA14918@kernel.dk>
In-Reply-To: <20091002073425.GA14918@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021921.28374.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Jens Axboe wrote:
> On Fri, Oct 02 2009, Jaswinder Singh Rajput wrote:
> > Hello Jens,
> > 
> > On Thu, 2009-10-01 at 21:55 +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.30 and 2.6.31.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14133
> > > Subject		: WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
> > > Submitter	: Jens Axboe <jens.axboe@oracle.com>
> > > Date		: 2009-08-31 20:43 (32 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125175143918050&w=4
> > > 
> > > 
> > 
> > Are you still getting this warning in latest -tip. If yes, can you do
> > git bisect and specify the commit.
> 
> Nope, it seems to have disappeared.

OK, closed.

Thanks,
Rafael
