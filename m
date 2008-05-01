Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYEABnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYEABnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYEABnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:43:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYEABnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:43:47 -0400
Date: Wed, 30 Apr 2008 18:43:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430183149.78d97597.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
 <20080430183149.78d97597.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Andrew Morton wrote:
> 
> eh?  I argued the opposite: that increasing quality will as a side-effect
> slow things down.

Yes, my bad, I realized that when I read through my message and already 
sent out a fix for my buggy email ;)

> If we simply throttled things, people would spend more time watching the
> shopping channel while merging smaller amounts of the same old crap.

I agree totally. And although some of the time would probably _also_ be 
spent on the frustrating crap that was designed to do the throttling, that 
isn't much more productive than watching the shopping channel would be ...

		Linus
