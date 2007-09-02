Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbXIBWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbXIBWF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXIBWFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:05:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:52632 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752679AbXIBWFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:05:19 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX18NNjt0la4N7gtgEAmQGL1u0EyOKXNjhLm8Png6+M
	99bEJmjKzx6b0v
Date: Mon, 3 Sep 2007 00:05:15 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
Message-Id: <20070903000515.45dacb3f.delist@gmx.net>
In-Reply-To: <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	<6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
	<5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also sprach "Alessandro Suardi" <alessandro.suardi@gmail.com> (Sun, 2 Sep 2007 22:38:28 +0200):
> On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> > On 9/2/07, daryll q wrote:
> > > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> > >
> > >  System hangs (caps lock and scroll lock leds are both flashing).
[...]
> > i experienced hangs, with the flashing caps and scroll locks as you've
> > described, in a few of my later pulls prior to rc5.  i couldn't
> > reproduce the hangs and my logs didn't show evidence of a problem.  my
> > system under rc5, so far, hasn't hung on me.
[...]
> Oh, I thought I was the only one. I also had a single hang+flashing
>  Caps & Scroll Lock with -rc5, but haven't had one since.
[...]

Hmm, just occured here, no chance to capture anything. Happend under
some system and network load (distcc/nfs) (latest atheros/madwifi
tainted however, but never had troubles). Not had much uptime with pre-5
-rc's.

Anything I can help to debug this?

config & dmesg & lspci:
http://www.mittendorfer.com/rm/temp/info-2.6.23-rc5.txt

sl, ritch
