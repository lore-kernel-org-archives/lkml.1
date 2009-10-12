Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZJLXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZJLXjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZJLXjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:39:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:36221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbZJLXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:39:16 -0400
Date: Mon, 12 Oct 2009 16:24:29 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Moving drivers into staging (was Re: [GIT PULL] SCSI fixes for
 2.6.32-rc3)
Message-ID: <20091012232429.GA24254@suse.de>
References: <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
 <20091008210737.GD29181@mit.edu>
 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
 <20091009091538.GA4154@elte.hu>
 <1255097287.2934.21.camel@localhost.localdomain>
 <20091012130652.GB25464@elte.hu>
 <1255357148.2850.91.camel@localhost.localdomain>
 <20091012145453.GD4565@elte.hu>
 <20091012150911.GB1656@suse.de>
 <20091012154244.GA13323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012154244.GA13323@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:42:44PM +0200, Ingo Molnar wrote:
> Hm, i think i even gave drivers/staging/ its name?

Yes you did, and I appreciate it :)

> > [...] It seems that I'm the only one that has the ability to drop 
> > drivers out of the kernel tree, which is a funny situation :)
> 
> You are the only one who has the ability to send a warning shot towards 
> drivers _without hurting users_, and by moving it into the focus of a 
> team of cleanup oriented developers.
> 
> I think that's an important distinction ;-)

Good point.

> > In thinking about this a lot more, I don't really mind it.  If people 
> > want to push stuff out of "real" places in the kernel, into 
> > drivers/staging/ and give the original authors and maintainers notice 
> > about what is going on, _and_ provide a TODO file for what needs to 
> > happen to get the code back into the main portion of the kernel tree, 
> > then I'll be happy to help out with this and manage it.
> > 
> > I think a 6-9 month window (basically 3 kernel releases) should be 
> > sufficient time to have a driver that has been in drivers/staging/ be 
> > cleaned up enough to move back into the main kernel tree.  If not, it 
> > could be easily dropped.
> > 
> > Any objections to this?
> 
> Sounds excellent to me!

Great, I'll await the patches to move stuff to drivers/staging/ now.

Wireless developers, warm up your editors :)

thanks,

greg k-h
