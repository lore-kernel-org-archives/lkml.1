Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXHWXc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXHWXc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXHWXcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:32:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49905 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753677AbXHWXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:32:49 -0400
Date: Fri, 24 Aug 2007 01:31:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.23-rc3
Message-ID: <20070823233139.GU30705@stusta.de>
References: <20070822220805.GB30603@kroah.com> <Pine.LNX.4.60.0708240036200.3246@poirot.grange> <20070823224956.GA25969@suse.de> <20070823161815.604f1a8b.rdunlap@xenotime.net> <20070823232831.GA4638@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070823232831.GA4638@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 04:28:31PM -0700, Greg KH wrote:
> On Thu, Aug 23, 2007 at 04:18:15PM -0700, Randy Dunlap wrote:
> > On Thu, 23 Aug 2007 15:49:56 -0700 Greg KH wrote:
> > 
> > > On Fri, Aug 24, 2007 at 12:43:47AM +0200, Guennadi Liakhovetski wrote:
> > > > Hi Greg,
> > > > 
> > > > sorry, this is a private egoistic request, so I took the liberty and 
> > > > removed Linus and Andrew from CC: If this wouldn't make things more 
> > > > difficult / worse for you and anyone else, could you perhaps post such 
> > > > patch chains as a reply to the first message (patch 0/x) and not each 
> > > > subsequent patch as a reply to the previous one? It would make it easier 
> > > > to view for _me_ (remember egoistic?) because my mail agent (pine) 
> > > > presents mail threads where every reply level produces a small right 
> > > > offset in the subject line, so, starting from about reply number 20 the 
> > > > subject is completely off-screen.
> > > > 
> > > > Again, this is a minor trouble, and, perhaps, I am the only one suffering 
> > > > from it, but if it doesn't matter either way for everyone else, I would 
> > > > really appreciate it that way.
> > > 
> > > Heh, people ask me about this every few months or so, so you are not
> > > alone.
> > 
> > I'd prefer that change also.  In fact I just modified (trivial)
> > send_lots_of_email.pl (gregkh_patchbomb mailer) to do this,
> > except that I just have it create an mbox that I email via
> > msmtp.  (and it reads a 'sendpatchset' control file for input
> > instead of needing to modify the script source file itself)
> 
> I use git-send-email these days, and it already supports this with the
> --no-chain-reply-to option.  I'll consider using it next time, if at
> least one more person complains about this :)
>...

*complain*  :)

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

