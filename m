Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbYDKUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbYDKUXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbYDKUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:22:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760413AbYDKUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:22:54 -0400
Date: Fri, 11 Apr 2008 13:21:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
In-Reply-To: <20080411190128.GG11962@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0804111307440.3143@woody.linux-foundation.org>
References: <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org>
 <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <20080411175304.GF11962@parisc-linux.org> <alpine.LFD.1.00.0804111146450.3143@woody.linux-foundation.org> <20080411190128.GG11962@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Matthew Wilcox wrote:
> 
> We only support people keeping their old configs after they run 'make
> oldconfig', right?  At which point they'd be prompted for E1000_SUPPORT.
> Presumably they'd think "That's odd.

Ok, I'm not even interested in discussing this.

Have you followed the discussion at all? Did you even notice _why_ we're 
discussing it?

Here's a damn big hint: teh thing you say "Presumably they'd think" is 
exactly what we're talking about, AND HELL NO THEY DIDN'T!

That goes for both me and Ingo.

So stop blathering. The _fact_ is that two kernel developers were really 
upset about the fact that their machines stopped working with old 
configurations. Stop the inane ".. but that would never happen", because 
the whole discussion is because IT DID HAPPEN!

		Linus
