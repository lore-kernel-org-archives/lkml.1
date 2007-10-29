Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXJ2Bin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXJ2Bin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJ2Big
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:38:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXJ2Bif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:38:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Date: Mon, 29 Oct 2007 02:54:51 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, herbert@gondor.apana.org.au
References: <200710282351.56284.rjw@sisk.pl> <20071028.181759.148922611.davem@davemloft.net>
In-Reply-To: <20071028.181759.148922611.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710290254.51869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 29 October 2007 02:17, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 28 Oct 2007 23:51:55 +0100
> 
> > Subject		: Settings to /proc/sys/net/ipv[46]/conf/all are not propagated. via sysctl too
> > Submitter	: Serge van den Boom <svdb+linux-kernel-bugs@stack.nl>
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9224
> > Handled-By	: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> 
> I am to understand, from a reply from Herbert Xu, that this issue has
> existed a long time, definitely since before 2.6.22, therefore it
> doesn't belong on the regression list.

I have removed it from the list.

Thanks,
Rafael
