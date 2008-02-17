Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYBQMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYBQMmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYBQMmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:42:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51125 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbYBQMmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:42:42 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Woodhouse <dwmw2@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
In-Reply-To: <1202840682.3137.83.camel@localhost.localdomain>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	 <1202838082.3137.54.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	 <1202840682.3137.83.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 12:42:27 +0000
Message-Id: <1203252147.31173.193.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 12:24 -0600, James Bottomley wrote:
> Hm ... I think net is a counter example to this.  Rebases certainly work
> for them. 

That's a matter of opinion. 

I'm working on cleaning up the libertas driver as and when I have time,
and the constant rebasing of the git trees effectively means that I
can't just use git as it was intended; I feel that I'm being forced back
into the 1990s by having to deal with sequences of patches instead.

It's such a pain that I'm seriously tempted to push my changes directly
to Linus instead of through the subsystem maintainers.

-- 
dwmw2

