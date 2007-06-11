Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbXFKGJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbXFKGJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXFKGJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:09:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:44896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXFKGJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:09:09 -0400
Date: Sun, 10 Jun 2007 23:02:59 -0700
From: Greg KH <gregkh@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO
	translated into Japanese]
Message-ID: <20070611060259.GA914@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610175228.GA28947@uranus.ravnborg.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
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

I have no objection for them to be around in the tree, it might help out
some users who want to build their own kernels, and allow the -stable
kernels to catch up on the translations.

So I would encourage their addition, if possible.

thanks,

greg 'not everyone speaks english' k-h
