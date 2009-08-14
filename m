Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZHNH7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZHNH7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZHNH7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:59:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41133 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZHNH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:59:23 -0400
Date: Fri, 14 Aug 2009 09:59:19 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090814075919.GG19257@buzzloop.caiaq.de>
References: <20090812115520.GI24339@elf.ucw.cz> <20090812194838.GB12117@n2100.arm.linux.org.uk> <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com> <20090812212502.GA24667@n2100.arm.linux.org.uk> <20090813103511.2928a085@lxorguk.ukuu.org.uk> <20090813094736.GZ6132@n2100.arm.linux.org.uk> <1250158593.28285.23.camel@Joe-Laptop.home> <20090813103513.GC6132@n2100.arm.linux.org.uk> <1250161714.28285.61.camel@Joe-Laptop.home> <20090813115444.GB10450@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813115444.GB10450@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:54:44PM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 13, 2009 at 04:08:34AM -0700, Joe Perches wrote:
> > On Thu, 2009-08-13 at 11:35 +0100, Russell King - ARM Linux wrote:
> > > And... have your emails been held for moderation recently?
> > 
> > Umm... (while chuckling)
> 
> Yes.  The reason being is you removed the 'Re:' from the subject
> line but still pressed "reply".
> 
> We have an etiquette item which discourages that - we have people
> who like to use the "reply" button to start a completely new and
> unrelated topic of conversation.  So the mailing list catches this
> behaviour and holds it for moderation, so we don't end up with
> irrelevent sub-threads tagged on to existing threads in the archives
> (or even in our threaded mail readers.)

One common false positive to this rule is using 'git send-email' with a
message ID as reference. There won't be a 'Re:' in that case.

As just happened to my USB patches some hours ago.

Daniel

