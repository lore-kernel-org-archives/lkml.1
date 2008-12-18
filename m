Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYLRXKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYLRXKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYLRXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:10:32 -0500
Received: from waste.org ([66.93.16.53]:41463 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYLRXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:10:31 -0500
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au>
References: <E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 17:06:13 -0600
Message-Id: <1229641573.3726.563.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 09:44 +1100, Herbert Xu wrote:
> Matt Mackall <mpm@selenic.com> wrote:
> > These debug messages are uninformative and extremely alarming. Rather
> > than reporting a peer as a treacherous attacker, report it more
> > correctly as simply broken. 
> 
> What's next, you're going to remove "printer on fire" as well?
> This message has been there for eons and is part of Linux lore.

No one has printer ports any more so it hardly seems worth the trouble.

Most people won't actually think their printer is on fire. But most
people WILL think there is serious cause for concern when they see this
for the first time in dmesg. Many will search the net for explanations
and come away confused and not entirely reassured. And at least one
clueless guy will call the police because he still thinks he's under
attack.

Now that certainly fits my definition of amusing and if my goal for
Linux was to amuse myself at the expense of users, I'd be all for
keeping it[1]. But perversely, I actually want users to enjoy their
Linux experience.

[1] Hell, I'd probably even get them to use git.
-- 
Mathematics is the supreme nostalgia of our time.

