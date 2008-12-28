Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYL1MbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYL1MbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 07:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYL1MbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 07:31:05 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37459 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYL1MbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 07:31:04 -0500
Date: Sun, 28 Dec 2008 13:32:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081228123233.GA11652@uranus.ravnborg.org>
References: <20081227092404.GA10375@uranus.ravnborg.org> <20081227.013712.63335017.davem@davemloft.net> <20081227094955.GA1355@uranus.ravnborg.org> <20081227.202552.27482357.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227.202552.27482357.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 08:25:52PM -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 27 Dec 2008 10:49:55 +0100
> 
> > I have ordered a used Sun Blade 100(*) that should show up
> > before new eve.
> > So when I have it and it is up and running I will redo this
> > patch set. That will likely take a few weeks though.
> 
> Another option, of course, is to use 64-bit cross tools
> on an x86_64 system if you have access to one of those.
It needs a new motherboard and I used my savings on a Sun blade...

> 
> > (*) Any distribution recommendations? I will only use it for
> >     sparc kernel development so nothing fancy...
> 
> Debian testing works fine, and that's what I'm typing this
> on.
Thanks!

	Sam
