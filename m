Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYHSVcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYHSVcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYHSVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:31:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbYHSVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:31:51 -0400
Date: Tue, 19 Aug 2008 14:31:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: marcel@holtmann.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20080819.142150.129314008.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0808191429051.3324@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <1219170451.7591.175.camel@violet.holtmann.net> <alpine.LFD.1.10.0808191348540.3324@nehalem.linux-foundation.org> <20080819.142150.129314008.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, David Miller wrote:
> 
> I agree, we should be working on regressions fixes now.

Not just now. For the last two weeks, yes.

> And we should essentially be doing so up until the merge window opens up 
> again, right?

Yes. But any new code should go into another branch (or delayed entirely, 
but that probably doesn't work wekk for you guys) so that by the time the 
merge window opens up, it's already ready and rearing to go, and 
preferably pretty well tested too.

The problem is, you guys end up accepting a lot of stuff even after the 
merge window. I know why - it's easy to do. It looks obviously fine. And 
yeah, I let things slide.

The problem is, I've let things slide for a long time, and you guys don't 
feel the pain. 

> When do people following those rules have time to work on new stuff?

You can work on the new stuff too, but DON'T F*CKING SEND IT TO ME!

What's so hard to understand about that?

			Linus
