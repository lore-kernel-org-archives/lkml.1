Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZIUPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZIUPOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZIUPOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:14:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbZIUPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:14:16 -0400
Date: Mon, 21 Sep 2009 08:13:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Linux 2.6.31-rc9
In-Reply-To: <20090921083609.GA16048@elte.hu>
Message-ID: <alpine.LFD.2.01.0909210812150.4950@localhost.localdomain>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain> <20090908112003.GA30754@elte.hu> <alpine.LFD.2.01.0909081720430.7458@localhost.localdomain> <20090921083609.GA16048@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Sep 2009, Ingo Molnar wrote:
> 
> Just to refresh this older thread - is this warning supposed to be gone 
> in latest -git? It still triggers occasionally in -tip tests:

No change so far, I've been busy merging etc (and this week I'll be busy 
at plumbers/linuxcon). 

There's been tty layer updates, but they are all trivial stuff, not the 
deep locking crap.

		Linus
