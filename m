Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXI3K22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXI3K22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXI3K2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:28:19 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:50608 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497AbXI3K2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:28:19 -0400
Date: Sun, 30 Sep 2007 12:28:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-ID: <20070930122816.5a677b2e@hyperion.delvare>
In-Reply-To: <20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20070929122530.5c45f743@hyperion.delvare>
	<20070929035156.cd6fe860.akpm@linux-foundation.org>
	<20070929112928.56a04641.randy.dunlap@oracle.com>
	<20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070929131317.6a8609dc.randy.dunlap@oracle.com>
	<20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, 29 Sep 2007 15:30:15 -0700, David Brownell wrote:
> > > > Let's kill it, please.  (i.e., ACK)
> > > 
> > > But ... why?  What value could needless parens provide?

By definition of "needless", none. But the question is precisely
whether the parentheses are always needless. The way your formulate
your question suggests that you aren't actually interested in
discussing the matter, so I am wondering why are you taking part at all.

> > Who says that needless parens could provide value?
> 
> Jean, which is why he submitted the patch.

No, I didn't. I said that parentheses were sometimes useful. You said
that parentheses were usually needless (which isn't that different,
BTW.) Combining both statements into "useless parentheses provide
value" is a logical flaw. And attributing it to me is dishonest.

> (...)
> > > I'd kind of think a change like this should have some
> > > positive motivation.

My "positive motivation" was that this statement, as is, is more
confusing than helpful. As a matter of fact, it led us to disagree on a
patch you sent. And I would like contributors to focus on the more
important parts of CodingStyle. If someone wants to improve the
statement instead of removing it, that's fine with me, but not having
the time to work on this, I proposed the removal.

> I would agree that line could be improved to say that messages
> should not be needlessly large.

It does already:

"Make the messages concise, clear, and unambiguous."

-- 
Jean Delvare
