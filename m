Return-Path: <linux-kernel-owner+w=401wt.eu-S971781AbXHMMZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971781AbXHMMZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967963AbXHMGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:48:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2573 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968072AbXHMGsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:48:02 -0400
Subject: Re: [PATCH] [374/2many] MAINTAINERS - PCNET32 NETWORK DRIVER
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070812.233630.00455011.davem@davemloft.net>
References: <46bffb4c.nrqicrPs7IJXlgQ0%joe@perches.com>
	 <20070812.233630.00455011.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 23:46:49 -0700
Message-Id: <1186987609.10249.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 23:36 -0700, David Miller wrote:
> Ok, 374 patches is just rediculious.
> 
> So many patches eats up an enormous amount of mailing list resources,
> and for these patches in particular there are few reasons to split
> them up at all.  The fact that the split up landed you at 300+ patches
> is a very good indication of that.

More than ridiculous.  Completely agree.

I tried to send 1 patch over the last couple of days.
Unfortunately, it's > 100KB and disappears into the void.

How about 10 patches or so?

What about maintainer sign offs?

Personally, I don't think it's necessary, but for
the subsystem maintainers like you, if or when the
get_maintainers.pl get integrated into patch
generation mechanisms, you might get more emails.
Perhaps more than you want.

Suggestions?

One good thing by emailing all the listed maintainers,
I've gotten several bounces for invalid addresses.

