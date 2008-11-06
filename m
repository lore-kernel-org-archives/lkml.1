Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYKFEtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYKFEtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYKFEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:49:33 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:59481 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYKFEtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:49:32 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: benh@kernel.crashing.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James Cloos <cloos@jhcloos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
	<m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	<1225662539.8004.237.camel@pasglop>
	<871vxtthr3.fsf@burly.wgtn.ondioline.org>
	<1225874361.13603.12.camel@pasglop>
	<87skq6sc0e.fsf@burly.wgtn.ondioline.org>
	<1225943357.13603.41.camel@pasglop>
Date: Thu, 06 Nov 2008 17:49:31 +1300
In-Reply-To: <1225943357.13603.41.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 06 Nov 2008 14:49:17 +1100")
Message-ID: <87od0tsbl0.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> Ok so I can't get it to die on my M9 (rv250) tipb here, I can try next
> week on a albook with an M10 (rv350). Just to make sure I'm doing the
> same as you, does it boot fine if you don't change the font and does it
> lockup if, after it's fully booted, you do a setfont neepalt10x20.psf ?

Yes.  It boots fine with the regular 8x16 font and locks up when I do
"setfont neepalt10x20.psf".

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
