Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbYDQS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbYDQS4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYDQS4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:56:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38465 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYDQSz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:55:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Linux 2.6.25
Date: Thu, 17 Apr 2008 20:56:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org> <alpine.DEB.1.10.0804162120130.17133@asgard>
In-Reply-To: <alpine.DEB.1.10.0804162120130.17133@asgard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804172056.34841.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of April 2008, david@lang.hm wrote:
> On Wed, 16 Apr 2008, Linus Torvalds wrote:
> 
> > It's been long promised, but there it is now. Special thanks to Ingo who
> > found and fixed a nasty-looking regression that turned out to not be a
> > regression at all, but an old bug that just had not been triggering as
> > reliably before.
> >
> > That said, that was just the last particular regression fix I was holding
> > things up for, and it's not like there weren't a lot of other fixes too,
> > they just didn't end up being the final things that triggered my
> > particular worries.
> 
> Rafael,
>    could you post the list of the remaining known regressions in 2.6.25. a 
> few days ago there were about 2 dozen left, but there was a flurry of 
> activity (patching, identifying some as not regressions, others as being 
> fixed, etc) so I've lost track of what's left

Yes, I will post that later today.

Thanks,
Rafael
