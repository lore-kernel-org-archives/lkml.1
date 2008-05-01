Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYEAOHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYEAOHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYEAOHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:07:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYEAOHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:07:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 16:06:59 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <4819CB85.2040809@s5r6.in-berlin.de>
In-Reply-To: <4819CB85.2040809@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011607.00441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > And what do you think is happening _after_ the merge window closes, when
> > we're supposed to be fixing bugs?  People work on new code.
> 
> That's not correct.  People work on new code before, during, and after 
> the merge window.  They also fix bugs before, during, and after it.

I'm not quite sure if really all of them do.  Well, I should have said "some
people" instead of just "poeple" to be fair.

> > And, in fact, they have to, if they want to be ready for the next merge
> > window.
> 
> To be ready for the next merge window just means to know which code is 
> sufficiently reviewed and tested, and to have it queued up and if 
> necessary synchronized with other pending code.

Of course it _should_ mean that, but the fact is unreviewed and untested
patches are pushed to Linus, at least from time to time.  [Even some known
broken patches were pushed to Linus in the past, but we can't prevent that from
happening by any process changes.]

Thanks,
Rafael
