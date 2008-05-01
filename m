Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbYEALA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbYEALA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYEALAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:00:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYEALAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:00:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 12:59:46 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430183149.78d97597.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011259.47343.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
> > 
> > eh?  I argued the opposite: that increasing quality will as a side-effect
> > slow things down.
> 
> Yes, my bad, I realized that when I read through my message and already 
> sent out a fix for my buggy email ;)
> 
> > If we simply throttled things, people would spend more time watching the
> > shopping channel while merging smaller amounts of the same old crap.
> 
> I agree totally. And although some of the time would probably _also_ be 
> spent on the frustrating crap that was designed to do the throttling, that 
> isn't much more productive than watching the shopping channel would be ...

Okay, so what exactly are we going to do to address the issue that I described
in the part of my last message that you skipped?

Rafael
