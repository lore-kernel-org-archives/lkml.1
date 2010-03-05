Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0CEBU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:20:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab0CEBU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:20:56 -0500
Date: Thu, 4 Mar 2010 17:20:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Luc Verhaegen <libv@skynet.be>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
 <20100305005617.GA31883@skynet.be> <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Linus Torvalds wrote:
> 
> Anyway, since I had looked at the libdrm sources, I had most of this on my 
> machine anyway, so I've compiled it all, and am going to reboot and see if 
> I can make a few symlinks work.
> 
> IOW, right now I have this:
> 
>    [root@nehalem ~]# cd /usr/lib64/xorg/modules/drivers/
>    [root@nehalem drivers]# ll nouveau_drv.so*
>    lrwxrwxrwx 1 root root      21 2010-03-04 17:00 nouveau_drv.so -> nouveau_drv.so-0.0.16
>    -rwxr-xr-x 1 root root  343784 2010-03-04 16:59 nouveau_drv.so-0.0.15
>    -rwxr-xr-x 1 root root 1698805 2010-03-04 16:59 nouveau_drv.so-0.0.16

Naah, I just end up with a really screwed up screen with that. I probably 
did something wrong in the configuration phase or something. I'll look for 
the precompiled ones, and hope they don't have some other odd 
dependencies.

		Linus
