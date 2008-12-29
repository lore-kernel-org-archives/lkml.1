Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYL2KZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYL2KZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYL2KZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:25:20 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47062 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYL2KZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:25:19 -0500
Date: Mon, 29 Dec 2008 11:25:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, bunk@kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>, auke-jan.h.kok@intel.com,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20081229102515.GA17171@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228.000118.121541932.davem@davemloft.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Adrian Bunk (1):
> 
>       The overdue eepro100 removal.

That would be a rather pronounced NAK then? (sorry ;)
(reason: rendering my web surfing box useless due to networking loss,
see thread "[RFC/PATCH] e100 driver didn't support any MII-less PHYs...")

AFAICS e100 is still "non-MII"-challenged (2.6.28 doesn't appear to have
the necessary changes, and this pull doesn't seem to contain updates either),
and a long chain of attempts to get this resolved hasn't worked yet.


Somehow I seem to hit some nice walls getting my stuff into kernel.
- e100 MII
- i810 AGP resume fix
- acx100 (ok, that one is a bit mean to add to this list ;)
- ...
ALSA patches handled by Takashi OTOH were almost always a
"bammm, in it is, there you are, HAND".

I can't seem to wash away my slightly CK'ish feeling ;)

Thanks,

Andreas Mohr
