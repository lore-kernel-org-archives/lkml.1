Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZHJOVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZHJOVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbZHJOVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:21:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41596 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZHJOVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:21:52 -0400
Date: Mon, 10 Aug 2009 10:21:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Neil Brown <neilb@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13944] MD raid regression
Message-ID: <20090810142130.GA15956@redhat.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.RyC.aj1fKB@chimera> <19071.30809.398179.900584@notabene.brown> <200908101611.07170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908101611.07170.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10 2009 at 10:11am -0400,
Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 10 August 2009, Neil Brown wrote:
> > On Sunday August 9, rjw@sisk.pl wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > (either way).
> > 
> > Yes, it still should be listed.  The first patch didn't quite fix it.
> > A second one probably does.
> 
> Thanks for the update.
> 
> Is the patch listed below the right one?
> 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
> > > Subject		: MD raid regression
> > > Submitter	: Mike Snitzer <snitzer@redhat.com>
> > > Date		: 2009-08-05 15:06 (5 days old)
> > > Handled-By	: NeilBrown <neilb@suse.de>
> > > Patch		: http://patchwork.kernel.org/patch/39521/

The updated patch is here:
http://patchwork.kernel.org/patch/40328/

I haven't yet tested it but will do so shortly.

Mike
