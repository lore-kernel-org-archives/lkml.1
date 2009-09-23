Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbZIWNVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbZIWNVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIWNVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:21:05 -0400
Received: from kroah.org ([198.145.64.141]:43340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZIWNVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:21:04 -0400
Date: Wed, 23 Sep 2009 06:20:30 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20090923132030.GA30966@kroah.com>
References: <20090923163817.44bcebb8.sfr@canb.auug.org.au>
 <4ABA16BF.4020504@windriver.com>
 <20090923225026.c03c84c6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923225026.c03c84c6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:50:26PM +1000, Stephen Rothwell wrote:
> Hi Jason,
> 
> On Wed, 23 Sep 2009 07:38:23 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> >
> > Please, let me know if there is something I need to do here.
> > 
> > Simply changing the context of the patch in Greg's branch should be
> > enough.   There are many more fixes beyond just the timing loop in the
> > dbgp series which cover, cold and warm restarts and various errata with
> > the ehci debug controllers.
> 
> Yeah, I think Greg just needs to rebase his series on to a more recent
> version of Linus' tree.  (and then test and submit it, of course :-))

It was a simple merge, I've now refreshed my tree with this change
locally, and will push it out in a bit.

thanks,

greg k-h
