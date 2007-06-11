Return-Path: <linux-kernel-owner+w=401wt.eu-S1764085AbXFKA3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764085AbXFKA3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762956AbXFKA3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:29:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58907 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760668AbXFKA3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:29:43 -0400
Date: Mon, 11 Jun 2007 02:29:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO
	translated into Japanese]
Message-ID: <20070611002954.GG3588@stusta.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070610175228.GA28947@uranus.ravnborg.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 07:52:28PM +0200, Sam Ravnborg wrote:
> On Sun, Jun 10, 2007 at 09:22:21AM -0700, Greg KH wrote:
> > >  Since the common language of most kernel contributors is english I
> > >  personally feel that we should stick to just that one language in the
> > >  tree and then perhaps keep translations on a website somewhere. So the
> > >  authoritative docs stay in the tree, in english, so that as many
> > >  contributors as possible can read and update them. It would then be a
> > >  seperate project to generate translations and keep them updated
> > >  according to what's in the tree.  Perhaps we could get the kernel.org
> > >  people to create an official space for that and then place a pointer
> > >  to that site in Documentation/ somewhere.
> > 
> > No, I think the translated files should be in the tree proper, we have
> > the space :)
> 
> We once discussed about .po files for kconfig and back then
> the conclusion was not to keep them in the kernel tree.
> 
> I advocated that they should stay out back then.
> But on the other hand I do not see it causing much troubles
> having scripts/kconfig/po/da.po etc araound.
> 
> Any opinion about the .po files?

Why not (if there are people willing to do the translation work).

The only thing I consider important is that this doesn't imply any kind 
of string freeze at some time prior to a release (but .po updates 
through -stable shouldn't be a problem).

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

