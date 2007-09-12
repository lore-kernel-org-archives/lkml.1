Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXILFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXILFze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXILFz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:55:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152AbXILFz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:55:26 -0400
Date: Wed, 12 Sep 2007 07:55:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070912055533.GX3563@stusta.de>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <20070911182926.GQ3563@stusta.de> <20070912052413.GH2579@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070912052413.GH2579@hacking>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 01:24:13PM +0800, WANG Cong wrote:
> On Tue, Sep 11, 2007 at 08:29:26PM +0200, Adrian Bunk wrote:
> >On Tue, Sep 11, 2007 at 10:16:44AM -0700, Randy Dunlap wrote:
> >>...
> >> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> +Mutt (TUI)
> >> +
> >> +Plenty of Linux developers use mutt, so it must work pretty well.
> >> +
> >> +Are there any special config options that are needed??
> >>...
> >
> >It should work with default settings.
> 
> 
> I can't agree with this.
> 
> It took me lots of time to configure mutt to work well for me in the first
> time. Just default settings are far _not_ enough, especially for us
> non-english-speakers. One common setting is the encoding, of course, lkml
> prefers UTF-8, so I must set my mutt with `set send_charset="us-ascii:utf-8"`.

This makes sense, but it's not really a mutt specific issue and 
problems because mutt prefers iso-8859-1 over UTF-8 by default are
quite rare.

> Manuals of mutt told me to add "subscribe linux-kernel@vger.kernel.org" if I
> subscribed lkml, but in fact, we'd better _not_ add this, or it will drop
> myself from cc list.
> 
> Or other things like these.
>...

Whether or not people want to get personal copies of answers to mailing
list posts is a religious issue being second only to the vi<->emacs wars...

But as far as I understand it, this documentation is intended to help 
people to get sending patches right (no line wrap etc.), not as a 
generic documentation for mail clients.

> Regards.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

