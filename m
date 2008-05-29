Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYE2GJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYE2GJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYE2GJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:09:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57496
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYE2GJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:09:39 -0400
Date: Wed, 28 May 2008 23:09:34 -0700 (PDT)
Message-Id: <20080528.230934.131215087.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: dwmw2@infradead.org, penberg@cs.helsinki.fi,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: David Miller <davem@davemloft.net>
In-Reply-To: <1212014127.3445.115.camel@localhost.localdomain>
References: <1212010931.3445.103.camel@localhost.localdomain>
	<1212013125.2236.58.camel@shinybook.infradead.org>
	<1212014127.3445.115.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 28 May 2008 17:35:27 -0500

> However, even if there were no recruitment problem at all, getting more
> people involved is always better because it means more contributions.

This is not true at all.

If people are getting involved, just for the sake of being involved,
which there is strong evidence of, then it's not a positive thing.

We want people who are passionate about doing things with the
kernel, are self-motivated, and frankly don't need a ton of hand
holding and do not work on things that require absolutely no
thinking.

Look at anyone who is extremely nimble with the kernel, and ask them
what they worked on to get going with development.  Did Andrew Morton
fixup whitespace errors when he was starting to become familiar with
the tree?  Did I?  No, none of us did this stuff.  We read over the
code and learned how it worked, did a port, optimized a lookup
algorithm somewhere.

Consistently we see people turding with whitespace, and not breaking
out of that cycle.  That is a problem.
