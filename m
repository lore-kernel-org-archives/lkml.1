Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbXFNSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbXFNSY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXFNSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:24:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXFNSYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:24:50 -0400
Date: Thu, 14 Jun 2007 11:23:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
In-Reply-To: <20070614181307.GA16856@infradead.org>
Message-ID: <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org>
 <20070614103836.23b07a72.akpm@linux-foundation.org>
 <20070614181307.GA16856@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Christoph Hellwig wrote:
>
> > I suspect that the probability of your proposal succeeding would be increased
> > if you could prepare a patch...
> 
> Here we go:

I don't mind ripping them out, but it makes sense only if people are 
actually signed up to implementing this on a higher layer. As such, I'd 
need to get a sign-off from somebody actually involved in wireless mesh 
stuff etc.

Please? I do agree that the private iwpriv interface seems to be totally 
the wrong thing to do, but I want to see this as a first step towards a 
better situation, rather than just a "remove code that is ugly" issue!

Comments?

		Linus
