Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYAHS2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYAHS2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYAHS2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:28:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbYAHS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:28:39 -0500
Date: Tue, 8 Jan 2008 10:27:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
In-Reply-To: <4783BE06.1070507@linux.intel.com>
Message-ID: <alpine.LFD.1.00.0801081025470.3148@woody.linux-foundation.org>
References: <477FF149.4070609@linux.intel.com> <20080105213935.GN27894@ZenIV.linux.org.uk> <20080107174431.GC27741@fieldses.org> <4782CF9C.6000508@gmail.com> <alpine.LFD.1.00.0801071851120.3148@woody.linux-foundation.org> <20080108081401.d9576ac5.randy.dunlap@oracle.com>
 <4783B602.1050307@linux.intel.com> <alpine.LFD.1.00.0801080957280.3148@woody.linux-foundation.org> <4783BE06.1070507@linux.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jan 2008, Arjan van de Ven wrote:
> 
> the database has the information so it's just a matter of slightly different
> php code ;)
> Before I do that... do you want the BUG's separate, part of the warnings or
> part of the oopses?
> (I rather make this change once ;)

I'd like them all separate, they tend to be very different and contain 
different information.

Put the warnings last, as the least important. Oopses at the top, since 
they tend to be the ones that are less expected.

> > and notice how the Code: never made it into the raw message (and thus there
> > is also no instruction disassembly).
> 
> ok I'll fix this; I can fix this for all new entries at least, fixing
> retroactive is going to be near impossible I suspect.

Oh well..

		Linus
