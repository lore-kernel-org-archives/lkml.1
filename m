Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXDCWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXDCWvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXDCWvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:51:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992469AbXDCWvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:51:47 -0400
Date: Tue, 3 Apr 2007 15:51:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?Q?Magall=F3n" ?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070403155135.ff7f3043.akpm@linux-foundation.org>
In-Reply-To: <20070404004005.2f21d514@werewolf-wl>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<20070404004005.2f21d514@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 00:40:05 +0200
"J.A. Magall__n" <jamagallon@ono.com> wrote:

> On Mon, 2 Apr 2007 22:47:45 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> > - The oops in git-net.patch has been fixed, so that tree has been restored. 
> >   It is huge.
> > 
> > - Added the device-mapper development tree to the -mm lineup (Alasdair
> >   Kergon).  It is a quilt tree, living at
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > 
> > - Added davidel's signalfd stuff.
> > 
> 
> Something strange happens to me with this kernel.
> Gnome Screensaver hangs the box. Locked solid, no atl-sysrq-raw,
> no ssh. Nada.
> Do not know if it's itself, or something in X dpms.
> 
> Somebody else ?
> 

Do you know what the particualr screensaver is trying to do?  Does it do
whizzy 3d graphics, or does it just blank the screen, or...  ?
