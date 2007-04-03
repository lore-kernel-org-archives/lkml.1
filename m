Return-Path: <linux-kernel-owner+w=401wt.eu-S2992470AbXDCW6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992470AbXDCW6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992474AbXDCW6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:58:45 -0400
Received: from smtp.ono.com ([62.42.230.12]:18648 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992470AbXDCW6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:58:44 -0400
Date: Wed, 4 Apr 2007 00:58:26 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
Message-ID: <20070404005826.5c849ab6@werewolf-wl>
In-Reply-To: <20070403155135.ff7f3043.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<20070404004005.2f21d514@werewolf-wl>
	<20070403155135.ff7f3043.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs80 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 15:51:35 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 4 Apr 2007 00:40:05 +0200
> "J.A. Magall__n" <jamagallon@ono.com> wrote:
> 
> > On Mon, 2 Apr 2007 22:47:45 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > > 
> > > - The oops in git-net.patch has been fixed, so that tree has been restored. 
> > >   It is huge.
> > > 
> > > - Added the device-mapper development tree to the -mm lineup (Alasdair
> > >   Kergon).  It is a quilt tree, living at
> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > > 
> > > - Added davidel's signalfd stuff.
> > > 
> > 
> > Something strange happens to me with this kernel.
> > Gnome Screensaver hangs the box. Locked solid, no atl-sysrq-raw,
> > no ssh. Nada.
> > Do not know if it's itself, or something in X dpms.
> > 
> > Somebody else ?
> > 
> 
> Do you know what the particualr screensaver is trying to do?  Does it do
> whizzy 3d graphics, or does it just blank the screen, or...  ?

Just the 'Floating Feet', I love it ;).... (just 2D, not linked to any
libGL...).
Anyways, I have just remembered I use the (in)famous nVidia driver.
Will try to reproduce without it. This was more like a probe to see if
somebody else is suffering it...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam08 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
