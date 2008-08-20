Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYHTPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYHTPk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHTPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:40:09 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47101 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYHTPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:40:08 -0400
Subject: Re: [GIT]: Networking
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808200826530.3324@nehalem.linux-foundation.org>
References: <20080819.041706.261399060.davem@davemloft.net>
	 <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org>
	 <1219170451.7591.175.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0808191348540.3324@nehalem.linux-foundation.org>
	 <1219203753.7591.205.camel@violet.holtmann.net>
	 <20080820143734.GB20632@tuxdriver.com>
	 <alpine.LFD.1.10.0808200826530.3324@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 17:40:13 +0200
Message-Id: <1219246813.7591.347.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > > again, my current understanding was that updates to the documentation
> > > that would help people to navigate and understand the kernel better and
> > > make it easier for them to do bug reports etc. are always welcome and
> > > should be pushed immediately. Same goes for new drivers that would
> > > enable people to use their hardware.
> > 
> > This is my (current) understanding as well.  If that is not the case,
> > then someone should clarify.
> 
> Guys, which part of "it wasn't any individual commit" didn' you 
> understand?
> 
> Why are you concentrating on one documentation commit that I didn't even 
> point to?
> 
> But that said - no, I don't think there is any reason to even push 
> documentation commits, unless there is a real and pressing reason (ie the 
> documentation is really important or will really matter from a future 
> merge standpoint). I generally won't complain about them, but I also don't 
> see the point.
> 
> I'd _much_ rather see you guys queue it up for future merges. 

John was just pointing out (like myself before) that a lot of people are
under the impression that documentation updates and new drivers should
not be queued up and merged as soon as possible.

I am really fine either way. Queuing them up is not a problem and you
made your point that you don't wanna see them after -rc1. That is fair
enough, but it really needs to be spelled our here since the overall
consensus is different. I will not send any of these do Dave anymore
after the merge window.

Regards

Marcel


