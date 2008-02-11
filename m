Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYBKR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYBKR2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYBKR2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:28:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYBKR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:28:38 -0500
Date: Mon, 11 Feb 2008 09:18:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Grant Grundler <grundler@parisc-linux.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: raw_pci_read in quirk_intel_irqbalance
In-Reply-To: <20080211161550.GL5299@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0802110917460.2920@woody.linux-foundation.org>
References: <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
 <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org> <20080210230204.GH5299@parisc-linux.org> <20080211050415.GJ5299@parisc-linux.org> <20080211074954.GA11388@colo.lackof.org>
 <20080211161550.GL5299@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Feb 2008, Matthew Wilcox wrote:
> 
> I'm told that these URLs are not guaranteed to be stable.  And
> remembering the pain we had when HP decided to relocate all of their
> documents, I'm really not inclined to embed a link to a URL in the
> source code.

I put it in the commit message, but it wasn't on page 34 when I checked (I 
changed it to 69), and I added the naem for the datasheet so that if/when 
it moves, maybe google can help.

		Linus
