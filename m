Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXF0JPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXF0JPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXF0JO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:14:57 -0400
Received: from mesiob.obspm.fr ([145.238.2.2]:46343 "EHLO mesiob.obspm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXF0JO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:14:56 -0400
From: =?iso-8859-15?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Date: Wed, 27 Jun 2007 11:18:36 +0200
User-Agent: KMail/1.8
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706261637.22820.zoltan.hubert@zzaero.com> <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de>
In-Reply-To: <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706271118.36985.zoltan.hubert@zzaero.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (mesiob.obspm.fr [145.238.2.2]); Wed, 27 Jun 2007 11:14:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Roland,

On Tuesday 26 June 2007 21:03, Roland Kuhn wrote:
> On 26 Jun 2007, at 16:37, Zoltán HUBERT wrote:
> > Whatever "stable" means.
>
> What you mean by "stable" pretty much excludes any
> serious development, without which the Linux kernel would
> very soon be obsolete. If you want a stable system, then
> don't change it. 

This is a problem. Do you remember that kernel vulnerability 
in 2.4 that made the Debian servers be attacked ? And 
mplayerhq.hu too if I remember right ? So what are we 
supposed to do with a perfect and optimised system, running 
smoothly, with an older kernel where some nasty bug is 
discovered ?

In MacOS X, you click "System Update" and you're done. 

In Linux, I expect "download the newest stable kernel, 
configure, compile, install, reboot". 

If I have to rely on the distribution to help me it spoils 
the whole benefit of open source. I don't trust Novell or 
RedHat or Google more than Microsoft or Apple. You "kernel 
developpers" are the keepers of the flame.

> If you update to a kernel which is 2.5 
> years newer, you simply cannot have stability, because
> that would mean stagnation, aka "death".

PostScript is a very old language yet we all still use it 
every day. HTML is a very old "thing" and we use it 
every-day, and it's still compatible with newer and older 
stuff.

I'm a system engineer, and a "stable" system is one where 
the interfaces are stable. Individual components can 
change, and do change, but if you change fundamental 
interfaces it is not the same system. Of course I 
understand that "sometimes" fundamental things have to 
change, but here "sometimes" is the keyword. If its 
"anytime" it simply is no stable system. And yes, designing 
and maintaining interfaces is a very difficult job.

I don't remember how it was during 2.4 and before, but I 
find it very suspicious that SuSE and RedHat only provide 
2.6.10 and 2.6.9 for their OS. It looks as if THEY didn't 
trust 2.6.x to be a replacement to 2.6.y

And as I understand it, this is (was ?) the whole point of 
stable/development kernels. "We" can trust a newer stable 
kernel to be a drop-in replacement for an older stable 
kernel (from the same series), while development kernels 
need time to stabilise with the new whizz-bang-pfouit stuff 
that you all so nicely add. 

Are the good ol' days lost in nostalgia ?

bye

Zoltán




-- 
 
________________________

Zoltan
________________________

 
