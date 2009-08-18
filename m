Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZHRWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZHRWru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZHRWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:47:49 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53230 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZHRWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:47:48 -0400
Date: Wed, 19 Aug 2009 07:47:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: suspend tree build failure
Message-ID: <20090818224749.GA26661@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090818183049.8bde1ee6.sfr@canb.auug.org.au> <200908182343.32375.rjw@sisk.pl> <20090818221301.GA20676@linux-sh.org> <200908190040.50949.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908190040.50949.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 12:40:50AM +0200, Rafael J. Wysocki wrote:
> On Wednesday 19 August 2009, Paul Mundt wrote:
> > Argh, and rebased in the process, again. This is now the second time in
> > as many days this has been rebased, meaning I have to throw away my topic
> > branch and re-create. I thought this was going to remain stable? I would
> > like the SH runtime PM code to get some coverage in -next, but I can't
> > merge it in to my tree if the suspend tree keeps rebasing every day.
> 
> Well, my linux-next branch is not to guaranteed to be stable, just like the
> entire linux-next tree.
> 
> Once the patch stops making trouble, I'll move it into my for-linus branch,
> which _is_ guaranteed not to be rebased (in fact it's never rebased).
> 
> I haven't done it yet exactly because of these build problems.  Please wait
> for a couple of days more for things to settle down.
> 
Ah, ok, I misunderstood the intention of your -next branch. I'll wait for
it to cool off, thanks. ;-)
