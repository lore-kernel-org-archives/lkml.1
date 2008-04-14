Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYDNGkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYDNGkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYDNGj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:39:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46546
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYDNGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:39:58 -0400
Date: Sun, 13 Apr 2008 23:39:59 -0700 (PDT)
Message-Id: <20080413.233959.217341225.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: viro@ZenIV.linux.org.uk, w@1wt.eu, david@lang.hm, sclark46@earthlink.net,
       johnpol@2ka.mipt.ru, rjw@sisk.pl, tilman@imap.cc,
       Valdis.Kletnieks@vt.edu, lkml@rtr.ca, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       git@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080413232441.e216a02c.akpm@linux-foundation.org>
References: <20080414043939.GA6862@1wt.eu>
	<20080414053943.GU9785@ZenIV.linux.org.uk>
	<20080413232441.e216a02c.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 13 Apr 2008 23:24:41 -0700

> Do you agree with these impressions, or not?

I think things are improving.

I wrote or merged in ~10 bugs in the last hour, for example.

And I also agree with Al's point, which was embedded in his humorous
and obviously sarcastic suggestions, in that adding beurocracy isn't
the answer.  We already have too much and it scares developers away.

Sure you don't want crap getting into the tree (for too long), but it
is important to be careful to define crap properly.  For example,
inundating patch submitters with more requirements, especially ones
involving automatons like checkpatch, is in the end bad.

We can improve the quality of stuff going in and be flexible at the
same time.
