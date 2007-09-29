Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXI2UPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXI2UPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXI2UPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:15:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19493 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbXI2UPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:15:39 -0400
Date: Sat, 29 Sep 2007 13:13:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-Id: <20070929131317.6a8609dc.randy.dunlap@oracle.com>
In-Reply-To: <20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20070929122530.5c45f743@hyperion.delvare>
	<20070929035156.cd6fe860.akpm@linux-foundation.org>
	<20070929112928.56a04641.randy.dunlap@oracle.com>
	<20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 11:53:06 -0700 David Brownell wrote:

> > From randy.dunlap@oracle.com  Sat Sep 29 11:40:17 2007
> >
> > Let's kill it, please.  (i.e., ACK)
> 
> But ... why?  What value could needless parens provide?

Who says that needless parens could provide value?

> "Yet Another Subtle And Hard To Fix Source Of Bloat" is
> not a plus.

ISTM that we agree.

> I'd kind of think a change like this should have some
> positive motivation.

"Me, I agree that numbers in parens don't usually make sense for
kernel messages."

It's too trivial to be included in CodingStyle.

---
~Randy
