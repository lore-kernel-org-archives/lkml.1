Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYHTPbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYHTPbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYHTPbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:31:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYHTPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:31:35 -0400
Date: Wed, 20 Aug 2008 08:30:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Marcel Holtmann <marcel@holtmann.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT]: Networking
In-Reply-To: <20080820143734.GB20632@tuxdriver.com>
Message-ID: <alpine.LFD.1.10.0808200826530.3324@nehalem.linux-foundation.org>
References: <20080819.041706.261399060.davem@davemloft.net> <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <1219170451.7591.175.camel@violet.holtmann.net> <alpine.LFD.1.10.0808191348540.3324@nehalem.linux-foundation.org>
 <1219203753.7591.205.camel@violet.holtmann.net> <20080820143734.GB20632@tuxdriver.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Aug 2008, John W. Linville wrote:

> On Wed, Aug 20, 2008 at 05:42:33AM +0200, Marcel Holtmann wrote:
> > 
> > again, my current understanding was that updates to the documentation
> > that would help people to navigate and understand the kernel better and
> > make it easier for them to do bug reports etc. are always welcome and
> > should be pushed immediately. Same goes for new drivers that would
> > enable people to use their hardware.
> 
> This is my (current) understanding as well.  If that is not the case,
> then someone should clarify.

Guys, which part of "it wasn't any individual commit" didn' you 
understand?

Why are you concentrating on one documentation commit that I didn't even 
point to?

But that said - no, I don't think there is any reason to even push 
documentation commits, unless there is a real and pressing reason (ie the 
documentation is really important or will really matter from a future 
merge standpoint). I generally won't complain about them, but I also don't 
see the point.

I'd _much_ rather see you guys queue it up for future merges. 

		Linus
