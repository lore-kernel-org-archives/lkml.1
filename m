Return-Path: <linux-kernel-owner+w=401wt.eu-S1763639AbYESUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763639AbYESUns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbYESUnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:43:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47208 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYESUnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:43:39 -0400
Date: Mon, 19 May 2008 22:44:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26
Message-ID: <20080519204417.GA25312@uranus.ravnborg.org>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org> <20080516170310.35d7b407.randy.dunlap@oracle.com> <20080516172816.9d98c0f2.akpm@linux-foundation.org> <482E3DDA.7050708@oracle.com> <482E5F80.7040206@oracle.com> <8779236.1211228793416.JavaMail.oracle@acsmt301.oracle.com> <20080519133841.92de7f90.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519133841.92de7f90.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 01:38:41PM -0700, Andrew Morton wrote:
> On Mon, 19 May 2008 15:26:33 -0500 (CDT)
> Randy Dunlap <RANDY.DUNLAP@ORACLE.COM> wrote:
> 
> > > > Oh yeah.  I think that this was fixed by
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b11caa7c7063ea92a0a58115d3fc6d038ed89510 
> > > > 
> > > > but I'll check/verify/confirm that.
> > > > 
> > > 
> > > Yes, it builds fine now (built against 2.6.26-rc2-git5).
> > 
> > Andrew,
> > Will you merge this now?
> 
> It's had no public testing because I disabled it in config, so it looks
> like a 2.6.27 thing to me.
> 
> >  or do you want me to see about Sam merging it?
> > or something else?
> 
> I'll move it into my send-to-Sam queue.

OK - I will apply them the kbuild-next.git when I receive latest version.

	Sam

