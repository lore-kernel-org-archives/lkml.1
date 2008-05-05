Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYEEDEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYEEDEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYEEDEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:04:39 -0400
Received: from ozlabs.org ([203.10.76.45]:35768 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYEEDEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:04:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Slow DOWN, please!!!
Date: Mon, 5 May 2008 13:04:31 +1000
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <20080430.142137.236846072.davem@davemloft.net> <20080430221936.GA27292@elte.hu>
In-Reply-To: <20080430221936.GA27292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051304.31345.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 08:19:36 Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> > And the people who stick these regressions into the tree need more
> > negative reinforcement.
>
> What we need is not 'negative reinforcement'.

Over time as patches succeed more I reduce testing so I can "get things done 
faster".  Eventually I screw up, and get more cautious on checking.  It's a 
dynamic balance.

With reduced review comes sloppier code.  If we can't increase review, we can 
at least increase the penalty for screwing up when I do get caught.

If vger dropped all my emails for a week after I broke the kernel, I'd be far 
more careful OR I'd find efficient ways to avoid doing that (like increasing 
review, or automated testing).  Either way, it's a win.

But I'm sure everyone else is far more disciplined than I...
Rusty.
