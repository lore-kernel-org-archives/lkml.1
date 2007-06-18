Return-Path: <linux-kernel-owner+w=401wt.eu-S1765642AbXFRS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765642AbXFRS43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764685AbXFRS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:56:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52414 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760916AbXFRS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:56:20 -0400
Date: Mon, 18 Jun 2007 20:57:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>, Dan Williams <dcbw@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, hs4233@mail.mn-solutions.de,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070618185704.GA25340@uranus.ravnborg.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <1182188327.22149.5.camel@xo-28-0B-88.localdomain> <20070618184436.GC17479@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618184436.GC17479@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 07:44:36PM +0100, Christoph Hellwig wrote:
> On Mon, Jun 18, 2007 at 01:38:47PM -0400, Dan Williams wrote:
> > On Thu, 2007-06-14 at 19:13 +0100, Christoph Hellwig wrote:
> > > > I suspect that the probability of your proposal succeeding would be increased
> > > > if you could prepare a patch...
> > 
> > Applied to upstream-fixes branch of libertas-2.6 which is destined for
> > 2.6.22; I hope you don't mind that I just added the Signed-off-by for
> > you.
> 
> Adding a signed off line for a patch that purely removes codes seems
> rather pointless to me, but feel free to add it if you care.
THe Signed-off-by: document the path a given patch have taken on its way
to the final acceptance and does not have any significance whatsoever
about the content of the patch. Anyone on the Signed-of-by route
may change the patch (and I often do so) without further notice.

So judging if a Signed-off-by: should be added or not based on
patch content is wrong. It is a patch anyway.

That said the legal(in a loose definition of legal) rationale may
be of much less significance when trivially removing some code.
But we use the same mechanish even to cover spelling corrections.

	Sam
