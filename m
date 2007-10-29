Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXJ2BSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXJ2BSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXJ2BR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:17:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35976
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXJ2BR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:17:57 -0400
Date: Sun, 28 Oct 2007 18:17:59 -0700 (PDT)
Message-Id: <20071028.181759.148922611.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, herbert@gondor.apana.org.au
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710282351.56284.rjw@sisk.pl>
References: <200710282351.56284.rjw@sisk.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 28 Oct 2007 23:51:55 +0100

> Subject		: Settings to /proc/sys/net/ipv[46]/conf/all are not propagated. via sysctl too
> Submitter	: Serge van den Boom <svdb+linux-kernel-bugs@stack.nl>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9224
> Handled-By	: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>

I am to understand, from a reply from Herbert Xu, that this issue has
existed a long time, definitely since before 2.6.22, therefore it
doesn't belong on the regression list.

The bug reporter says something that drives me a little batty, which
is probably what got this onto the regression list.  He says "2.6.22
(not sure)" as the most recent kernel where the problem didn't occur.

People should list no version at all if they don't know, otherwise
we'll just get more bogons on the regression list.
