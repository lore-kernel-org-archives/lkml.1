Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbXFJRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbXFJRvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbXFJRv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:51:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36470 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258AbXFJRv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:51:26 -0400
Date: Sun, 10 Jun 2007 19:52:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Message-ID: <20070610175228.GA28947@uranus.ravnborg.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610162221.GA12830@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 09:22:21AM -0700, Greg KH wrote:
> >  Since the common language of most kernel contributors is english I
> >  personally feel that we should stick to just that one language in the
> >  tree and then perhaps keep translations on a website somewhere. So the
> >  authoritative docs stay in the tree, in english, so that as many
> >  contributors as possible can read and update them. It would then be a
> >  seperate project to generate translations and keep them updated
> >  according to what's in the tree.  Perhaps we could get the kernel.org
> >  people to create an official space for that and then place a pointer
> >  to that site in Documentation/ somewhere.
> 
> No, I think the translated files should be in the tree proper, we have
> the space :)

We once discussed about .po files for kconfig and back then
the conclusion was not to keep them in the kernel tree.

I advocated that they should stay out back then.
But on the other hand I do not see it causing much troubles
having scripts/kconfig/po/da.po etc araound.

Any opinion about the .po files?

	Sam
