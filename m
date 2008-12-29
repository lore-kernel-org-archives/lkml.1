Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYL2RSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYL2RSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYL2RRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:17:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbYL2RRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:17:51 -0500
Date: Mon, 29 Dec 2008 09:17:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       bunk@kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       auke-jan.h.kok@intel.com, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-Id: <20081229091728.d869f1c1.akpm@linux-foundation.org>
In-Reply-To: <20081229102515.GA17171@rhlx01.hs-esslingen.de>
References: <20081228.000118.121541932.davem@davemloft.net>
	<20081229102515.GA17171@rhlx01.hs-esslingen.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 11:25:15 +0100 Andreas Mohr <andi@lisas.de> wrote:

> Hi,
> 
> > Adrian Bunk (1):
> > 
> >       The overdue eepro100 removal.
> 
> That would be a rather pronounced NAK then? (sorry ;)
> (reason: rendering my web surfing box useless due to networking loss,
> see thread "[RFC/PATCH] e100 driver didn't support any MII-less PHYs...")
> 
> AFAICS e100 is still "non-MII"-challenged (2.6.28 doesn't appear to have
> the necessary changes, and this pull doesn't seem to contain updates either),
> and a long chain of attempts to get this resolved hasn't worked yet.

I didn't know about this, and that patch has been around for a
loooooooong time.  Please make more noise about these things.

>
> Somehow I seem to hit some nice walls getting my stuff into kernel.
> - e100 MII

What's that?  Does it make your web surfing work again?

> - i810 AGP resume fix

Whats that?

> - acx100 (ok, that one is a bit mean to add to this list ;)

What's that?

Just resend everything, please, fulyl changelogged, with all necessary
cc's.

> - ...
> ALSA patches handled by Takashi OTOH were almost always a
> "bammm, in it is, there you are, HAND".

Fell free to cc me on these things - especially bugfixes.  I help
prevent things from getting lost.

