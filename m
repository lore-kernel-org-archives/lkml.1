Return-Path: <linux-kernel-owner+w=401wt.eu-S940902AbXHMUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940902AbXHMUid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762768AbXHMUiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:38:09 -0400
Received: from pat.uio.no ([129.240.10.15]:56408 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbXHMUiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:38:07 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 16:37:25 -0400
Message-Id: <1187037445.6628.98.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.086)
X-UiO-Scanned: 1937CE7189E2E085CA71354C2427EE9290012DC7
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 445 total 3226585 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 10:42 -0700, Arjan van de Ven wrote:
> The maintainer info should be in the source file itself! That's the only
> reasonable way to keep it updated; now I'm all for having it machine
> parsable so that tools can use it, but it still really should be in the
> code itself, not in some central file that will always just go out of
> data, and will be a huge source of needless patch conflicts.

If the problem is to do with people failing to update the MAINTAINERS
file, why would moving the same data into 20 or 30 source files motivate
them to keep it up to date? As far as I can see, that would just serve
to multiply the amount of stale data...

Trond

