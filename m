Return-Path: <linux-kernel-owner+w=401wt.eu-S1761083AbYBKTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083AbYBKTip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbYBKTii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:38:38 -0500
Received: from colo.lackof.org ([198.49.126.79]:35890 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbYBKTih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:38:37 -0500
Date: Mon, 11 Feb 2008 12:38:16 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: raw_pci_read in quirk_intel_irqbalance
Message-ID: <20080211193816.GB9798@colo.lackof.org>
References: <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org> <20080210230204.GH5299@parisc-linux.org> <20080211050415.GJ5299@parisc-linux.org> <20080211074954.GA11388@colo.lackof.org> <20080211161550.GL5299@parisc-linux.org> <alpine.LFD.1.00.0802110917460.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802110917460.2920@woody.linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:18:49AM -0800, Linus Torvalds wrote:
> I put it in the commit message, but it wasn't on page 34 when I checked (I 
> changed it to 69),

Sorry - page 34 was just the first reference to "Extended Configuration
Registers" when I originally scrounged up the info for willy.
Page 69 is in fact what I wanted to point at ("DEVPRES1" reg).

> and I added the naem for the datasheet so that if/when 
> it moves, maybe google can help.

It should. But doing a quick check now only shows one other copy
(in .es domain :) when searching for "30300702.pdf". 

Searching for the full document title results in several intel.com
locations and lots of other misc references that don't look quite right.
Many of those just reference the "product brief" and not the data sheet.

yahoo.com gives similar results.

thanks,
grant



> 
> 		Linus
