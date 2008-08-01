Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYHBAO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYHBAO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYHBAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:14:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYHBAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:14:49 -0400
Date: Fri, 1 Aug 2008 16:35:53 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH stable] ftrace document crucial update
Message-ID: <20080801233553.GA24276@kroah.com>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com> <20080731164850.GA10422@kroah.com> <alpine.DEB.1.10.0807311610021.5784@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807311610021.5784@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 04:10:49PM -0400, Steven Rostedt wrote:
> 
> On Thu, 31 Jul 2008, Greg KH wrote:
> 
> > On Wed, Jul 30, 2008 at 11:05:02PM -0400, Steven Rostedt wrote:
> > > 
> > > It has come to my attention that ftrace.txt was pulled into 2.6.26 
> > > prematurely. That is Linus pulled it in before it was well tested. A 
> > > series of updates were made to it shortly afterward, but by then it was 
> > > too late. The release was out, and ftrace.txt was greatly inadequate.
> > > 
> > > This patch is a sum of all the critical updates to keep ftrace.txt in a 
> > > stable state. I strongly urge the stable team to get this into 2.6.26.1.
> > > Otherwise people may be greatly disappointed while reading ftrace.txt just 
> > > to realize that it is horribly out of date.
> > > 
> > > Never mind that ftrace itself doesn't exist is 2.6.26.
> > > 
> > > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > Then why don't I just delete the file from the 2.6.26 tree entirely?
> > That would make more sense, right?
> 
> Nope! I'm leading by example here. We should have good documentation 
> before the code! ;-)

Bah, that only confuses people :)

I'll just go delete the whole thing, makes more sense.  That way you
will not send me patches for the Documentation when things change in the
upstream version...

thanks,

greg k-h
