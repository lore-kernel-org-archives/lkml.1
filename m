Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0CDS4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:56:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab0CDS4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:56:11 -0500
Date: Thu, 4 Mar 2010 10:55:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304185002.GA23532@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Matthew Garrett wrote:
>
> When you asked that nouveau was merged, people explicitly told you that 
> the reason it hadn't been was because the interface was unstable and 
> userspace would break. You asked that it be merged anyway, and now 
> you're unhappy because the interface has changed and userspace has 
> broken?

How hard is it to understand basic kernel development rules? 

Nouveau was in Fedora-12. In fact, it was in Fedora-11 too afaik. People 
can hide behind all the "staging" and "I asked for it" things they like, 
but that doesn't change simple basic facts: distros should make sure 
drivers get merged up-stream, and people end up depending on them.

Btw, I'm hoping some of this pain goes away for me, because I expect to 
get rid of the shitty nVidia card reasonably soon. The fact that my main 
box had a power supply that literally _required_ a power-sucking-piece- 
of-sh*t-graphics card has been painful to me.

But none of that changes my basic objections. I didn't ask for nouveau to 
be merged as staging - I asked it to be merged because a major distro uses 
it.

			Linus
