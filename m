Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYJLHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYJLHBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYJLHBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 03:01:42 -0400
Received: from 1wt.eu ([62.212.114.60]:4720 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYJLHBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 03:01:42 -0400
Date: Sun, 12 Oct 2008 09:00:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.27 will be a longtime supported kernel
Message-ID: <20081012070044.GM24654@1wt.eu>
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org> <20081011210340.GA11198@cs181140183.pp.htv.fi> <20081012040223.GC18221@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012040223.GC18221@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 09:02:23PM -0700, Greg KH wrote:
> On Sun, Oct 12, 2008 at 12:03:40AM +0300, Adrian Bunk wrote:
> > 2.6.16 has become a bit dated, and I'll maintain 2.6.27 for a few years 
> > as a replacement.
> 
> Hm, you're not the only one going to be doing this, there are at least
> three distros basing their latest releases on this kernel :)

Oh that's good news as it will give it more exposure and bugs will be
found and fixed faster. Having 2.6.25 in opensuse may have contributed
to its stability.

> > As with 2.6.16, I'll pickup maintainance when the normal -stable 
> > maintainance ends (at some point after 2.6.28 gets released in January).
> 
> I was considering hanging on to .27 for a while longer than the .28
> release, much like .25 has been working out.

BTW, how long to you think you'll keep pushing fixes for .25 ? It's been
working really well and might have been the most reliable 2.6 I've seen,
2.6.16 aside. I'll keep using it waiting for 2.6.27 to settle down a bit.

> Hey, I personally liked it as it made maintaining SLES a lot easier,
> thanks a lot for your work there!

Not only there, but everywhere you need to embed a 2.6 without too many
features and without an easy ability to upgrade it, 2.6.16 has been a
good choice.

Thanks to you guys for the time you spend maintaining stable releases!
I really hope that 2.6.27 will be a viable replacement for 2.4 in the
long term.

Willy

