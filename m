Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYG1QkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYG1QkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYG1QkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:40:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:51535 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYG1Qj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:39:59 -0400
Date: Mon, 28 Jul 2008 10:39:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org, jonsmirl@gmail.com
Subject: Re: [PATCH v3 0/4 REPOST] OF infrastructure for SPI devices
Message-ID: <20080728163956.GC21039@secretlab.ca>
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca> <200807271449.28472.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807271449.28472.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 02:49:28PM -0700, David Brownell wrote:
> On Friday 25 July 2008, Grant Likely wrote:
> > I don't know what to do with these patches.  I'd really like to see them
> > in .27, and now that akpm has cleared his queue, the prerequisite patch
> > has been merged so they are ready to go in.  However, even though there
> > has been favourable reception on the SPI and linuxppc lists for these
> > changes I don't have any acks from anybody yet.
> > 
> > David, can you please reply on if you are okay with these patches
> > getting merged?  If so, do you want me to merge them via my tree, or
> > do you want to pick them up?
> 
> OK ... to recap, #1 and #3 are OF-specific, I'll be agnostic.
> If other OF folk think it's OK, great.
> 
> Some cleanup was needed for #2, but it was basically ok ...
> I'd like to see the final version, and if it goes via an
> OF push that's OK by me.  (Though I'd like to see that change
> make it into 2.6.27 regardless, so let me know.)

Thanks for the review.  1-3 is already merged into my git tree and Ben
has pulled them.  I hope that's okay.  Here's a link to the commit:

http://git.kernel.org/?p=linux/kernel/git/benh/powerpc.git;a=commitdiff;h=dc87c98e8f635a718f1abb2c3e15fc77c0001651

Let me know if you see anything else that needs to be changed and I'll
submit a fixup patch.

> And #4 isn't quite cooked yet.

Okay, I'll hack on this more and post v4.

Thanks again,
g.
