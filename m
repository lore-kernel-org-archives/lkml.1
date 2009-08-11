Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZHKPjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZHKPjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZHKPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:39:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZHKPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:39:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [Bug #13944] MD raid regression
Date: Tue, 11 Aug 2009 17:40:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908101611.07170.rjw@sisk.pl> <20090810142130.GA15956@redhat.com>
In-Reply-To: <20090810142130.GA15956@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908111740.10506.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Mike Snitzer wrote:
> On Mon, Aug 10 2009 at 10:11am -0400,
> Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday 10 August 2009, Neil Brown wrote:
> > > On Sunday August 9, rjw@sisk.pl wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > 
> > > Yes, it still should be listed.  The first patch didn't quite fix it.
> > > A second one probably does.
> > 
> > Thanks for the update.
> > 
> > Is the patch listed below the right one?
> > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
> > > > Subject		: MD raid regression
> > > > Submitter	: Mike Snitzer <snitzer@redhat.com>
> > > > Date		: 2009-08-05 15:06 (5 days old)
> > > > Handled-By	: NeilBrown <neilb@suse.de>
> > > > Patch		: http://patchwork.kernel.org/patch/39521/
> 
> The updated patch is here:
> http://patchwork.kernel.org/patch/40328/

Thanks, bug entry updated.

Rafael
