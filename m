Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbYBUVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbYBUVbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYBUVbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:31:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43792 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYBUVbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:31:01 -0500
Date: Thu, 21 Feb 2008 13:30:37 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>, Linus Torvalds <torvalds@osdl.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080221213037.GA24191@kroah.com>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221210124.GD28328@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:01:24PM +0200, Adrian Bunk wrote:
> 
> BTW: Greg, you are Cc'ed for your joke in [3]...

> [3] http://lkml.org/lkml/2008/2/12/427

That was not a joke, I ment it.  Do you have proof that the majority of
patches going into the kernel tree are not reviewed by at least 2
people?  Now they might not be 2 people that you personally like/agree
with, but that's a totally different topic...

And I'm with Linus on this one, it's much easier to work on driver fixes
together with others, when they are in the kernel tree.

Although I do like the checkpatch.pl script, it has helped me in making
it easier to clean up some vendor-provided drivers recently, finding
some obvious coding style issues that I had missed the first pass
through.

thanks,

greg k-h
