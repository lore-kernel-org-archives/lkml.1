Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbYD3XYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbYD3XYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYD3XYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:24:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbYD3XYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:24:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 01:23:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org>
In-Reply-To: <20080430154124.7ec08dd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010123.58247.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Andrew Morton wrote:
> On Wed, 30 Apr 2008 15:31:22 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Any suggestions on how to convince people that their code is not worth 
> > merging?
> 
> Raise the quality.  Then the volume will automatically decrease.
> 
> Which leads us to...  the volume isn't a problem per-se.  The problem is
> quality.  It's the fact that they vary inversely which makes us say "slow
> down".
> 
> So David's Subject: should have been "Do Better, please".  Slowing down is
> just a side-effect.  And, we expect, a tool.
> 
> 
> We should be discussing how to raise the quality of our work.

I violently agree.

One of the (obvious?) ways in which we can raise the quality of the code
overall is to spend more time on reviewing the others' code and discussing that
code.  It follows from my experience that the quality of patches improves
dramatically if they are discussed while being developed.  Of course, that
requires time, but it's time well spent.

For this reason, there should be a mechanism in place that will encourage
people to review the existing code, even the code that hasn't changed for
a long time, and to review and discuss patches submitted by the other people
instead of producing new code.

Also, the patches that were thoroughly discussed during their development
should be regarded as more trustworthy than the ones that were not discussed
at all.
