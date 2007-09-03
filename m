Return-Path: <linux-kernel-owner+w=401wt.eu-S1750754AbXICRSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754AbXICRSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXICRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:18:38 -0400
Received: from khc.piap.pl ([195.187.100.11]:35429 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbXICRSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:18:37 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: davids@webmaster.com, espie@nerim.net, linux-kernel@vger.kernel.org
Subject: Re: GPL weasels and the atheros stink
References: <MDEHLPKNGKAHNMBLJOLKMECFGJAC.davids@webmaster.com>
	<200709022257.54663.dhazelton@enter.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 03 Sep 2007 19:18:35 +0200
In-Reply-To: <200709022257.54663.dhazelton@enter.net> (Daniel Hazelton's message of "Sun, 2 Sep 2007 22:57:54 -0400")
Message-ID: <m3bqcjwtuc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> Then go yell at Mr. Floeter. The code is dual-licensed and he put
> BSD-License 
> only code in it. Because that's the *EXACT* *SAME* thing you're talking 
> about.

Actually it is not.

Dual BSD/GPL licence essentially means BSD, because rights given by
BSD are a superset of these by GPL.

You can legally take BSD code (or BSD/GPL, which is the same thing)
and include it in GPL project (or even in closed source one).

You can't legally take GPL code and include it in BSD project (or in
GPL/BSD), because GPL forbids derivative works distributed under less
(or more) restrictive licence than itself.


Being distributed under GPL/BSD legally equals "pure" BSD (BSD allows
restricting downstream, while GPL doesn't).

If some file in Linux reads "GPL/BSD" then it's, in fact, under BSD
licence. Crazy, isn't it? :-)



The other thing is copyright notices. I think one can't legally
alter someone else's licence conditions (in his/her name), unless
something like that is explicitly permitted.

However, we're talking about derivative works. A derivative
work may be, for example, GPL-licenced:

"Copyright (C) 1234 Joe the GPL lover
licenced under the GPL as published"

but could lawfully use code originally licenced under BSD:

"Portions copyright (C) 1234 Bill the BSD lover
originally licenced under no-ad BSD"

Thus his (Joe's) work is GPL only, but Bill's licence notice is
intact as required by it (BSD).


IANAL, maybe you (all of us) should consult one if required.
-- 
Krzysztof Halasa
