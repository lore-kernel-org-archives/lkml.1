Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYDQEQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYDQEQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYDQEQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:16:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:49223 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYDQEQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:16:32 -0400
Date: Wed, 16 Apr 2008 21:22:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25
In-Reply-To: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0804162120130.17133@asgard>
References: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Linus Torvalds wrote:

> It's been long promised, but there it is now. Special thanks to Ingo who
> found and fixed a nasty-looking regression that turned out to not be a
> regression at all, but an old bug that just had not been triggering as
> reliably before.
>
> That said, that was just the last particular regression fix I was holding
> things up for, and it's not like there weren't a lot of other fixes too,
> they just didn't end up being the final things that triggered my
> particular worries.

Rafael,
   could you post the list of the remaining known regressions in 2.6.25. a 
few days ago there were about 2 dozen left, but there was a flurry of 
activity (patching, identifying some as not regressions, others as being 
fixed, etc) so I've lost track of what's left

David Lang
