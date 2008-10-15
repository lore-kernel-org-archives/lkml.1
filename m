Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYJOUeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYJOUeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYJOUdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:33:54 -0400
Received: from kroah.org ([198.145.64.141]:41732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752367AbYJOUdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:33:53 -0400
Date: Wed, 15 Oct 2008 13:30:38 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
	-next?
Message-ID: <20081015203038.GA14959@kroah.com>
References: <20081015174015.GB8663@kroah.com> <Pine.LNX.4.64.0810152202230.25933@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810152202230.25933@anakin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:04:17PM +0200, Geert Uytterhoeven wrote:
> On Wed, 15 Oct 2008, Greg KH wrote:
> > Just wondering, I know that -next is failing right now, and is a major
> > pain to produce, but that seems to be primarily due to all of the
> > subsystems merging with Linus right now.
> > 
> > So does it even make sense to try to create a -next during the 2 weeks
> > of the major merge window?  It seems to just cause you a whole lot of
> > work, that in the end, is mostly unecessary as all of the subsystem
> > maintainers are doing the merging themselves as trees move into Linus's
> > tree?
> 
> I don't know if it's worth the effort...
> 
> However, we definitely missed linux-next during the last few weeks, seeing
> things getting into mainline that don't even survive simple compile tests.

Oh I agree, I missed it a lot the past few weeks, it's amazing how much
we already started to rely on it in such a short time.  That shows how
valuable the effort is.

Keep it up, I just don't want to see Stephen burn out during the pre-rc1
time period when it might not make as much sense to be trying to create
the tree.

thanks,

greg k-h
