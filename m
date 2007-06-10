Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXFJTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXFJTDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbXFJTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:03:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51782 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbXFJTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:03:42 -0400
Date: Sun, 10 Jun 2007 21:04:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com,
       tlktp-general@lists.sourceforge.net
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Message-ID: <20070610190444.GA29599@uranus.ravnborg.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org> <Pine.LNX.4.64.0706102034490.25718@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706102034490.25718@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 08:35:03PM +0200, Jan Engelhardt wrote:
> >> No, I think the translated files should be in the tree proper, we have
> >> the space :)
> >
> >We once discussed about .po files for kconfig and back then
> >the conclusion was not to keep them in the kernel tree.
> >
> >I advocated that they should stay out back then.
> >But on the other hand I do not see it causing much troubles
> >having scripts/kconfig/po/da.po etc araound.
> >
> >Any opinion about the .po files?
> 
> Like with translated doc, they might get out of date easily.

The difference here is that with .po files we have tools
to report the actual translation status.
And having the .po files included in the source makes it
much easier to use the latest versions.

The Linux Kernel Translation Project
http://tlktp.sourceforge.net/
have nice statisitcs for the different translations.

Italian is 100% followed by Hungarian with almost 70%.
We have a number of dedicated people, so why not
make the works available to more users by including it
in the kernel.

I trust the tlktp people enough that we will not see patches
for the language with less than ~5% translated strings.

I would assume that Japanese soon get higher btw - there
is quite a number of people listed as translators.

	Sam
