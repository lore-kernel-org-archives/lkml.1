Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbXDOXyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbXDOXyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXDOXyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:54:17 -0400
Received: from holomorphy.com ([66.93.40.71]:48917 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXDOXyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:54:15 -0400
Date: Sun, 15 Apr 2007 16:54:21 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415235421.GF2986@holomorphy.com>
References: <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu> <20070415192046.GA7504@elte.hu> <20070415193531.GD2986@holomorphy.com> <20070415195748.GA16004@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415195748.GA16004@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> I've been suggesting testing CPU bandwidth allocation as influenced by 
>> nice numbers for a while now for a reason.

On Sun, Apr 15, 2007 at 09:57:48PM +0200, Ingo Molnar wrote:
> Oh I was very much testing "CPU bandwidth allocation as influenced by 
> nice numbers" - it's one of the basic things i do when modifying the 
> scheduler. An automated tool, while nice (all automation is nice) 
> wouldnt necessarily show such bugs though, because here too it needed 
> thousands of running tasks to trigger in practice. Any volunteers? ;)

Worse comes to worse I might actually get around to doing it myself.
Any more detailed descriptions of the test for a rainy day?


-- wli
