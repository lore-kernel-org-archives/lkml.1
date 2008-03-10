Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYCJVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYCJVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYCJVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:14:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYCJVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:14:45 -0400
Date: Mon, 10 Mar 2008 14:13:46 -0700
From: Greg KH <greg@kroah.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: inotify fixes in stable
Message-ID: <20080310211346.GA6622@kroah.com>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <20080310160317.GB20775@kroah.com> <20080310203658.3bdbc27c@mjolnir.drzeus.cx> <20080310203116.GC5943@kroah.com> <20080310215755.7e920738@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310215755.7e920738@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:57:55PM +0100, Pierre Ossman wrote:
> On Mon, 10 Mar 2008 13:31:16 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Mar 10, 2008 at 08:36:58PM +0100, Pierre Ossman wrote:
> > > 
> > > The system is an OpenSuse 10.3 system, so 2.6.22.y would be the
> > > interesting one. I'll see if I can get a custom kernel in there (I've
> > > been unable to reproduce the problem outside a production
> > > environment).
> > 
> > 2.6.22.y is no longer being released by me, so it isn't interesting to
> > me at all :)
> > 
> 
> Oh? You made a release just 13 days ago, so I figured you were still
> giving it some love.

In that release, I said it was going to be my last.

> > What about 2.6.24?  Is this still an issue there?
> 
> Judging from the kernel bugzilla, it would seem so.
> 
> But in my specific case, the guy on site was going to try an updated
> kernel from Suse's build system. I'll probably now the results
> tomorrow or the day after that.

Please let us know.

thanks,

greg k-h
