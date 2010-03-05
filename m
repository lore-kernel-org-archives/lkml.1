Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0CEQPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:15:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0CEQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:15:13 -0500
Date: Fri, 5 Mar 2010 08:13:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, daniel@fooishbar.org,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305160217.663413eb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003050810140.3788@localhost.localdomain>
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net> <20100305160217.663413eb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Alan Cox wrote:

> > You can't unleash something like this on a userbase of this magnitude
> > and then throw your hands up in the air and say "I'm not willing to
> > support this in a reasonable way."
> 
> Not to belabour the obvious - they didn't. Linus ordered them to merge it.

Alan, you're ignoring reality.

This problem existed *before* nouveau was merged.

In fact, it was *worse* back then.

How hard is that to understand?

And yes, I do actually know. Because I used nouveau for a year before it 
was merged. You had to use a different version of drm too, so you couldn't 
even just compile the nouveau tree and install just the nouveau driver 
(and keep the other drivers from the main tree).

So the watershed moment was _never_ the "Linus merged it". The watershed 
moment was always "Fedora started shipping it". That's when the problems 
with a standard upstream kernel started.

Why is that so hard for people to understand?

			Linus
